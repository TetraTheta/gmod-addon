-- GLua implementation of MapBase's prop_interactable for map I/O compatibility
if SERVER then AddCSLuaFile() end
---@class ENT : Entity
---@field DefaultAnim string|nil
---@field HealthValue number
---@field IgnoreCommandsWhenLocked boolean
---@field InSequence string|nil
---@field Locked boolean
---@field LockedSequence string|nil
---@field LockedSound string|nil
---@field ModelName string|nil
---@field ModelScale number
---@field OutSequence string|nil
---@field PlaybackRate number
---@field PressedSound string|nil
---@field RadiusInteract boolean
---@field SetBodyGroup string|nil
---@field SetCooldown number
---@field SkinNumber integer
---@field SolidType integer
---@field StartDisabled boolean
---@field TouchInteraction boolean
---@field UseInteraction boolean
---@field UseMaxs Vector
---@field UseMins Vector
---@field _cooldown_time number
---@field _sequence_end_time number
---@field _sequence_state integer
DEFINE_BASECLASS("sc_anim")
ENT.Base = "sc_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Type = "anim"

if CLIENT then
  ---@return nil
  function ENT:Draw()
    self:DrawModel()
  end

  return
end
--
local SEQUENCE_NONE = 0
local SEQUENCE_IN = 1
local SEQUENCE_OUT = 2
local SEQUENCE_LOCKED = 3
local SEQUENCE_WAIT_OUT = 4
local SEQUENCE_ANIMATION = 5
local SF_DYNAMICPROP_DISABLE_COLLISION = 256
local SF_USE_INTERACTS = 512
local SF_TOUCH_INTERACTS = 1024
local SF_IGNORE_COMMANDS_WHEN_LOCKED = 2048
local SF_RADIUS_USE = 4096
local ZERO_VECTOR = Vector(0, 0, 0)
--
---@param value string|nil
---@return boolean
local function BooleanFromString(value)
  return value == "1" or value == "true"
end

---@param value string|nil
---@return Vector
local function VectorFromString(value)
  if not isstring(value) then return ZERO_VECTOR end
  ---@cast value string
  local x, y, z = value:match("^%s*(%-?[%d%.]+)%s+(%-?[%d%.]+)%s+(%-?[%d%.]+)%s*$")
  return Vector(tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0)
end

---@param ply Player
---@param tr TraceResult
---@param className string
---@return Entity|nil
function ENT.SpawnFunction(ply, tr, className)
  if not tr.Hit then return nil end
  local ent = ents.Create(className)
  if not IsValid(ent) then return nil end
  ent:SetPos(tr.HitPos + tr.HitNormal * 8)
  ent:SetAngles(Angle(0, ply:EyeAngles().y + 180, 0))
  ent:Spawn()
  ent:Activate()
  return ent
end

---@param flag integer
---@return nil
function ENT:SCAddInteractFlag(flag)
  self.SpawnFlags = bit.bor(self.SpawnFlags or self:GetSpawnFlags(), flag)
  self:SCRefreshInteractFlags()
end

