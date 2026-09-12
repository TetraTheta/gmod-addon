---@class ENT : NPC
---@field AdditionalEquipment string|nil
---@field DefaultWeaponModel string
---@field WeaponModel string|nil
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

if CLIENT then return end
--
local SOUND_DEFAULTS = {
  DeathSound = "npc/zombie/zombie_die1.wav",
  FoundEnemySound = "npc/zombie/zombie_alert2.wav",
  PainSound = "npc/zombie/zombie_pain1.wav"
}
local CUSTOM_MELEE_CLASS = "weapon_custommelee"
local MELEE_EQUIPMENT_CLASSES = {
  weapon_crowbar = true,
  weapon_custommelee = true,
  weapon_stunstick = true
}
local DEBUG_CVAR = CreateConVar("sc_shadow_walker_debug", "0", FCVAR_ARCHIVE, "Shadow Walker 공격 디버그 로그")

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
  self.NextMeleeUnlockTime = 0
  self.NextPathTime = 0
  self.NextFoundEnemySoundTime = 0
  self._DebugNextThinkTime = 0
  self._DebugNextCanHitTime = 0
  self._DebugLastCanHit = nil
  self.SpeedModifier = self.SpeedModifier or 1
  self.WeaponModel = self.WeaponModel or self.DefaultWeaponModel
  self:SCMeleeDebug("Initialize 완료")
  timer.Simple(0, function()
    if IsValid(self) then
      self:FixupWeapon()
    end
  end)
end

---@param key string
---@param value string
---@return boolean|nil
function ENT:SCApplyKeyValue(key, value)
  local lkey = string.lower(key)
  if lkey == "weaponmodel" then
    self.WeaponModel = value
  elseif lkey == "additionalequipment" then
    self.AdditionalEquipment = value:lower()
  elseif lkey == "deathsound" then
    self.SCDeathSound = value
  elseif lkey == "painsound" then
    self.SCPainSound = value
  elseif lkey == "foundenemysound" then
    self.SCFoundEnemySound = value
  elseif lkey == "cannotopendoors" then
    self.CannotOpenDoors = value == true or value == "1" or value == 1 or value == "true"
  else
    self[key] = value
  end
end

---@return nil
function ENT:FixupWeapon()
  local weapon = self:GetActiveWeapon()
  local weapon_class = IsValid(weapon) and weapon:GetClass() or CUSTOM_MELEE_CLASS
  self:SCMeleeDebug(("FixupWeapon 시작: active=%s"):format(weapon_class))
  if IsValid(weapon) and not self:SCIsMeleeEquipment(weapon_class) then
    self:SCRemoveInactiveCustomMelee(weapon)
    self:SCMeleeDebug("기존 비근접 무기 유지")
    return
  end
  self:SCRemoveMeleeWeapons()
  weapon = self:Give(CUSTOM_MELEE_CLASS) or self:GetActiveWeapon()
  if not IsValid(weapon) then
    self:SCMeleeDebug("Custom Melee 지급 실패")
    return
  end
  ---@cast weapon weapon_custommelee
  self:SelectWeapon(weapon)
  local active_weapon = self:GetActiveWeapon()
  local active_class = IsValid(active_weapon) and active_weapon:GetClass() or "<invalid>"
  self:SCMeleeDebug(("무기 선택 완료: given=%s active=%s"):format(weapon:GetClass(), active_class))
  if isfunction(weapon.SetWeaponModel) then
    weapon:SetWeaponModel(self.WeaponModel or self.DefaultWeaponModel)
  end
end

---@return nil
function ENT:DropWeaponModel()
  local model_name = self.WeaponModel or self.DefaultWeaponModel
  if not util.IsValidModel(model_name) then return end
  local pipe = ents.Create("prop_physics")
  if not IsValid(pipe) then return end
  pipe:SetModel(model_name)
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
  self:DropWeaponModel()
  if dmginfo ~= nil and self:BecomeRagdoll(dmginfo) then return end
  self:Remove()
end

