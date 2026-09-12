if SERVER then AddCSLuaFile() end
local DEBUG_CVAR = SERVER and CreateConVar("sc_custommelee_debug", "0", FCVAR_ARCHIVE, "Custom Melee 공격 디버그 로그")
--
SWEP.AdminOnly = true
SWEP.AutoSwitchFrom = false
SWEP.AutoSwitchTo = false
SWEP.Category = "SC Tools"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Custom Melee"
SWEP.Spawnable = false
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_canal/mattpipe.mdl"
local dmg_cvar = GetConVar("sk_npc_dmg_crowbar")
SWEP.CFG_Damage = dmg_cvar ~= nil and dmg_cvar:GetInt() or 10
SWEP.CFG_Force = 1000
SWEP.CFG_HitDelay = 0.25
SWEP.CFG_HoldType = "melee"
SWEP.CFG_HullMaxs = Vector(36, 36, 36)
SWEP.CFG_HullMins = Vector(-16, -16, -16)
SWEP.CFG_Range = 64
SWEP.CFG_Refire = 0.4
SWEP.CFG_SoundHit = "Weapon_Crowbar.Melee_Hit"
SWEP.CFG_SoundMiss = "Weapon_Crowbar.Single"
-- SWEP Primary Fire
SWEP.Primary.Ammo = ""
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)

--[[
######################
#    SWEP UTILITY    #
######################
]]

---@param owner NPC|Player
---@param target Entity|nil
---@return Vector
function SWEP:_GetMeleeDirection(owner, target)
  if IsValid(target) then
    ---@cast target Entity
    return (target:WorldSpaceCenter() - owner:GetShootPos()):GetNormalized()
  end
  return owner:GetAimVector()
end

---@param owner NPC
---@return number
function SWEP:_PlayNPCMeleeAnimation(owner)
  owner:SetActivity(ACT_MELEE_ATTACK1)
  owner:SetIdealActivity(ACT_DO_NOT_DISTURB)
  local sequence = owner:GetSequence()
  if sequence >= 0 then
    owner:ResetSequence(sequence)
    owner:SetCycle(0)
    owner:SetPlaybackRate(1)
  end
  return sequence
end

---@param owner NPC|Player
---@param target Entity|nil
---@return TraceResult
function SWEP:_TraceMelee(owner, target)
  local start_pos = owner:WorldSpaceCenter()
  local dir = self:_GetMeleeDirection(owner, target)
  ---@type HullTrace
  local trace_data = {
    start = start_pos,
    endpos = start_pos + dir * self.CFG_Range,
    filter = owner,
    mins = self.CFG_HullMins,
    maxs = self.CFG_HullMaxs,
    mask = MASK_SHOT_HULL,
    collisiongroup = COLLISION_GROUP_PROJECTILE
  }
  return util.TraceHull(trace_data)
end

---@param message string
---@return nil
function SWEP:SCMeleeDebug(message)
  if not SERVER or not DEBUG_CVAR:GetBool() then return end
  MsgN(("[weapon_custommelee #%d] %s"):format(self:EntIndex(), message))
end

---@param owner NPC|Player
---@param target Entity|nil
---@return boolean
function SWEP:SCMeleeAttack(owner, target)
  if not IsValid(owner) then
    self:SCMeleeDebug("SCMeleeAttack 중단: owner 무효")
    return false
  end
  local tr = self:_TraceMelee(owner, target)
  local hit = tr.Entity
  local hit_index = IsValid(hit) and hit:EntIndex() or -1
  local target_index = IsValid(target) and target:EntIndex() or -1
  self:SCMeleeDebug(("공격 trace: hit=%s entity=%d target=%d fraction=%.3f startsolid=%s allsolid=%s hitworld=%s hitnonworld=%s"):format(tostring(tr.Hit), hit_index, target_index, tr.Fraction or -1, tostring(tr.StartSolid), tostring(tr.AllSolid), tostring(tr.HitWorld), tostring(tr.HitNonWorld)))
  if not (tr.Hit and IsValid(hit)) then
    self:EmitSound(self.CFG_SoundMiss)
    self:SCMeleeDebug("공격 결과: 빗나감")
    return false
  end
  ---@cast hit Entity
  local dmg = DamageInfo()
  dmg:SetAttacker(owner)
  dmg:SetDamage(self.CFG_Damage)
  dmg:SetDamageForce(self:_GetMeleeDirection(owner, hit) * self.CFG_Force)
  dmg:SetDamagePosition(tr.HitPos)
  dmg:SetDamageType(DMG_CLUB)
  dmg:SetInflictor(self)
  hit:TakeDamageInfo(dmg)
  self:EmitSound(self.CFG_SoundHit)
  self:SCMeleeDebug(("공격 결과: 피해 적용 entity=%d damage=%d"):format(hit:EntIndex(), self.CFG_Damage))
  return true
end