---@return nil
function ENT:SCApplyCollision()
  local solidType = self.SolidType
  if solidType == 0 then
    self:SetSolid(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    return
  elseif solidType == 6 and self:GetModel() ~= nil and self:GetModel() ~= "" then
    self:SetMoveType(MOVETYPE_NONE)
    if self:PhysicsInitStatic(SOLID_VPHYSICS) then
      self:SetTrigger(self.TouchInteraction)
      return
    end
  end
  self:SetSolid(SOLID_OBB)
  self:SetMoveType(MOVETYPE_NONE)
  self:SetCollisionBounds(self:GetModelBounds())
  self:SetTrigger(self.TouchInteraction)
end

---@param key string
---@param value string
---@return nil
function ENT:SCApplyKeyValue(key, value)
  local lkey = key:lower()
  if lkey == "defaultanim" then
    self.DefaultAnim = value
  elseif lkey == "health" then
    self.HealthValue = tonumber(value) or self.HealthValue
  elseif lkey == "locked" then
    self.Locked = BooleanFromString(value)
  elseif lkey == "model" or lkey == "modelname" then
    self.ModelName = value
  elseif lkey == "modelscale" then
    self.ModelScale = tonumber(value) or self.ModelScale
  elseif lkey == "playbackrate" then
    self.PlaybackRate = tonumber(value) or self.PlaybackRate
  elseif lkey == "pressedsound" then
    self.PressedSound = value
  elseif lkey == "lockedsound" then
    self.LockedSound = value
  elseif lkey == "insequence" then
    self.InSequence = value
  elseif lkey == "outsequence" then
    self.OutSequence = value
  elseif lkey == "lockedsequence" then
    self.LockedSequence = value
  elseif lkey == "setbodygroup" then
    self.SetBodyGroup = value
  elseif lkey == "setcooldown" then
    self.SetCooldown = tonumber(value) or self.SetCooldown
  elseif lkey == "skin" or lkey == "skinnumber" then
    self.SkinNumber = tonumber(value) or self.SkinNumber
  elseif lkey == "solid" then
    self.SolidType = tonumber(value) or self.SolidType
  elseif lkey == "spawnflags" then
    self.SpawnFlags = tonumber(value) or 0
  elseif lkey == "startdisabled" then
    self.StartDisabled = BooleanFromString(value)
  elseif lkey == "targetname" then
    self:SetName(value)
  elseif lkey == "maxs" or lkey == "use_maxs" then
    self.UseMaxs = VectorFromString(value)
  elseif lkey == "mins" or lkey == "use_mins" then
    self.UseMins = VectorFromString(value)
  end
end

---@param soundName string|nil
---@return nil
function ENT:SCEmitSound(soundName)
  if not isstring(soundName) or soundName == "" then return end
  ---@cast soundName string
  self:EmitSound(soundName)
end

---@param flag integer
---@return boolean
function ENT:SCHasInteractFlag(flag)
  return bit.band(self.SpawnFlags or self:GetSpawnFlags(), flag) ~= 0
end

---@param activator Entity
---@return boolean
function ENT:SCIsUseInBounds(activator)
  if self.UseMins == ZERO_VECTOR or self.UseMaxs == ZERO_VECTOR then return true end
  if not IsValid(activator) or not activator:IsPlayer() then return true end
  ---@cast activator Player
  local hitPos = util.IntersectRayWithOBB(activator:EyePos(), activator:GetAimVector() * 1024, self:GetPos(), self:GetAngles(), self.UseMins, self.UseMaxs)
  return hitPos ~= nil
end

---@return nil
function ENT:SCRefreshInteractFlags()
  self.UseInteraction = self:SCHasInteractFlag(SF_USE_INTERACTS)
  self.TouchInteraction = self:SCHasInteractFlag(SF_TOUCH_INTERACTS)
  self.IgnoreCommandsWhenLocked = self:SCHasInteractFlag(SF_IGNORE_COMMANDS_WHEN_LOCKED)
  self.RadiusInteract = self:SCHasInteractFlag(SF_RADIUS_USE)
  self:SetTrigger(self.TouchInteraction)
end

---@param sequenceName string|nil
---@param reset boolean
---@param activator Entity|nil
---@return nil
function ENT:SCSetAnimation(sequenceName, reset, activator)
  if not isstring(sequenceName) or sequenceName == "" then return end
  ---@cast sequenceName string
  local sequence = self:LookupSequence(sequenceName)
  if sequence < 0 then return end
  self._sequence_state = SEQUENCE_ANIMATION
  if reset then
    self:ResetSequence(sequence)
  else
    self:SetSequence(sequence)
  end
  self:SetPlaybackRate(self.PlaybackRate)
  self._sequence_end_time = CurTime() + math.max(self:SequenceDuration(sequence), 0)
  self:TriggerOutput("OnAnimationBegun", activator or self)
  self:NextThink(CurTime() + 0.1)
end

---@param flag integer
---@return nil
function ENT:SCRemoveInteractFlag(flag)
  self.SpawnFlags = bit.band(self.SpawnFlags or self:GetSpawnFlags(), bit.bnot(flag))
  self:SCRefreshInteractFlags()
end

---@param sequenceName string|nil
---@param state integer
---@param activator Entity|nil
---@return nil
function ENT:SCStartSequence(sequenceName, state, activator)
  if not isstring(sequenceName) or sequenceName == "" then return end
  ---@cast sequenceName string
  local sequence = self:LookupSequence(sequenceName)
  if sequence < 0 then return end
  self._sequence_state = state
  self:ResetSequence(sequence)
  self:SetCycle(0)
  self:SetPlaybackRate(self.PlaybackRate)
  self._sequence_end_time = CurTime() + math.max(self:SequenceDuration(sequence), 0)
  self:TriggerOutput("OnAnimationBegun", activator or self)
  self:NextThink(CurTime() + 0.1)
end

---@param activator Entity
---@param locked boolean
---@return nil
function ENT:SCUse(activator, locked)
  local cooldownTime
  if self.SetCooldown == -1 and not locked then
    cooldownTime = math.huge
  elseif self.SetCooldown == -1 then
    cooldownTime = CurTime() + 1
  else
    cooldownTime = CurTime() + self.SetCooldown
  end
  -- Block synchronous !self Press outputs before firing map I/O.
  self._cooldown_time = math.huge
  if locked then
    self:TriggerOutput("OnLockedUse", activator)
    self:SCEmitSound(self.LockedSound)
    self:SCStartSequence(self.LockedSequence, SEQUENCE_LOCKED, activator)
  else
    self:TriggerOutput("OnPressed", activator)
    self:SCEmitSound(self.PressedSound)
    self:SCStartSequence(self.InSequence, SEQUENCE_IN, activator)
  end
  self._cooldown_time = cooldownTime
end

---@return nil
function ENT:Initialize()
  self.HealthValue = self.HealthValue or 0
  self.IgnoreCommandsWhenLocked = false
  self.Locked = self.Locked or false
  self.ModelScale = self.ModelScale or 1
  self.PlaybackRate = self.PlaybackRate or 1
  self.RadiusInteract = false
  self.SetCooldown = self.SetCooldown or 1
  self.SkinNumber = self.SkinNumber or 0
  self.SolidType = self.SolidType or 6
  self.SpawnFlags = self.SpawnFlags or self:GetSpawnFlags()
  self.TouchInteraction = false
  self.UseInteraction = true
  self.UseMaxs = self.UseMaxs or ZERO_VECTOR
  self.UseMins = self.UseMins or ZERO_VECTOR
  self._cooldown_time = 0
  self._sequence_end_time = 0
  self._sequence_state = SEQUENCE_NONE
  self:SCRefreshInteractFlags()
  self:SetUseType(SIMPLE_USE)
  if isstring(self.ModelName) and self.ModelName ~= "" then
    if util.IsValidModel(self.ModelName) then
      util.PrecacheModel(self.ModelName)
      self:SetModel(self.ModelName)
    else
      ErrorNoHalt("[WARNING] [prop_interactable] Model may be unavailable: ", self.ModelName, "\n")
    end
  end
  self:SetModelScale(self.ModelScale, 0)
  self:SetSkin(self.SkinNumber)
  if isstring(self.SetBodyGroup) and self.SetBodyGroup ~= "" then
    self:SetBodygroup(0, tonumber(self.SetBodyGroup) or 0)
  end
  self:SCApplyCollision()
  if self:SCHasInteractFlag(SF_DYNAMICPROP_DISABLE_COLLISION) then
    self:AddSolidFlags(FSOLID_NOT_SOLID)
  end
  if self.StartDisabled then
    self:AddEffects(EF_NODRAW)
  end
  if isstring(self.DefaultAnim) and self.DefaultAnim ~= "" then
    local sequence = self:LookupSequence(self.DefaultAnim)
    if sequence >= 0 then
      self:ResetSequence(sequence)
      self:SetPlaybackRate(self.PlaybackRate)
    end
  end
end

---@param amount number
---@return nil
function ENT:SCSetHealthValue(amount)
  self.HealthValue = amount
  self:TriggerOutput("OnHealthChanged", self, tostring(self.HealthValue))
  if self.HealthValue <= 0 then
    self:InputBreak()
  end
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputAddHealth(activator, caller, data)
  self:SCSetHealthValue(self.HealthValue + (tonumber(data) or 0))
end

---@return nil
function ENT:InputBecomeRagdoll()
  local dmginfo = DamageInfo()
  dmginfo:SetAttacker(self)
  dmginfo:SetInflictor(self)
  if isfunction(self.BecomeRagdoll) and self:BecomeRagdoll(dmginfo) then return end
  self:Remove()
end

---@return nil
function ENT:InputBreak()
  self:TriggerOutput("OnBreak", self)
  self:Remove()
end

---@return nil
function ENT:InputDisable()
  self:InputTurnOff()
end

---@return nil
function ENT:InputDisableDraw()
  self:InputTurnOff()
end

---@return nil
function ENT:InputDisableCollision()
  self:AddSolidFlags(FSOLID_NOT_SOLID)
end

---@return nil
function ENT:InputDisablePhyscannonPickup()
end

---@return nil
function ENT:InputDisableReceivingFlashlight()
end

---@return nil
function ENT:InputDisableRadiusInteract()
  self:SCRemoveInteractFlag(SF_RADIUS_USE)
end

---@return nil
function ENT:InputDisableShadow()
end

---@return nil
function ENT:InputDisableTouchInteraction()
  self:SCRemoveInteractFlag(SF_TOUCH_INTERACTS)
end

---@return nil
function ENT:InputDisableUseInteraction()
  self:SCRemoveInteractFlag(SF_USE_INTERACTS)
end

---@return nil
function ENT:InputEnable()
  self:InputTurnOn()
end

---@return nil
function ENT:InputEnableDraw()
  self:InputTurnOn()
end

---@return nil
function ENT:InputEnableCollision()
  self:RemoveSolidFlags(FSOLID_NOT_SOLID)
end

---@return nil
function ENT:InputEnablePhyscannonPickup()
end

---@return nil
function ENT:InputEnableReceivingFlashlight()
end

---@return nil
function ENT:InputEnableRadiusInteract()
  self:SCAddInteractFlag(SF_RADIUS_USE)
end

---@return nil
function ENT:InputEnableShadow()
end

---@return nil
function ENT:InputEnableTouchInteraction()
  self:SCAddInteractFlag(SF_TOUCH_INTERACTS)
end

---@return nil
function ENT:InputEnableUseInteraction()
  self:SCAddInteractFlag(SF_USE_INTERACTS)
end

---@return nil
function ENT:InputFadeAndKill()
  self:Remove()
end

---@return nil
function ENT:InputFireUser1()
  self:TriggerOutput("OnUser1", self)
end

---@return nil
function ENT:InputFireUser2()
  self:TriggerOutput("OnUser2", self)
end

---@return nil
function ENT:InputFireUser3()
  self:TriggerOutput("OnUser3", self)
end

---@return nil
function ENT:InputFireUser4()
  self:TriggerOutput("OnUser4", self)
end

---@return nil
function ENT:InputLock()
  self.Locked = true
end

---@param activator Entity
---@param caller Entity
---@return nil
function ENT:InputPress(activator, caller)
  if CurTime() < self._cooldown_time then return end
  if not self:SCIsUseInBounds(activator) then return end
  self:SCUse(activator, self.Locked)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputRemoveHealth(activator, caller, data)
  self:SCSetHealthValue(self.HealthValue - (tonumber(data) or 0))
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetAnimation(activator, caller, data)
  self:SCSetAnimation(data, true, activator)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetAnimationNoReset(activator, caller, data)
  self:SCSetAnimation(data, false, activator)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetBodyGroup(activator, caller, data)
  self:SetBodygroup(0, tonumber(data) or 0)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetCycle(activator, caller, data)
  self:SetCycle(tonumber(data) or 0)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetDefaultAnimation(activator, caller, data)
  self.DefaultAnim = data
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetHealth(activator, caller, data)
  self:SCSetHealthValue(tonumber(data) or self.HealthValue)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetMass(activator, caller, data)
  local phys = self:GetPhysicsObject()
  if IsValid(phys) then
    phys:SetMass(tonumber(data) or phys:GetMass())
  end
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetLightingOrigin(activator, caller, data)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetLightingOriginHack(activator, caller, data)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetModel(activator, caller, data)
  if not util.IsValidModel(data) then return end
  self.ModelName = data
  util.PrecacheModel(data)
  self:SetModel(data)
  self:SCApplyCollision()
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetModelScale(activator, caller, data)
  local scale, delay = data:match("^%s*(%-?[%d%.]+)%s*(%-?[%d%.]*)")
  self.ModelScale = tonumber(scale) or self.ModelScale
  self:SetModelScale(self.ModelScale, tonumber(delay) or 0)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetPlaybackRate(activator, caller, data)
  self.PlaybackRate = tonumber(data) or self.PlaybackRate
  self:SetPlaybackRate(self.PlaybackRate)
end

---@return nil
function ENT:InputStartIgnoringCommandsWhenLocked()
  self:SCAddInteractFlag(SF_IGNORE_COMMANDS_WHEN_LOCKED)
end

---@return nil
function ENT:InputStopIgnoringCommandsWhenLocked()
  self:SCRemoveInteractFlag(SF_IGNORE_COMMANDS_WHEN_LOCKED)
end

---@return nil
function ENT:InputUnlock()
  self.Locked = false
end

---@return nil
function ENT:InputTurnOff()
  self:AddEffects(EF_NODRAW)
end

---@return nil
function ENT:InputTurnOn()
  self:RemoveEffects(EF_NODRAW)
end

---@param activator Entity
---@param caller Entity
---@return nil
function ENT:InputUse(activator, caller)
  self:Use(activator, caller, USE_ON, 0)
end

---@param dmginfo CTakeDamageInfo
---@return number
function ENT:OnTakeDamage(dmginfo)
  self:TriggerOutput("OnTakeDamage", self)
  if self.HealthValue > 0 then
    self:SCSetHealthValue(self.HealthValue - dmginfo:GetDamage())
  end
  return dmginfo:GetDamage()
end

---@return boolean
function ENT:Think()
  if self._sequence_state == SEQUENCE_NONE then return false end
  if self._sequence_state ~= SEQUENCE_WAIT_OUT then self:FrameAdvance() end
  local time = CurTime()
  if self._sequence_state ~= SEQUENCE_WAIT_OUT and time < self._sequence_end_time then
    self:NextThink(CurTime() + 0.1)
    return true
  elseif self._sequence_state == SEQUENCE_ANIMATION then
    self:TriggerOutput("OnAnimationDone", self)
  elseif self._sequence_state == SEQUENCE_IN then
    self:TriggerOutput("OnAnimationDone", self)
    self:TriggerOutput("OnIn", self)
    self._sequence_state = SEQUENCE_WAIT_OUT
  elseif self._sequence_state == SEQUENCE_LOCKED then
    self:TriggerOutput("OnAnimationDone", self)
    self:TriggerOutput("OnIn", self)
  end
  if self._sequence_state == SEQUENCE_WAIT_OUT then
    if time < self._cooldown_time then
      self:NextThink(self._cooldown_time)
      return true
    end
    self:SCStartSequence(self.OutSequence, SEQUENCE_OUT, self)
    if self._sequence_state == SEQUENCE_OUT then return true end
  elseif self._sequence_state == SEQUENCE_OUT then
    self:TriggerOutput("OnAnimationDone", self)
    self:TriggerOutput("OnOut", self)
  end
  self._sequence_state = SEQUENCE_NONE
  return false
end

---@param ent Entity
---@return nil
function ENT:Touch(ent)
  if not self.TouchInteraction then return end
  if self.Locked and self.IgnoreCommandsWhenLocked then return end
  if not IsValid(ent) or not ent:IsPlayer() then return end
  if CurTime() < self._cooldown_time then return end
  if not self:SCIsUseInBounds(ent) then return end
  self:SCUse(ent, self.Locked)
end

---@param activator Entity
---@param caller Entity
---@param useType integer
---@param value number
---@return nil
function ENT:Use(activator, caller, useType, value)
  if useType == USE_OFF then return end
  if not self.UseInteraction then return end
  if self.Locked and self.IgnoreCommandsWhenLocked then return end
  if CurTime() < self._cooldown_time then return end
  if not self:SCIsUseInBounds(activator) then return end
  self:SCUse(activator, self.Locked)
end