function ENT:OnRemove()
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
  self:FrameAdvance()
  if self:SCShouldIgnorePlayers() then
    self:SCClearEnemy()
    self:NextThink(CurTime() + 0.25)
    return true
  end
  local enemy = self:SCFindClosestPlayer(self.SearchDistance)
  if not IsValid(enemy) then
    if CurTime() >= self._DebugNextThinkTime then
      self._DebugNextThinkTime = CurTime() + 1
      self:SCMeleeDebug("Think: 유효한 플레이어 없음")
    end
    self:NextThink(CurTime() + 0.25)
    return true
  end
  ---@cast enemy Player
  if self.LastEnemy ~= enemy then
    self.LastEnemy = enemy
    self:SCSetEnemy(enemy)
    self:SCEmitSound(self.SCFoundEnemySound or SOUND_DEFAULTS.FoundEnemySound)
  end
  if self:SCUpdateMeleeLock() then
    self:NextThink(CurTime() + 0.05)
    return true
  end
  local pos = self:GetPos()
  local enemyPos = enemy:GetPos()
  local distance = pos:Distance(enemyPos)
  local in_range = distance <= self.AttackDistance
  local can_hit = in_range and self:SCMeleeCanHit(enemy)
  if CurTime() >= self._DebugNextThinkTime then
    self._DebugNextThinkTime = CurTime() + 1
    local weapon = self:GetActiveWeapon()
    local weapon_class = IsValid(weapon) and weapon:GetClass() or "<invalid>"
    self:SCMeleeDebug(("Think: enemy=%d distance=%.1f in_range=%s can_hit=%s active=%s activity=%d sequence=%d"):format(enemy:EntIndex(), distance, tostring(in_range), tostring(can_hit), weapon_class, self:GetActivity(), self:GetSequence()))
  end
  if CurTime() >= self.NextFoundEnemySoundTime then
    self.NextFoundEnemySoundTime = CurTime() + math.Rand(2, 5)
    self:SCEmitSound(self.SCFoundEnemySound or SOUND_DEFAULTS.FoundEnemySound)
  end
  if can_hit then
    if CurTime() < self.NextAttackTime then
      self:NextThink(CurTime() + 0.1)
      return true
    end
    self.NextAttackTime = CurTime() + self.AttackInterval
    self:SCStartMeleeLock()
    self:SCMeleeSwing(enemy)
  elseif CurTime() >= self.NextPathTime then
    self.NextPathTime = CurTime() + math.max(0.2, self.ChaseInterval / (self.SpeedModifier or 1))
    self:SetSchedule(SCHED_CHASE_ENEMY)
  end
  self:NextThink(CurTime() + 0.1)
  return true
end

---@return nil
function ENT:SCStartMeleeLock()
  self.NextMeleeUnlockTime = CurTime() + self.AttackInterval
  self:ClearSchedule()
  self:SetIdealActivity(ACT_DO_NOT_DISTURB)
  self:SCMeleeDebug(("근접 공격 잠금 시작: unlock=%.2f"):format(self.NextMeleeUnlockTime))
end

---@return boolean
function ENT:SCUpdateMeleeLock()
  if CurTime() < (self.NextMeleeUnlockTime or 0) then return true end
  if self.NextMeleeUnlockTime ~= 0 then
    self.NextMeleeUnlockTime = 0
    self:ResetIdealActivity(ACT_IDLE)
    self:SCMeleeDebug("근접 공격 잠금 해제")
  end
  return false
end

---@param enemy Entity
---@return boolean
function ENT:SCMeleeCanHit(enemy)
  local weapon = self:GetActiveWeapon()
  if not IsValid(weapon) then
    self:SCMeleeDebug("SCMeleeCanHit 실패: active weapon 무효")
    return false
  end
  ---@cast weapon weapon_custommelee
  if not isfunction(weapon.SCMeleeCanHit) then
    self:SCMeleeDebug(("SCMeleeCanHit 실패: %s에 SCMeleeCanHit 없음"):format(weapon:GetClass()))
    return false
  end
  local can_hit = weapon:SCMeleeCanHit(self, enemy)
  local now = CurTime()
  if self._DebugLastCanHit ~= can_hit or now >= self._DebugNextCanHitTime then
    self._DebugLastCanHit = can_hit
    self._DebugNextCanHitTime = now + 0.75
    self:SCMeleeDebug(("SCMeleeCanHit 결과: weapon=%s target=%d result=%s"):format(weapon:GetClass(), enemy:EntIndex(), tostring(can_hit)))
  end
  return can_hit
end

---@param enemy Entity
---@return nil
function ENT:SCMeleeSwing(enemy)
  local weapon = self:GetActiveWeapon()
  if not IsValid(weapon) then
    self:SCMeleeDebug("SCMeleeSwing 중단: active weapon 무효")
    return
  end
  ---@cast weapon weapon_custommelee
  if not isfunction(weapon.SCMeleeSwing) then
    self:SCMeleeDebug(("SCMeleeSwing 실패: %s에 SCMeleeSwing 없음"):format(weapon:GetClass()))
    return
  end
  self:SCMeleeDebug(("SCMeleeSwing 호출: weapon=%s target=%d"):format(weapon:GetClass(), enemy:EntIndex()))
  weapon:SCMeleeSwing(self, enemy)
end

---@param message string
---@return nil
function ENT:SCMeleeDebug(message)
  if not DEBUG_CVAR:GetBool() then return end
  MsgN(("[npc_shadow_walker #%d] %s"):format(self:EntIndex(), message))
end

---@param weapon_class string|nil
---@return boolean
function ENT:SCIsMeleeEquipment(weapon_class)
  if weapon_class == nil or weapon_class == "" then return false end
  return MELEE_EQUIPMENT_CLASSES[weapon_class] == true
end

---@param active_weapon Weapon
---@return nil
function ENT:SCRemoveInactiveCustomMelee(active_weapon)
  for _, weapon in ipairs(self:GetWeapons()) do
    if weapon ~= active_weapon and IsValid(weapon) and weapon:GetClass() == CUSTOM_MELEE_CLASS then
      weapon:Remove()
    end
  end
end

---@return nil
function ENT:SCRemoveMeleeWeapons()
  for _, weapon in ipairs(self:GetWeapons()) do
    if IsValid(weapon) and self:SCIsMeleeEquipment(weapon:GetClass()) then
      weapon:Remove()
    end
  end
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
