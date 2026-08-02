---@class ENT
if SERVER then AddCSLuaFile() end
DEFINE_BASECLASS("sc_npc")
ENT.Base = "sc_npc"
ENT.Type = "ai"
ENT.PrintName = "Shadow Walker"
--
ENT.DefaultHealth = 75
ENT.DefaultModel = "models/monster/subject.mdl"
ENT.DefaultWeaponModel = "models/props_canal/mattpipe.mdl"
ENT.AttackDistance = 72
ENT.AttackInterval = 0.9
ENT.SearchDistance = 4096
ENT.ChaseInterval = 0.9
ENT.PipeBone = "ValveBiped.Bip01_R_Hand"
ENT.PipeAngles = Angle(0, 90, -90)
ENT.PipeOffset = Vector(3, -2, -1)

if CLIENT then return end
--
local SOUND_DEFAULTS = {
  DeathSound = "npc/zombie/zombie_die1.wav",
  FoundEnemySound = "npc/zombie/zombie_alert2.wav",
  PainSound = "npc/zombie/zombie_pain1.wav"
}

function ENT:Initialize()
  BaseClass.Initialize(self)
  self:SCApplyModel(self.DefaultModel)
  self:SetHullType(HULL_HUMAN)
  self:SetHullSizeNormal()
  self:SetSolid(SOLID_BBOX)
  self:SetMoveType(MOVETYPE_STEP)
  self:SetBloodColor(BLOOD_COLOR_RED)
  self:SetNPCClass(CLASS_ZOMBIE)
  self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND, CAP_OPEN_DOORS, CAP_TURN_HEAD, CAP_USE_WEAPONS, CAP_MOVE_SHOOT, CAP_AIM_GUN, CAP_DUCK, CAP_SQUAD))
  if self.CannotOpenDoors then
    self:CapabilitiesRemove(CAP_OPEN_DOORS)
  end
  self.LastEnemy = nil
  self.NextAttackTime = 0
  self.NextPathTime = 0
  self.NextFoundEnemySoundTime = 0
  self.SpeedModifier = self.SpeedModifier or 1
  self.WeaponModel = self.WeaponModel or self.DefaultWeaponModel
  self:GiveHiddenMeleeWeapon()
  self:CreateHeldPipe()
end

---@param key string
---@param value string
function ENT:KeyValue(key, value)
  BaseClass.KeyValue(self, key, value)
  local lkey = string.lower(key)
  if lkey == "weaponmodel" then
    self.WeaponModel = value
  elseif lkey == "deathsound" then
    self.SCDeathSound = value
  elseif lkey == "painsound" then
    self.SCPainSound = value
  elseif lkey == "foundenemysound" then
    self.SCFoundEnemySound = value
  elseif lkey == "cannotopendoors" then
    self.CannotOpenDoors = value == true or value == "1" or value == 1 or value == "true"
  end
end

function ENT:GiveHiddenMeleeWeapon()
  self:Give("weapon_crowbar")
  local weapon = self:GetActiveWeapon()
  if IsValid(weapon) then
    weapon:SetNoDraw(true)
    weapon:SetNotSolid(true)
  end
end

function ENT:CreateHeldPipe()
  local modelName = self.WeaponModel or self.DefaultWeaponModel
  if not util.IsValidModel(modelName) then modelName = self.DefaultWeaponModel end
  util.PrecacheModel(modelName)
  local pipe = ents.Create("prop_dynamic")
  if not IsValid(pipe) then return end
  pipe:SetModel(modelName)
  pipe:SetSolid(SOLID_NONE)
  pipe:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
  pipe:Spawn()
  local bone = self:LookupBone(self.PipeBone)
  if bone ~= nil then
    pipe:FollowBone(self, bone)
    pipe:SetLocalPos(self.PipeOffset)
    pipe:SetLocalAngles(self.PipeAngles)
  else
    pipe:SetParent(self)
    pipe:SetLocalPos(Vector(18, -10, 44))
    pipe:SetLocalAngles(self.PipeAngles)
  end
  self.HeldPipe = pipe
end