---@param owner NPC|Player
---@param target Entity
---@return boolean
function SWEP:SCMeleeCanHit(owner, target)
  if not IsValid(owner) or not IsValid(target) then return false end
  local tr = self:_TraceMelee(owner, target)
  local can_hit = tr.Hit and tr.Entity == target
  local now = CurTime()
  if self._DebugLastCanHit ~= can_hit or now >= (self._DebugNextCanHitTime or 0) then
    self._DebugLastCanHit = can_hit
    self._DebugNextCanHitTime = now + 0.75
    local entity_index = IsValid(tr.Entity) and tr.Entity:EntIndex() or -1
    self:SCMeleeDebug(("판정 trace: hit=%s entity=%d target=%d fraction=%.3f startsolid=%s allsolid=%s hitworld=%s hitnonworld=%s result=%s"):format(tostring(tr.Hit), entity_index, target:EntIndex(), tr.Fraction or -1, tostring(tr.StartSolid), tostring(tr.AllSolid), tostring(tr.HitWorld), tostring(tr.HitNonWorld), tostring(can_hit)))
  end
  return can_hit
end

---@param owner NPC|Player
---@param target Entity|nil
---@return nil
function SWEP:SCMeleeSwing(owner, target)
  if not IsValid(owner) then
    self:SCMeleeDebug("SCMeleeSwing 중단: owner 무효")
    return
  end
  self:SCMeleeDebug(("공격 시작: owner=%d target=%d activity_before=%d sequence=%d"):format(owner:EntIndex(), IsValid(target) and target:EntIndex() or -1, owner:GetActivity(), owner:GetSequence()))
  if owner:IsNPC() then
    ---@cast owner NPC
    local sequence = self:_PlayNPCMeleeAnimation(owner)
    self:SCMeleeDebug(("공격 모션 설정 후: activity=%d ideal=%d sequence=%d name=%s cycle=%.3f playback=%.3f"):format(owner:GetActivity(), owner:GetIdealActivity(), sequence, owner:GetSequenceName(sequence), owner:GetCycle(), owner:GetPlaybackRate()))
  end
  if CLIENT then return end
  self:SCMeleeDebug(("피해 타이머 예약: delay=%.2f"):format(self.CFG_HitDelay))
  timer.Simple(self.CFG_HitDelay, function()
    if not IsValid(self) or not IsValid(owner) then
      if IsValid(self) then self:SCMeleeDebug("피해 타이머 취소: self 또는 owner 무효") end
      return
    end
    self:SCMeleeDebug("피해 타이머 실행")
    self:SCMeleeAttack(owner, target)
  end)
end

---@param model_name string
---@return nil
function SWEP:SetWeaponModel(model_name)
  if not isstring(model_name) or model_name == "" or not util.IsValidModel(model_name) then return end
  util.PrecacheModel(model_name)
  self.WorldModel = model_name
  self:SetModel(model_name)
end

--[[
#######################
#    SWEP FUNCTION    #
#######################
]]

---@return boolean
function SWEP:CanBePickedUpByNPCs()
  return false
end

---@return boolean
function SWEP:Deploy()
  self:SendWeaponAnim(ACT_VM_DRAW)
  return true
end

---@return number
function SWEP:GetCapabilities()
  return 0
end

---@return nil
function SWEP:Initialize()
  self:SetHoldType(self.CFG_HoldType)
end

---@return nil
function SWEP:Precache()
  util.PrecacheModel(self.ViewModel)
  util.PrecacheModel(self.WorldModel)
  util.PrecacheSound(self.CFG_SoundHit)
  util.PrecacheSound(self.CFG_SoundMiss)
end

---@return boolean
function SWEP:ShouldDropOnDie()
  return false
end

---@param activity number
---@return number|nil
function SWEP:TranslateActivity(activity)
  if activity == ACT_MELEE_ATTACK1 then
    self:SCMeleeDebug("TranslateActivity: ACT_MELEE_ATTACK1 유지")
    return ACT_MELEE_ATTACK1
  end
end

--[[
###########################
#    SWEP PRIMARY FIRE    #
###########################
]]

---@return nil
function SWEP:PrimaryAttack()
  local owner = self:GetOwner()
  if not IsValid(owner) then return end
  if not (owner:IsNPC() or owner:IsPlayer()) then return end
  ---@cast owner NPC|Player
  if owner:IsPlayer() then
    ---@cast owner Player
    owner:SetAnimation(PLAYER_ATTACK1)
    self:SendWeaponAnim(ACT_VM_HITCENTER)
  end
  self:SCMeleeSwing(owner, nil)
  self:SetNextPrimaryFire(CurTime() + self.CFG_Refire)
end

--[[
#############################
#    SWEP SECONDARY FIRE    #
#############################
]]

---@return nil
function SWEP:SecondaryAttack()
end

--[[
#####################
#    SWEP RELOAD    #
#####################
]]

---@return nil
function SWEP:Reload()
end

---@class weapon_custommelee : Weapon
---@field CFG_Damage number
---@field CFG_Force number
---@field CFG_HitDelay number
---@field CFG_HoldType string
---@field CFG_HullMaxs Vector
---@field CFG_HullMins Vector
---@field CFG_Range number
---@field CFG_Refire number
---@field CFG_SoundHit string
---@field CFG_SoundMiss string
---@field SCMeleeCanHit fun(self: weapon_custommelee, owner: NPC|Player, target: Entity): boolean
---@field SCMeleeAttack fun(self: weapon_custommelee, owner: NPC|Player, target: Entity|nil): boolean
---@field SCMeleeSwing fun(self: weapon_custommelee, owner: NPC|Player, target: Entity|nil)
---@field SetWeaponModel fun(self: weapon_custommelee, model_name: string)
---@field WorldModel string
