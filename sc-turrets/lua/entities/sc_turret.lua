---@diagnostic disable: undefined-field, param-type-mismatch
---@class SCTurret : Entity
---@field Active boolean
---@field AutoStart boolean
---@field BlinkState boolean
---@field CarriedByPlayer boolean
---@field CloseSequence integer
---@field Dead boolean
---@field DeploySequence integer
---@field DestructStartTime number
---@field Enabled boolean
---@field EyeGlow Entity|nil
---@field EyeState string
---@field FireSequence integer
---@field GoalAngles Angle
---@field IdleClosedSequence integer
---@field IdleOpenSequence integer
---@field LastSightTime number
---@field NextActivateSoundTime number
---@field NextSearchTime number
---@field NextShotTime number
---@field PingTime number
---@field RetireFast boolean
---@field SCHealth number|nil
---@field State string
---@field Target Entity|nil
---@field ThrashEndTime number
---@field _owner Player|nil
if SERVER then AddCSLuaFile() end

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "SC Turret"
ENT.Category = "SC Entity"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.DefaultHealth = 255
ENT.FieldOfView = 0.4
ENT.FireInterval = 0.08
ENT.PingInterval = 1
ENT.Range = 2048 -- 1200: Original (less than Combine Soldier's max look distance, which is 2048)
ENT.RetireDelay = 5
ENT.RetireFastDelay = 2
ENT.SearchDelayMax = 0.4
ENT.SearchDelayMin = 0.2
ENT.SuppressDelay = 2
ENT.SelfDestructDuration = 4
ENT.ThinkInterval = 0.05
ENT.ModelName = "models/sc_turret/floor_turret.mdl"
ENT.GlowSprite = "sprites/glow1.vmt"
ENT.MuzzleAttachmentNames = { "eyes", "muzzle", "barrel" }
ENT.EyeAttachmentNames = { "light", "eye", "eyes" }
ENT.SkinNumber = 0

local SF_AUTOACTIVATE = 0x00000020
local SF_STARTINACTIVE = 0x00000040
local SF_FASTRETIRE = 0x00000080
local SF_OUT_OF_AMMO = 0x00000100

local STATE_ACTIVE = "active"
local STATE_AUTO_SEARCH = "auto_search"
local STATE_DEPLOY = "deploy"
local STATE_DISABLED = "disabled"
local STATE_INACTIVE = "inactive"
local STATE_RETIRE = "retire"
local STATE_SEARCH = "search"
local STATE_SELF_DESTRUCT = "self_destruct"
local STATE_TIPPED = "tipped"

local EYE_ALARM = "alarm"
local EYE_DEAD = "dead"
local EYE_DISABLED = "disabled"
local EYE_DORMANT = "dormant"
local EYE_SEE_TARGET = "see_target"
local EYE_SEEKING_TARGET = "seeking_target"

local ANGLE_ZERO = Angle(0, 0, 0)

local SOUNDS = {
  Activate = "SCTurret.Activate",
  Alarm = "SCTurret.Alarm",
  AlarmPing = "SCTurret.AlarmPing",
  Alert = "SCTurret.Alert",
  Deploy = "SCTurret.Deploy",
  Destruct = "SCTurret.Destruct",
  Die = "SCTurret.Die",
  DryFire = "SCTurret.DryFire",
  Move = "SCTurret.Move",
  Ping = "SCTurret.Ping",
  Retire = "SCTurret.Retire",
  Retract = "SCTurret.Retract",
  Shot = "SCTurret.ShotSounds"
}

local PART_BONES = {
  {
    "ValveBiped.Bip01_Head1",
    "ValveBiped.HC_Body_Bone"
  },
  {
    "ValveBiped.Bip01_Spine2",
    "ValveBiped.Bip01_Spine1",
    "ValveBiped.Bip01_Pelvis"
  },
  {
    "ValveBiped.Bip01_L_UpperArm",
    "ValveBiped.Bip01_R_UpperArm",
    "ValveBiped.Bip01_L_Forearm",
    "ValveBiped.Bip01_R_Forearm",
    "ValveBiped.Bip01_L_Thigh",
    "ValveBiped.Bip01_R_Thigh",
    "ValveBiped.Bip01_L_Calf",
    "ValveBiped.Bip01_R_Calf"
  },
  {
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_L_Foot",
    "ValveBiped.Bip01_R_Foot"
  }
}

local HITGROUP_AIM_GROUPS = {
  [HITGROUP_HEAD] = 1,
  [HITGROUP_CHEST] = 2,
  [HITGROUP_STOMACH] = 2,
  [HITGROUP_GEAR] = 2,
  [HITGROUP_LEFTARM] = 3,
  [HITGROUP_RIGHTARM] = 3,
  [HITGROUP_LEFTLEG] = 3,
  [HITGROUP_RIGHTLEG] = 3
}

local TRACE_PASSABLE_BREAKABLES = {
  func_breakable = true,
  func_breakable_surf = true
}

list.Set("NPC", "sc_turret", {
  Category = ENT.Category,
  Class = "sc_turret",
  Health = tostring(ENT.DefaultHealth),
  Model = ENT.ModelName,
  Name = ENT.PrintName,
  Offset = 8,
  OnFloor = true,
  Rotate = Angle(0, 180, 0)
})

if CLIENT then
  function ENT:Draw(flags)
    self:DrawModel(flags)
  end

  return
end

---@param ply Player
---@param ent Entity
hook.Add("PlayerSpawnedNPC", "sc_turret_set_owner", function(ply, ent)
  if IsValid(ent) and ent:GetClass() == "sc_turret" then
    ---@cast ent SCTurret
    ent._owner = ply
  end
end)

local STATE_THINK = {}
local GetMuzzlePos

---@param flags integer
---@param flag integer
---@return boolean
local function HasFlag(flags, flag)
  return bit.band(flags, flag) ~= 0
end

---@param ent Entity|nil
---@return boolean
local function IsValidOwner(ent)
  return ent ~= nil and IsValid(ent) and ent:IsPlayer()
end

---@param ent Entity|nil
---@return boolean
local function IsLiveNpc(ent)
  return ent ~= nil and IsValid(ent) and ent:Health() > 0 and (ent:IsNPC() or ent:IsNextBot())
end

---@param owner Player
---@param target Entity
---@return boolean
local function HatesOwner(owner, target)
  ---@cast target NPC
  return target:Disposition(owner) == D_HT
end

---@param self SCTurret
---@param target Entity
---@return boolean
local function IsInViewCone(self, target)
  local offset = target:WorldSpaceCenter() - GetMuzzlePos(self)
  if offset:IsZero() then return true end
  return Angle(0, self:GetAngles().y, 0):Forward():Dot(offset:GetNormalized()) >= self.FieldOfView
end

---@return number
local function GetPistolDamage()
  if ConVarExists("sk_npc_dmg_pistol") then
    return math.max(GetConVar("sk_npc_dmg_pistol"):GetFloat(), 1) * 2
  end

  return 10
end

---@param target Entity
---@param boneName string
---@return Vector|nil
local function GetBonePosition(target, boneName)
  local bone = target:LookupBone(boneName)
  if bone == nil then return nil end

  local pos = target:GetBonePosition(bone)
  if pos == nil or pos == target:GetPos() then return nil end
  return pos
end

---@param target Entity
---@param pos Vector
---@return boolean
local function IsInsideTargetBounds(target, pos)
  local mins, maxs = target:WorldSpaceAABB()
  local padding = 8
  return pos.x >= mins.x - padding and pos.x <= maxs.x + padding
      and pos.y >= mins.y - padding and pos.y <= maxs.y + padding
      and pos.z >= mins.z - padding and pos.z <= maxs.z + padding
end

---@param target Entity
---@param hitbox integer
---@param set integer
---@return Vector|nil
local function GetHitBoxCenter(target, hitbox, set)
  local mins, maxs = target:GetHitBoxBounds(hitbox, set)
  if mins == nil or maxs == nil then return nil end

  local bone = target:GetHitBoxBone(hitbox, set)
  if bone == nil or bone < 0 then return nil end

  local matrix = target:GetBoneMatrix(bone)
  if matrix == nil then return nil end

  local center = (mins + maxs) * 0.5
  local pos = LocalToWorld(center, ANGLE_ZERO, matrix:GetTranslation(), matrix:GetAngles())
  if not IsInsideTargetBounds(target, pos) then return nil end
  return pos
end

---@param target Entity
---@return Vector[][]
local function BuildAimGroups(target)
  local groups = {
    {},
    { target:WorldSpaceCenter() },
    {},
    {},
    { target:NearestPoint(target:WorldSpaceCenter()) }
  }

  local hitBoxCount = target:GetHitBoxCount(0) or 0
  for hitbox = 0, hitBoxCount - 1 do
    local hitGroup = target:GetHitBoxHitGroup(hitbox, 0)
    local groupIndex = HITGROUP_AIM_GROUPS[hitGroup] or 5
    local pos = GetHitBoxCenter(target, hitbox, 0)
    if pos ~= nil then table.insert(groups[groupIndex], pos) end
  end

  for groupIndex, boneNames in ipairs(PART_BONES) do
    for _, boneName in ipairs(boneNames) do
      local pos = GetBonePosition(target, boneName)
      if pos ~= nil then table.insert(groups[groupIndex], pos) end
    end
  end

  local eyes = target:LookupAttachment("eyes")
  if eyes > 0 then
    local attachment = target:GetAttachment(eyes)
    if attachment ~= nil then table.insert(groups[1], attachment.Pos) end
  end

  table.insert(groups[1], target:EyePos())

  return groups
end

---@param target Entity
---@param aimPos Vector
---@param source Entity
---@param startPos Vector
---@param maxDistance number
---@return boolean
local function CanShootTarget(target, aimPos, source, startPos, maxDistance)
  local dir = aimPos - startPos
  if dir:IsZero() then return false end

  local filter = { source }
  local endPos = startPos + dir:GetNormalized() * maxDistance

  for _ = 0, 3 do
    local tr = util.TraceLine({
      endpos = endPos,
      filter = filter,
      mask = MASK_SHOT,
      start = startPos
    })

    if tr.Entity == target then return true end
    if not (IsValid(tr.Entity) and TRACE_PASSABLE_BREAKABLES[tr.Entity:GetClass()]) then return false end
    table.insert(filter, tr.Entity)
  end

  return false
end

---@param self SCTurret
---@return Player|nil
local function GetOwner(self)
  if IsValidOwner(self._owner) then return self._owner end
  return nil
end

---@param self SCTurret
---@return boolean
local function HasAmmo(self)
  return not HasFlag(self:GetSpawnFlags(), SF_OUT_OF_AMMO)
end

---@param self SCTurret
---@param sequence integer
local function ResetSequenceIfValid(self, sequence)
  if sequence >= 0 then self:ResetSequence(sequence) end
end

---@param self SCTurret
---@param names string[]
---@return integer
local function LookupSequenceByNames(self, names)
  for _, name in ipairs(names) do
    local sequence = self:LookupSequence(name)
    if sequence >= 0 then return sequence end
  end

  return -1
end

---@param self SCTurret
---@param names string[]
---@return integer, string|nil
local function LookupAttachmentByNames(self, names)
  for _, name in ipairs(names) do
    local attachment = self:LookupAttachment(name)
    if attachment > 0 then return attachment, name end
  end

  return 0, nil
end

---@return boolean
local function IsAiDisabled()
  local aiDisabled = GetConVar("ai_disabled")
  if aiDisabled == nil then return false end
  return aiDisabled:GetBool()
end

---@param self SCTurret
---@return Vector
function GetMuzzlePos(self)
  local attachmentId = LookupAttachmentByNames(self, self.MuzzleAttachmentNames)
  if attachmentId > 0 then
    local attachment = self:GetAttachment(attachmentId)
    if attachment ~= nil then return attachment.Pos end
  end

  return self:EyePos()
end

---@param self SCTurret
---@param target Entity
---@param startPos Vector
---@return Vector|nil
local function SelectAimPos(self, target, startPos)
  for _, group in ipairs(BuildAimGroups(target)) do
    for _, aimPos in ipairs(group) do
      if CanShootTarget(target, aimPos, self, startPos, self.Range) then return aimPos end
    end
  end

  return nil
end

---@param self SCTurret
---@param owner Player
---@return Entity|nil
local function FindEnemy(self, owner)
  local turretPos = self:GetPos()
  local bestTarget = nil
  local bestDist = self.Range * self.Range
  local muzzlePos = GetMuzzlePos(self)

  for _, target in ipairs(ents.FindInSphere(turretPos, self.Range)) do
    if target ~= self and IsLiveNpc(target) and target:GetClass() ~= self:GetClass() and HatesOwner(owner, target) then
      local dist = turretPos:DistToSqr(target:GetPos())
      if dist < bestDist and IsInViewCone(self, target) and SelectAimPos(self, target, muzzlePos) ~= nil then
        bestTarget = target
        bestDist = dist
      end
    end
  end

  return bestTarget
end

---@param self SCTurret
---@return Entity|nil
local function GetTarget(self)
  return self.Target
end

---@param self SCTurret
---@param target Entity|nil
local function SetTarget(self, target)
  self.Target = IsValid(target) and target or nil
end

---@param self SCTurret
---@param owner Player|nil
---@return Entity|nil
local function SearchEnemy(self, owner)
  if owner == nil then return nil end
  if CurTime() < (self.NextSearchTime or 0) then return GetTarget(self) end

  self.NextSearchTime = CurTime() + math.Rand(self.SearchDelayMin, self.SearchDelayMax)
  return FindEnemy(self, owner)
end

---@param self SCTurret
---@return boolean
local function OnSide(self)
  return self:GetUp():Dot(vector_up) < 0.5
end

---@param self SCTurret
---@param state string
local function SetEyeState(self, state)
  self.EyeState = state

  if not IsValid(self.EyeGlow) then
    local glow = ents.Create("env_sprite")
    if IsValid(glow) then
      glow:SetKeyValue("model", self.GlowSprite)
      glow:SetKeyValue("rendermode", "9")
      glow:SetKeyValue("renderamt", "160")
      glow:SetKeyValue("scale", "0.3")
      glow:SetParent(self)

      local attachment, attachmentName = LookupAttachmentByNames(self, self.EyeAttachmentNames)
      if attachment > 0 and attachmentName ~= nil then glow:Fire("SetParentAttachment", attachmentName) end
      glow:Spawn()
      glow:Activate()
      self.EyeGlow = glow
    end
  end

  local eyeGlow = self.EyeGlow
  if not IsValid(eyeGlow) then return end
  ---@cast eyeGlow Entity

  if state == EYE_SEE_TARGET then
    eyeGlow:SetKeyValue("rendercolor", "255 0 0")
    eyeGlow:SetKeyValue("renderamt", "164")
    eyeGlow:SetKeyValue("scale", "0.4")
  elseif state == EYE_SEEKING_TARGET then
    self.BlinkState = not self.BlinkState
    eyeGlow:SetKeyValue("rendercolor", "255 128 0")
    eyeGlow:SetKeyValue("renderamt", self.BlinkState and "164" or "64")
    eyeGlow:SetKeyValue("scale", self.BlinkState and "0.25" or "0.2")
  elseif state == EYE_DORMANT then
    eyeGlow:SetKeyValue("rendercolor", "0 255 0")
    eyeGlow:SetKeyValue("renderamt", "64")
    eyeGlow:SetKeyValue("scale", "0.1")
  elseif state == EYE_ALARM then
    self.BlinkState = not self.BlinkState
    eyeGlow:SetKeyValue("rendercolor", "255 0 0")
    eyeGlow:SetKeyValue("renderamt", self.BlinkState and "192" or "64")
    eyeGlow:SetKeyValue("scale", self.BlinkState and "0.75" or "0.25")
  else
    eyeGlow:SetKeyValue("renderamt", "0")
    eyeGlow:SetKeyValue("scale", "0.1")
  end
end

---@param self SCTurret
---@param state string
local function SetState(self, state)
  self.State = state
end

---@param self SCTurret
local function StopEmergencySounds(self)
  self:StopSound(SOUNDS.Alarm)
  self:StopSound(SOUNDS.AlarmPing)
end

---@param self SCTurret
---@return number
local function GetNextThinkDelay(self)
  if self.State == STATE_AUTO_SEARCH then return math.Rand(self.SearchDelayMin, self.SearchDelayMax) end
  if self.State == STATE_DISABLED then return 0.5 end
  if self.State == STATE_INACTIVE then return HasAmmo(self) and 0.25 or 1 end
  return self.ThinkInterval
end

---@param self SCTurret
local function Ping(self)
  if self.PingTime > CurTime() then return end

  self:EmitSound(SOUNDS.Ping)
  SetEyeState(self, EYE_SEEKING_TARGET)
  self.PingTime = CurTime() + self.PingInterval
end

---@param self SCTurret
local function DryFire(self)
  self:EmitSound(SOUNDS.DryFire)
  self:EmitSound(SOUNDS.Activate)
  self.NextShotTime = CurTime() + (math.random() > 0.5 and math.Rand(1, 2.5) or 0)
end

---@param self SCTurret
---@param aimPos Vector
local function FacePosition(self, aimPos)
  local dir = aimPos - GetMuzzlePos(self)
  if dir:IsZero() or Vector(dir.x, dir.y, 0):LengthSqr() < 1 then return end
  self.GoalAngles = dir:Angle()
  self:SetPoseParameter("aim_yaw", math.AngleDifference(self.GoalAngles.y, self:GetAngles().y))
  self:SetPoseParameter("aim_pitch", math.Clamp(-self.GoalAngles.x, -28, 28))
end

---@param self SCTurret
---@param enemy Entity
---@param aimPos Vector
local function Shoot(self, enemy, aimPos)
  if not HasAmmo(self) then
    DryFire(self)
    return
  end

  local muzzlePos = GetMuzzlePos(self)
  if enemy ~= self and not CanShootTarget(enemy, aimPos, self, muzzlePos, self.Range) then return end

  local dir = (aimPos - muzzlePos):GetNormalized()

  ResetSequenceIfValid(self, self.FireSequence)
  self:EmitSound(SOUNDS.Shot)
  self:FireBullets({
    Attacker = self,
    Damage = GetPistolDamage(),
    Dir = dir,
    Force = 2,
    Num = 1,
    Src = muzzlePos,
    Spread = vector_origin,
    Tracer = 1
  })
  local doMuzzleFlash = self.DoMuzzleFlash
  if isfunction(doMuzzleFlash) then doMuzzleFlash(self) end

  SetTarget(self, enemy)
end

---@param self SCTurret
---@return boolean
local function PreThink(self)
  self:FrameAdvance()

  if self.State == STATE_SELF_DESTRUCT then return false end
  if self.State == STATE_TIPPED or self.State == STATE_INACTIVE then return false end
  if self.CarriedByPlayer then return false end
  if not OnSide(self) then return false end

  SetTarget(self, nil)
  SetEyeState(self, HasAmmo(self) and EYE_SEE_TARGET or EYE_DEAD)
  self.ThrashEndTime = CurTime() + math.Rand(2, 2.5)
  self.PingTime = self.ThrashEndTime
  self:EmitSound(SOUNDS.Alarm)
  SetState(self, HasAmmo(self) and STATE_TIPPED or STATE_INACTIVE)
  return true
end

---@param self SCTurret
local function BreakApart(self)
  local origin = self:WorldSpaceCenter() + self:GetUp() * 12

  util.BlastDamage(self, self, origin, 80, 10)
  local effect = EffectData()
  effect:SetOrigin(origin)
  effect:SetScale(0.5)
  util.Effect("Explosion", effect, true, true)
  self:EmitSound(SOUNDS.Destruct)

  self:Remove()
end

---@param ply Player
---@param tr TraceResult
---@param className string
---@return Entity|nil
function ENT.SpawnFunction(ply, tr, className)
  if not tr.Hit then return nil end

  local ent = ents.Create(className)
  if not IsValid(ent) then return nil end
  ---@cast ent SCTurret

  ent:SetPos(tr.HitPos + tr.HitNormal * 8)
  ent:SetAngles(Angle(0, ply:EyeAngles().y + 180, 0))
  ent._owner = ply
  ent:Spawn()
  ent:Activate()

  return ent
end

---@param key string
---@param value string
function ENT:KeyValue(key, value)
  local lkey = string.lower(key)
  if lkey == "health" then
    self.SCHealth = tonumber(value) or self.SCHealth
  elseif lkey == "skin" or lkey == "skinnumber" then
    self.SkinNumber = tonumber(value) or self.SkinNumber
  elseif lkey == "model" or lkey == "modelname" then
    self.ModelName = value
  elseif lkey == "startdisabled" then
    if value == "1" or value == "true" then self:AddSpawnFlags(SF_STARTINACTIVE) end
  end
end

function ENT:Initialize()
  util.PrecacheModel(self.ModelName)
  for _, soundName in pairs(SOUNDS) do
    util.PrecacheSound(soundName)
  end

  self:SetModel(self.ModelName)
  self:SetSkin(self.SkinNumber)
  self:SetCollisionBounds(self:GetModelBounds())
  local health = self.SCHealth or self.DefaultHealth or 255
  self:SetHealth(health)
  self:SetMaxHealth(health)
  self:SetSolid(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetBloodColor(BLOOD_COLOR_MECH)
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetCollisionBounds(self:GetModelBounds())

  local phys = self:GetPhysicsObject()
  if IsValid(phys) then
    phys:Wake()
  end

  self.Active = false
  self.BlinkState = false
  self.CarriedByPlayer = false
  self.Dead = false
  self.Enabled = not HasFlag(self:GetSpawnFlags(), SF_STARTINACTIVE)
  self.AutoStart = self.Enabled or HasFlag(self:GetSpawnFlags(), SF_AUTOACTIVATE)
  self.RetireFast = HasFlag(self:GetSpawnFlags(), SF_FASTRETIRE)
  self.GoalAngles = self:GetAngles()
  self.LastSightTime = 0
  self.NextActivateSoundTime = 0
  self.NextShotTime = 0
  self.NextSearchTime = CurTime() + math.Rand(0.1, 0.3)
  self.PingTime = 0
  self.ThrashEndTime = 0

  self.CloseSequence = LookupSequenceByNames(self, { "retract", "close" })
  self.DeploySequence = LookupSequenceByNames(self, { "deploy", "open" })
  self.FireSequence = LookupSequenceByNames(self, { "fire", "shoot" })
  self.IdleClosedSequence = LookupSequenceByNames(self, { "idle", "idle_closed" })
  self.IdleOpenSequence = LookupSequenceByNames(self, { "idlealert", "idle_open", "alertidle" })
  ResetSequenceIfValid(self, self.IdleClosedSequence)

  if self.Enabled and not OnSide(self) then
    SetEyeState(self, EYE_DORMANT)
    SetState(self, STATE_AUTO_SEARCH)
  else
    SetEyeState(self, EYE_DISABLED)
    SetState(self, STATE_DISABLED)
  end

  self:NextThink(CurTime() + math.Rand(0.1, 0.3))
end

function ENT:OnRemove()
  StopEmergencySounds(self)
  if IsValid(self.EyeGlow) then self.EyeGlow:Remove() end
end

function ENT:IsNPC()
  return true
end

function ENT:IsNextBot()
  return false
end

function ENT:Name()
  return self.PrintName
end

function ENT:Nick()
  return self.PrintName
end

function ENT:Team()
  return -2
end

function ENT:Disposition()
  return D_NU
end

function ENT:DropWeapon()
end

function ENT:GetEnemy()
  return NULL
end

function ENT:SetEnemy()
end

function ENT:UpdateEnemyMemory()
end

---@param inputName string
---@param activator Entity
---@param caller Entity
---@param data string
---@return boolean|nil
function ENT:AcceptInput(inputName, activator, caller, data)
  local fn = self["Input" .. inputName]
  if isfunction(fn) then
    fn(self, activator, caller, data)
    return true
  end
end

function ENT:Toggle()
  if OnSide(self) or self.Dead then return end

  if self.Enabled then
    self:Disable()
  else
    self:Enable()
  end
end

function ENT:Enable()
  if self.Dead or self.State == STATE_SELF_DESTRUCT then return end

  self.Enabled = true
  if OnSide(self) then return end

  self.AutoStart = true
  SetState(self, STATE_DEPLOY)
end

function ENT:Disable()
  if OnSide(self) or self.Dead or self.State == STATE_SELF_DESTRUCT then return end

  self.Enabled = false
  self.AutoStart = false
  SetTarget(self, nil)
  SetState(self, self.Active and STATE_RETIRE or STATE_DISABLED)
end

function ENT:InputToggle()
  self:Toggle()
end

function ENT:InputEnable()
  self:Enable()
end

function ENT:InputDisable()
  self:Disable()
end

function ENT:InputDepleteAmmo()
  self:AddSpawnFlags(SF_OUT_OF_AMMO)
end

function ENT:InputRestoreAmmo()
  self:RemoveSpawnFlags(SF_OUT_OF_AMMO)
end

function ENT:InputSelfDestruct()
  self.DestructStartTime = CurTime()
  self.PingTime = CurTime()
  SetTarget(self, nil)
  SetEyeState(self, EYE_ALARM)
  SetState(self, STATE_SELF_DESTRUCT)
end

---@param useType integer
function ENT:Use(_, _, useType, _)
  if useType == USE_OFF then
    self:Disable()
  elseif useType == USE_ON then
    self:Enable()
  elseif useType == USE_TOGGLE then
    self:Toggle()
  end
end

---@param ply Player
function ENT:OnPhysGunPickup(ply)
  self.CarriedByPlayer = true
  self._owner = ply
end

---@param ply Player
function ENT:OnPhysGunDrop(ply)
  self.CarriedByPlayer = false
  self._owner = ply
end

---@param ply Player
function ENT:PostEntityPaste(ply)
  if IsValidOwner(ply) then self._owner = ply end
end

---@param dmginfo CTakeDamageInfo
---@return number
function ENT:OnTakeDamage(dmginfo)
  if self.Dead then return 0 end

  local damageType = dmginfo:GetDamageType()
  local forceScale = 1
  if bit.band(damageType, bit.bor(DMG_SLASH, DMG_CLUB, DMG_BLAST)) ~= 0 then
    forceScale = 2
  elseif bit.band(damageType, DMG_BULLET) ~= 0 and bit.band(damageType, DMG_BUCKSHOT) == 0 then
    forceScale = 2.5
  end

  local phys = self:GetPhysicsObject()
  if IsValid(phys) then
    phys:ApplyForceCenter(dmginfo:GetDamageForce() * forceScale)
  end

  local damage = dmginfo:GetDamage()
  self.LastSightTime = CurTime() + self.RetireDelay

  if self.Enabled and self.AutoStart and self.State == STATE_AUTO_SEARCH then
    SetState(self, STATE_DEPLOY)
  end

  return damage
end

---@param dmginfo CTakeDamageInfo|nil
function ENT:OnKilled(dmginfo)
  if self.Dead then return end
  self.Dead = true
  SetEyeState(self, EYE_DEAD)

  local attacker = dmginfo ~= nil and dmginfo:GetAttacker() or game.GetWorld()
  local inflictor = dmginfo ~= nil and dmginfo:GetInflictor() or attacker
  hook.Run("OnNPCKilled", self, attacker, inflictor)

  self:EmitSound(SOUNDS.Die)
  BreakApart(self)
end

function STATE_THINK.auto_search(self)
  if not self.Enabled then
    SetState(self, STATE_DISABLED)
    return
  end

  local owner = GetOwner(self)
  local enemy = SearchEnemy(self, owner)
  if enemy == nil then return end

  SetTarget(self, enemy)
  SetEyeState(self, EYE_SEE_TARGET)
  self:EmitSound(SOUNDS.Alert)
  SetState(self, STATE_DEPLOY)
end

function STATE_THINK.deploy(self)
  self.Active = true
  ResetSequenceIfValid(self, self.DeploySequence)
  self:EmitSound(SOUNDS.Deploy)
  SetEyeState(self, EYE_SEE_TARGET)
  self.LastSightTime = CurTime() + self.RetireDelay
  self.NextShotTime = CurTime() + 1
  SetState(self, STATE_SEARCH)
end

function STATE_THINK.search(self)
  ResetSequenceIfValid(self, self.IdleOpenSequence)

  local enemy = GetTarget(self)
  if not IsLiveNpc(enemy) then
    local owner = GetOwner(self)
    enemy = SearchEnemy(self, owner)
  end

  if IsLiveNpc(enemy) then
    SetTarget(self, enemy)
    self.NextShotTime = CurTime() + 0.1
    self.LastSightTime = 0
    SetEyeState(self, EYE_SEE_TARGET)

    if CurTime() > self.NextActivateSoundTime then
      self:EmitSound(SOUNDS.Activate)
      self.NextActivateSoundTime = CurTime() + 3
    end

    SetState(self, STATE_ACTIVE)
    return
  end

  if CurTime() > self.LastSightTime then
    self.LastSightTime = 0
    SetState(self, STATE_RETIRE)
    return
  end

  local bodyYaw = self:GetAngles().y
  local scan = Angle(math.sin(CurTime()) * 15, bodyYaw + math.sin(CurTime() * 2) * 60, 0)
  self.GoalAngles = scan
  self:SetPoseParameter("aim_yaw", math.AngleDifference(scan.y, bodyYaw))
  self:SetPoseParameter("aim_pitch", scan.x)
  Ping(self)
end

function STATE_THINK.active(self)
  local owner = GetOwner(self)
  local enemy = GetTarget(self)
  if owner == nil or not IsLiveNpc(enemy) or not HatesOwner(owner, enemy) or not IsInViewCone(self, enemy) then
    SetTarget(self, nil)
    self.LastSightTime = CurTime() + (self.RetireFast and self.RetireFastDelay or self.SuppressDelay)
    SetState(self, STATE_SEARCH)
    return
  end

  local muzzlePos = GetMuzzlePos(self)
  local aimPos = SelectAimPos(self, enemy, muzzlePos)
  if aimPos == nil then
    SetTarget(self, nil)
    self.LastSightTime = CurTime() + (self.RetireFast and self.RetireFastDelay or self.SuppressDelay)
    SetState(self, STATE_SEARCH)
    return
  end

  self.LastSightTime = CurTime() + self.RetireDelay
  FacePosition(self, aimPos)

  if CurTime() >= self.NextShotTime then
    self.NextShotTime = CurTime() + self.FireInterval
    Shoot(self, enemy, aimPos)
  else
    ResetSequenceIfValid(self, self.IdleOpenSequence)
  end
end

function STATE_THINK.retire(self)
  SetEyeState(self, EYE_DORMANT)
  ResetSequenceIfValid(self, self.CloseSequence)
  self:EmitSound(SOUNDS.Retire)
  self.Active = false
  SetTarget(self, nil)

  if self.AutoStart and self.Enabled then
    SetState(self, STATE_AUTO_SEARCH)
  else
    SetEyeState(self, EYE_DISABLED)
    SetState(self, STATE_DISABLED)
  end
end

function STATE_THINK.disabled(self)
  SetTarget(self, nil)
  SetEyeState(self, EYE_DISABLED)
  ResetSequenceIfValid(self, self.IdleClosedSequence)

  if OnSide(self) then
    SetEyeState(self, EYE_DEAD)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    SetState(self, STATE_INACTIVE)
  end
end

function STATE_THINK.tipped(self)
  SetTarget(self, nil)

  if not OnSide(self) then
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self:Enable()
    return
  end

  if CurTime() < self.ThrashEndTime then
    self.GoalAngles = Angle(math.Rand(-60, 60), self:GetAngles().y + math.Rand(-60, 60), 0)
    self:SetPoseParameter("aim_yaw", math.Rand(-60, 60))
    self:SetPoseParameter("aim_pitch", math.Rand(-60, 60))

    if CurTime() >= self.NextShotTime then
      self.NextShotTime = CurTime() + 0.05
      if HasAmmo(self) then
        Shoot(self, self, GetMuzzlePos(self) + self:GetForward() * self.Range)
      else
        DryFire(self)
      end
    end

    return
  end

  StopEmergencySounds(self)
  self:EmitSound(SOUNDS.Retract)
  SetEyeState(self, EYE_DEAD)
  self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
  SetState(self, STATE_INACTIVE)
end

function STATE_THINK.inactive(self)
  SetTarget(self, nil)
  StopEmergencySounds(self)

  if not OnSide(self) and self.Enabled then
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self:Enable()
    return
  end

  SetEyeState(self, EYE_DEAD)
end

function STATE_THINK.self_destruct(self)
  local elapsed = CurTime() - self.DestructStartTime
  if elapsed >= self.SelfDestructDuration then
    BreakApart(self)
    return
  end

  local progress = math.Clamp(elapsed / self.SelfDestructDuration, 0, 1)
  local beepDelay = Lerp(progress, 0.75, 0.1)
  if CurTime() > self.PingTime + beepDelay then
    self:EmitSound(SOUNDS.AlarmPing, 75, math.floor(Lerp(progress, 100, 225)))
    SetEyeState(self, EYE_ALARM)
    self.PingTime = CurTime()
    self:SetPoseParameter("aim_yaw", math.Rand(-60 * progress, 60 * progress))
    self:SetPoseParameter("aim_pitch", math.Rand(-60 * progress, 60 * progress))
  end
end

function ENT:Think()
  if IsAiDisabled() then
    self:NextThink(CurTime() + 0.1)
    return true
  end

  if not self.Dead and PreThink(self) then
    self:NextThink(CurTime() + GetNextThinkDelay(self))
    return true
  end

  local think = STATE_THINK[self.State]
  if think ~= nil then think(self) end

  self:NextThink(CurTime() + GetNextThinkDelay(self))
  return true
end
