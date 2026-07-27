---@class ENT
if SERVER then AddCSLuaFile() end
DEFINE_BASECLASS("sc_npc")
ENT.Base = "sc_npc"
ENT.Type = "ai"
ENT.PrintName = "Lost Soul"
--
ENT.DefaultHealth = 40
ENT.DefaultModel = "models/skeleton/skeleton_torso3.mdl"
ENT.AttackDistance = 48
ENT.AttackInterval = 0.35
ENT.FlySpeed = 420
ENT.SearchDistance = 4096

if CLIENT then return end
--
local BURN_DAMAGE = bit.bor(DMG_BURN, DMG_SLOWBURN)

---@return number
local function GetLostSoulDamage()
  if ConVarExists("sk_lostsoul_melee_dmg") then
    return math.max(GetConVar("sk_lostsoul_melee_dmg"):GetFloat(), 1)
  end

  return 8
end

function ENT:Initialize()
  BaseClass.Initialize(self)
  self:SCApplyModel(self.DefaultModel)
  self:SetHullType(HULL_TINY_CENTERED)
  self:SetHullSizeNormal()
  self:SetSolid(SOLID_BBOX)
  self:SetMoveType(MOVETYPE_FLY)
  self:SetBloodColor(BLOOD_COLOR_RED)
  self:SetNPCClass(CLASS_HEADCRAB)
  self:SetCollisionGroup(COLLISION_GROUP_NONE)
  self:AddEffects(EF_NOSHADOW)
  self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY, CAP_INNATE_MELEE_ATTACK1))

  if ConVarExists("sk_lostsoul_health") and (self.SCHealth == nil or self.SCHealth < 1) then
    local health = GetConVar("sk_lostsoul_health"):GetInt()
    if health > 0 then self:SetHealth(health) end
  end

  self.NextAttackTime = 0
  self.NextFlySoundTime = 0
  self:Ignite(999999, 8)
end

---@param dmginfo CTakeDamageInfo
---@return number
function ENT:OnTakeDamage(dmginfo)
  if bit.band(dmginfo:GetDamageType(), BURN_DAMAGE) ~= 0 then return 0 end
  return BaseClass.OnTakeDamage(self, dmginfo)
end

function ENT:Think()
  local enemy = self:SCFindClosestPlayer(self.SearchDistance)
  if not IsValid(enemy) then
    self:SetLocalVelocity(vector_origin)
    self:NextThink(CurTime() + 0.2)
    return true
  end
  ---@cast enemy Player

  self:SCSetEnemy(enemy)

  local targetPos = enemy:EyePos()
  local pos = self:GetPos()
  local offset = targetPos - pos
  local distance = offset:Length()
  local direction = distance > 0 and offset:GetNormalized() or vector_origin

  self:SetLocalVelocity(direction * self.FlySpeed)
  self:SetAngles(direction:Angle())

  if distance <= self.AttackDistance and CurTime() >= self.NextAttackTime then
    self.NextAttackTime = CurTime() + self.AttackInterval

    local dmginfo = DamageInfo()
    dmginfo:SetAttacker(self)
    dmginfo:SetInflictor(self)
    dmginfo:SetDamage(GetLostSoulDamage())
    dmginfo:SetDamageType(DMG_SLASH)
    dmginfo:SetDamagePosition(enemy:WorldSpaceCenter())
    dmginfo:SetDamageForce(direction * 6000)
    enemy:TakeDamageInfo(dmginfo)
    enemy:Ignite(2, 8)
  end

  if distance < 96 and CurTime() >= self.NextFlySoundTime then
    self.NextFlySoundTime = CurTime() + math.Rand(0.5, 2)
    self:SCEmitSound("ambient/fire/mtov_flame2.wav")
  end

  self:NextThink(CurTime() + 0.05)
  return true
end