function ENT:DropHeldPipe()
  if IsValid(self.HeldPipe) then
    self.HeldPipe:Remove()
  end
  local modelName = self.WeaponModel or self.DefaultWeaponModel
  if not util.IsValidModel(modelName) then return end
  local pipe = ents.Create("prop_physics")
  if not IsValid(pipe) then return end
  pipe:SetModel(modelName)
  pipe:SetPos(self:GetPos() + Vector(0, 0, 42))
  pipe:SetAngles(self:GetAngles())
  pipe:Spawn()
  pipe:SetCollisionGroup(COLLISION_GROUP_WEAPON)
  local phys = pipe:GetPhysicsObject()
  if IsValid(phys) then
    phys:Wake()
    phys:ApplyForceCenter(self:GetForward() * 2500 + Vector(0, 0, 1000))
  end
end

function ENT:InputDisableOpenDoors(_, _, _)
  self.CannotOpenDoors = true
  self:CapabilitiesRemove(CAP_OPEN_DOORS)
end

function ENT:InputEnableOpenDoors(_, _, _)
  self.CannotOpenDoors = false
  self:CapabilitiesAdd(CAP_OPEN_DOORS)
end

function ENT:InputSetSpeedModifier(_, _, data)
  self.SpeedModifier = tonumber(data) or 1
end

---@param dmginfo CTakeDamageInfo|nil
function ENT:OnKilled(dmginfo)
  if self.SCDead then return end
  self.SCDead = true
  local weapon = self:GetActiveWeapon()
  if IsValid(weapon) then
    weapon:Remove()
  end
  self:SCNotifyKilled(dmginfo)
  self:SCEmitSound(self.SCDeathSound or SOUND_DEFAULTS.DeathSound)
  self:DropHeldPipe()
  if dmginfo ~= nil and self:BecomeRagdoll(dmginfo) then return end
  self:Remove()
end

function ENT:OnRemove()
  if IsValid(self.HeldPipe) then
    self.HeldPipe:Remove()
  end
  local weapon = self:GetActiveWeapon()
  if IsValid(weapon) then
    weapon:Remove()
  end
end

---@param dmginfo CTakeDamageInfo
---@return number
function ENT:OnTakeDamage(dmginfo)
  self:SCEmitSound(self.SCPainSound or SOUND_DEFAULTS.PainSound)
  return BaseClass.OnTakeDamage(self, dmginfo)
end

function ENT:GetRelationship(entity)
  if not IsValid(entity) or not entity:IsPlayer() then return end
  if self:SCShouldIgnorePlayers() then return D_NU end
  return D_HT
end

function ENT:Think()
  if self:SCShouldIgnorePlayers() then
    self:SCClearEnemy()
    self:NextThink(CurTime() + 0.25)
    return true
  end
  local enemy = self:SCFindClosestPlayer(self.SearchDistance)
  if not IsValid(enemy) then
    self:NextThink(CurTime() + 0.25)
    return true
  end
  ---@cast enemy Player
  self:SCSetEnemy(enemy)
  if self.LastEnemy ~= enemy then
    self.LastEnemy = enemy
    self:SCEmitSound(self.SCFoundEnemySound or SOUND_DEFAULTS.FoundEnemySound)
  end
  local pos = self:GetPos()
  local enemyPos = enemy:GetPos()
  local distance = pos:Distance(enemyPos)
  if CurTime() >= self.NextFoundEnemySoundTime then
    self.NextFoundEnemySoundTime = CurTime() + math.Rand(2, 5)
    self:SCEmitSound(self.SCFoundEnemySound or SOUND_DEFAULTS.FoundEnemySound)
  end
  if distance <= self.AttackDistance then
    if CurTime() < self.NextAttackTime then
      self:NextThink(CurTime() + 0.1)
      return true
    end
    self.NextAttackTime = CurTime() + self.AttackInterval
    self:SetSchedule(SCHED_MELEE_ATTACK1)
  elseif CurTime() >= self.NextPathTime then
    self.NextPathTime = CurTime() + math.max(0.2, self.ChaseInterval / (self.SpeedModifier or 1))
    self:SetSchedule(SCHED_CHASE_ENEMY)
  end
  self:NextThink(CurTime() + 0.1)
  return true
end

function ENT:TranslateActivity(activity)
  if activity == ACT_RUN_AIM_SHOTGUN then
    return ACT_RUN_AIM_RIFLE
  elseif activity == ACT_WALK_AIM_SHOTGUN then
    return ACT_WALK_AIM_RIFLE
  elseif activity == ACT_IDLE_ANGRY_SHOTGUN then
    return ACT_IDLE_ANGRY_SMG1
  elseif activity == ACT_IDLE_MELEE or activity == ACT_IDLE_ANGRY_MELEE then
    return ACT_IDLE_SUITCASE
  end
end
