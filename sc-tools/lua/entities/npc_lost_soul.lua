---@class ENT
---@field LastFlyThinkTime number
if SERVER then AddCSLuaFile() end
DEFINE_BASECLASS("sc_npc")
ENT.Base = "sc_npc"
ENT.Type = "ai"
ENT.PrintName = "Lost Soul"
--
ENT.AttackDistance = 48
ENT.AttackInterval = 0.35
ENT.DefaultHealth = 40
ENT.DefaultModel = "models/skeleton/skeleton_torso3.mdl"
ENT.FlyAcceleration = 300
ENT.FlyDecay = 0.3
ENT.FlySpeed = 500
ENT.FlyTurnAcceleration = 200
ENT.FlyVerticalAcceleration = 300
ENT.SearchDistance = 4096
ENT.ThinkInterval = 0.05

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
  self.LastFlyThinkTime = CurTime() - self.ThinkInterval
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
  local now = CurTime()
  local interval = math.max(now - self.LastFlyThinkTime, engine.TickInterval())
  self.LastFlyThinkTime = now
  if self:SCShouldIgnorePlayers() then
    self:SCClearEnemy()
    self:SetLocalVelocity(vector_origin)
    self:NextThink(now + 0.2)
    return true
  end
  local enemy = self:SCFindClosestPlayer(self.SearchDistance)
  if not IsValid(enemy) then
    self:SetLocalVelocity(vector_origin)
    self:NextThink(now + 0.2)
    return true
  end
  ---@cast enemy Player
  self:SCSetEnemy(enemy)
  local targetPos = enemy:EyePos()
  local pos = self:GetPos()
  local offset = targetPos - pos
  local distance = offset:Length()
  local direction = distance > 0 and offset:GetNormalized() or vector_origin

  -- Apply the C++ flying bot's frame-rate-independent steering instead of snapping to full speed.
  local velocity = self:GetAbsVelocity()
  local accel = direction:Dot(velocity:GetNormalized()) > 0.25 and self.FlyAcceleration or self.FlyTurnAcceleration
  local max_accel = distance / interval
  accel = math.min(accel, max_accel)
  local z_accel = math.min(self.FlyVerticalAcceleration, max_accel)
  local decay = self.FlyDecay ^ interval
  velocity.x = decay * velocity.x + accel * interval * direction.x
  velocity.y = decay * velocity.y + accel * interval * direction.y
  velocity.z = decay * velocity.z + z_accel * interval * direction.z
  local speed = velocity:Length()
  if speed > self.FlySpeed then velocity = velocity * (self.FlySpeed / speed) end
  if velocity.z < -200 then velocity.z = -200 end
  self:SetLocalVelocity(velocity)
  self:SetAngles(direction:Angle())

  if distance <= self.AttackDistance and now >= self.NextAttackTime then
    self.NextAttackTime = now + self.AttackInterval
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
  if distance < 96 and now >= self.NextFlySoundTime then
    self.NextFlySoundTime = now + math.Rand(0.5, 2)
    self:SCEmitSound("ambient/fire/mtov_flame2.wav")
  end
  self:NextThink(now + self.ThinkInterval)
  return true
end
