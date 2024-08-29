AddCSLuaFile()
--
SWEP.AdminOnly = true
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = false
SWEP.AutoSwitchTo = false
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Weapon"
SWEP.DrawAmmo = false
SWEP.IconOverride = "" -- [!!!!] Override this from child SWEPs!
SWEP.Instructions = "" -- [!!!!] Override this from child SWEPs!
SWEP.PrintName = "" -- [!!!!] Override this from child SWEPs!
SWEP.Purpose = "" -- [!!!!] Override this from child SWEPs!
SWEP.Slot = 0 -- [!!!!] Override this from child SWEPs!
SWEP.SlotPos = 0 -- [!!!!] Override this from child SWEPs!
SWEP.Spawnable = false -- [!!!!] Override this from child SWEPs!
SWEP.UseHands = true
SWEP.ViewModel = "" -- [!!!!] Override this from child SWEPs!
SWEP.Weight = 999
SWEP.WorldModel = "" -- [!!!!] Override this from child SWEPs!
SWEP.Config_HoldType = "" -- [!!!!] Override this from child SWEPs!
-- SWEP Primary Fire
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 10
SWEP.Primary.CFG_Damage = 8
SWEP.Primary.CFG_Delay = 0.05
SWEP.Primary.CFG_Force = 1000000
SWEP.Primary.CFG_Recoil = 0.1
SWEP.Primary.CFG_ShotCount = 75
SWEP.Primary.CFG_Sound = "" -- [!!!!] Override this from child SWEPs!
SWEP.Primary.CFG_Spread = 0.015
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = "SMG1_Grenade"
SWEP.Secondary.Automatic = true
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 10
SWEP.Secondary.CFG_Delay = 0.5
SWEP.Secondary.CFG_Force = 1000
SWEP.Secondary.CFG_Recoil = 0.1
SWEP.Secondary.CFG_ShotCount = 1
SWEP.Secondary.CFG_Sound = "NPC_Combine.GrenadeLaunch"
--
-- [!!!!] Precache ViewModel and WorldModel!
--util.PrecacheModel(SWEP.ViewModel)
--util.PrecacheModel(SWEP.WorldModel)
--[[
########################
#     SWEP UTILITY     #
########################
]]
function SWEP:_CreateRandomString()
  local r = {}
  for i = 0, 6 do
    r[i] = string.char(math.random(65, 90))
  end
  return table.concat(r)
end

---@param rm boolean Should remove missiles?
---@param recoil number
---@param delay number
function SWEP:_FireEffect(rm, recoil, delay)
  self:ShootEffects()
  if rm then self:_RemoveMissile() end
  local owner = self:GetOwner()
  if owner:IsPlayer() then
    ---@cast owner Player
    local r1 = recoil * -1
    local r2 = recoil * math.Rand(-1, 1)
    owner:ViewPunch(Angle(r1, r2, r1))
  end

  self:SetNextPrimaryFire(CurTime() + delay)
  self:SetNextSecondaryFire(CurTime() + delay)
end

function SWEP:_RemoveMissile()
  local owner = self:GetOwner()
  if not owner:IsPlayer() then return end
  ---@cast owner Player
  local ms = ents.FindInCone(owner:GetPos(), owner:GetAimVector(), 8000, math.cos(math.rad(2.2)))
  local d = DamageInfo()
  d:SetDamage(9999)
  d:SetDamageType(DMG_MISSILEDEFENSE)
  d:SetAttacker(owner)
  d:SetInflictor(self)
  for _, v in pairs(ms) do
    if IsValid(v) and v:GetClass():match("_missile") then v:TakeDamageInfo(d) end
  end
end

--
--[[
#########################
#     SWEP FUNCTION     #
#########################
]]
-- No DataTables. It just doesn't work. Fuck it. I'm so fed up with this.
-- If anyone suggests it, just reply to him, "I'm so fed up with NetworkVar that doesn't work."

function SWEP:Initialize()
  self:SetHoldType(self.Config_HoldType)
end

function SWEP:CanBePickedUpByNPCs()
  return true
end

function SWEP:FireAnimationEvent(_, _, evt, _)
  -- Disable Brass Shell Ejection
  if evt == 6001 then return true end
