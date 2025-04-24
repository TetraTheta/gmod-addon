AddCSLuaFile()
--
SWEP.AdminOnly = false
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = true
SWEP.AutoSwitchTo = true
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Weapon"
SWEP.DrawAmmo = true
SWEP.IconOverride = "materials/entities/scw_mp5sd.png"
SWEP.Instructions = "Kind of reskin of SMG1"
SWEP.PrintName = "MP5SD"
SWEP.Purpose = "Yet Another MP5SD"
SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_scw_mp5sd.mdl"
SWEP.Weight = 999
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scw_mp5sd") or ""
SWEP.WorldModel = "models/weapons/w_scw_mp5sd.mdl"
SWEP.CFG_HoldType = "ar2"
SWEP.CFG_ReloadSound = "SCW.MP5SD.Reload"
-- SWEP Primary Fire
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 100
SWEP.Primary.CFG_Damage = ConVarExists("sk_plr_dmg_smg1") and GetConVar("sk_plr_dmg_smg1"):GetInt() * 2 or 8
SWEP.Primary.CFG_Delay = 0.05
SWEP.Primary.CFG_Force = 10000
SWEP.Primary.CFG_Recoil = 0.1
SWEP.Primary.CFG_Sound = "SCW.MP5SD.Primary"
SWEP.Primary.CFG_Spread = 0.015
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = "SMG1_Grenade"
SWEP.Secondary.Automatic = true
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 10
SWEP.Secondary.CFG_Delay = 0.5
SWEP.Secondary.CFG_Force = 1000
SWEP.Secondary.CFG_Recoil = 0.1
SWEP.Secondary.CFG_Sound = "SCW.MP5SD.Secondary"
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)
--
--[[
########################
#     SWEP UTILITY     #
########################
]]
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
  self:SetHoldType(self.CFG_HoldType)
end

function SWEP:CanBePickedUpByNPCs()
  return true
end

-- function SWEP:FireAnimationEvent(_, _, evt, _)
--   -- Disable Brass Shell Ejection
--   if evt == 6001 then return true end
-- end
function SWEP:ShouldDropOnDie()
  -- Prevent weapon drop when user dies
  return false
end

function SWEP:Precache()
  util.PrecacheSound(self.Primary.CFG_Sound)
  util.PrecacheSound(self.Secondary.CFG_Sound)
end

--[[
########################
#     PRIMARY FIRE     #
########################
]]
function SWEP:PrimaryAttack()
  if game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end
  if not (IsFirstTimePredicted() and self:CanPrimaryAttack()) then return end
  local owner = self:GetOwner()
  ---@cast owner Player
  self:EmitSound(self.Primary.CFG_Sound)
  self:ShootBullet(self.Primary.CFG_Damage, 1, self.Primary.CFG_Spread, self.Primary.Ammo, self.Primary.CFG_Force, 1)
  self:TakePrimaryAmmo(1)
  self:_RemoveMissile()
  if owner:IsPlayer() then
    local r1 = self.Primary.CFG_Recoil * -1
    local r2 = self.Primary.CFG_Recoil * math.Rand(-1, 1)
    owner:ViewPunch(Angle(r1, r2, r1))
  end

  if self:Clip1() == 0 then timer.Simple(0.01, function() self:Reload() end) end
  self:SetNextPrimaryFire(CurTime() + self.Primary.CFG_Delay)
end

--[[
##########################
#     SECONDARY FIRE     #
##########################
]]
function SWEP:SecondaryAttack()
  if game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end
  if not (IsFirstTimePredicted() and self:CanSecondaryAttack()) then return end
  local owner = self:GetOwner()
  ---@cast owner Player
  if self:Ammo2() > 0 then
    self:EmitSound(self.Secondary.CFG_Sound)
    if SERVER then
      local g = ents.Create("grenade_ar2")
      if IsValid(g) then
        local fwd = owner:EyeAngles():Forward()
        g:SetPos(owner:GetShootPos() + fwd * 32)
        g:SetAngles(owner:EyeAngles())
        g:SetMoveType(MOVETYPE_FLYGRAVITY)
        g:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
        g:Spawn()
        g:Activate()
        g:SetVelocity(fwd * 1000)
        g:SetLocalAngularVelocity(Angle(math.random(-400, 400), math.random(-400, 400), math.random(-400, 400)))
        g:SetSaveValue("m_flDamage", 100)
        g:SetOwner(owner)
        g:SetPhysicsAttacker(owner)
      end
    end

    if owner:IsPlayer() then
      local r1 = self.Secondary.CFG_Recoil * -1
      local r2 = self.Secondary.CFG_Recoil * math.Rand(-1, 1)
      owner:ViewPunch(Angle(r1, r2, r1))
    end

    self:SetNextSecondaryFire(CurTime() + self.Secondary.CFG_Delay)
    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
    owner:RemoveAmmo(1, self.Secondary.Ammo)
  else
    self:EmitSound("Weapon_Pistol.Empty")
    self:SetNextSecondaryFire(CurTime() + self.Secondary.CFG_Delay)
  end
end

--[[
##################
#     RELOAD     #
##################
]]
function SWEP:Reload()
  -- Convert Pistol ammo to SMG1 ammo
  if self:Ammo1() == 0 then
    local owner = self:GetOwner()
    ---@cast owner Player
    local ammoPistol = owner:GetAmmoCount("Pistol")
    owner:SetAmmo(0, "Pistol")
    owner:SetAmmo(ammoPistol, "SMG1")
  end

  if self:Clip1() < self:GetMaxClip1() and self:Ammo1() > 0 then self:EmitSound("SCW.MP5SD.Reload") end
  self:DefaultReload(ACT_VM_RELOAD)
end