end

function SWEP:ShouldDropOnDie()
  -- Prevent weapon drop when user dies
  return false
end

function SWEP:Precache()
  util.PrecacheSound(self.Primary.CFG_Sound)
  util.PrecacheSound(self.Secondary.MOD_EXP_Sound)
  util.PrecacheSound(self.Secondary.MOD_ABG_Sound)
  util.PrecacheSound(self.Secondary.MOD_CMB_Sound1)
  util.PrecacheSound(self.Secondary.MOD_CMB_Sound2)
  util.PrecacheSound(self.Secondary.MOD_GRN_Sound)
end

--[[
########################
#     PRIMARY FIRE     #
########################
]]
function SWEP:PrimaryAttack()
  if (game.SinglePlayer()) then self:CallOnClient("PrimaryAttack") end
  if not IsFirstTimePredicted() then return end
  if not self:CanPrimaryAttack() then return end
  local owner = self:GetOwner() ---@cast owner NPC
  ---@type Bullet
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self.Primary.CFG_Damage,
    Dir = owner:GetAimVector(),
    Force = self.Primary.CFG_Force,
    Num = self.Primary.CFG_ShotCount,
    Spread = Vector(self.Primary.CFG_Spread, self.Primary.CFG_Spread, 0),
    Src = owner:GetShootPos(),
    Tracer = 1,
    TracerName = "Tracer"
  }

  owner:FireBullets(bullet)
  self:EmitSound(self.Primary.CFG_Sound)
  self:_FireEffect(true, self.Primary.CFG_Recoil, self.Primary.CFG_Delay)
end

--[[
##########################
#     SECONDARY FIRE     #
##########################
]]
function SWEP:SecondaryAttack()
  if (game.SinglePlayer()) then self:CallOnClient("SecondaryAttack") end
  if not IsFirstTimePredicted() then return end
  if not self:CanSecondaryAttack() then return end
  local owner = self:GetOwner() ---@cast owner NPC
  ---@type Bullet
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self.Primary.CFG_Damage,
    Dir = owner:GetAimVector(),
    Force = self.Primary.CFG_Force,
    Num = self.Primary.CFG_ShotCount,
    Spread = Vector(self.Primary.CFG_Spread, self.Primary.CFG_Spread, 0),
    Src = owner:GetShootPos(),
    Tracer = 1,
    TracerName = "Tracer"
  }

  owner:FireBullets(bullet)
  self:EmitSound(self.Primary.CFG_Sound)
  self:_FireEffect(true, self.Primary.CFG_Recoil, self.Primary.CFG_Delay)
  --
  if SERVER then
    local fwd = owner:EyeAngles():Forward()
    local g = ents.Create("grenade_ar2")
    g:SetPos(owner:GetShootPos() + fwd * 16)
    g:SetAngles(owner:GetAimVector():Angle())
    g:SetMoveType(MOVETYPE_FLYGRAVITY)
    g:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
    g:SetOwner(owner)
    g:Spawn()
    g:Activate()
    local p = g:GetPhysicsObject()
    if IsValid(p) then
      g:SetAbsVelocity(owner:GetAimVector():Angle():Forward() * 800)
      g:SetLocalAngularVelocity(Angle(math.random(-400, 400)))
    end
  end

  self:EmitSound(self.Secondary.MOD_GRN_Sound)
  self:_FireEffect(false, self.Secondary.CFG_Recoil, self.Secondary.MOD_GRN_Delay)
end

--[[
##################
#     RELOAD     #
##################
]]
function SWEP:Reload()
  local owner = self:GetOwner()
  ---@cast owner Player
  if not IsFirstTimePredicted() or not owner:KeyPressed(IN_RELOAD) or self:GetNextPrimaryFire() > CurTime() then return end
  local new = self.Secondary.MOD_Current + 1
  if new > self.Secondary.MOD_Max or new < 1 then new = 1 end
  self:SetSecondaryMode(new)
  if SERVER then
    net.Start(self.ClassName .. "_ChangeMode")
    net.WriteUInt(new, 3)
    net.Send(owner)
  end
end
