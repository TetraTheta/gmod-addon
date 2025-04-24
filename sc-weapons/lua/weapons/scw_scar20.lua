AddCSLuaFile()
--
SWEP.AdminOnly = false
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = true
SWEP.AutoSwitchTo = true
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Weapon"
SWEP.DrawAmmo = true
SWEP.IconOverride = "materials/entities/scw_scar20.png"
SWEP.Instructions = "SCAR20"
SWEP.PrintName = "SCAR20"
SWEP.Purpose = "Yet Another SCAR20"
SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_scw_scar20.mdl"
SWEP.Weight = 999
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scw_scar20") or ""
SWEP.WorldModel = "models/weapons/w_scw_scar20.mdl"
SWEP.CFG_HoldType = "ar2"
SWEP.CFG_ReloadSound = "SCW.SCAR20.Reload"
-- SWEP Primary Fire
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 100
SWEP.Primary.CFG_Damage = ConVarExists("sk_plr_dmg_scar20") and GetConVar("sk_plr_dmg_scar20"):GetInt() or 100
SWEP.Primary.CFG_Delay = 0.25
SWEP.Primary.CFG_Force = 10000
SWEP.Primary.CFG_Recoil = 0.1
SWEP.Primary.CFG_Sound = "SCW.SCAR20.Primary"
SWEP.Primary.CFG_Spread = 0.0
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.CFG_Delay = 0.1
SWEP.Secondary.CFG_Sound = "SCW.SCAR20.Zoom"
SWEP.Secondary.CFG_Zoom = 0
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
  self:SetNWFloat("MouseSensitivity", 1.0)
end

function SWEP:Deploy()
  local owner = self:GetOwner()
  ---@cast owner Player
  self:SendWeaponAnim(ACT_VM_DRAW)
  self:SetNextPrimaryFire(CurTime() + owner:GetViewModel():SequenceDuration())
  self:SetNextSecondaryFire(CurTime() + owner:GetViewModel():SequenceDuration())
  self:SetNWFloat("MouseSensitivity", 1.0)
end

function SWEP:Holster()
  self:SetNWFloat("MouseSensitivity", 1.0)
  return true
end

function SWEP:DrawHUD()
  if not CLIENT or self.Secondary.CFG_Zoom == 0 then return end
  local scrw, scrh = ScrW(), ScrH()
  local diameter = scrh * 0.85
  local radius = diameter / 2
  local centerX, centerY = scrw / 2, scrh / 2
  surface.SetDrawColor(0, 0, 0)
  -- surface.DrawRect(0, 0, centerX - radius, scrh)
  -- surface.DrawRect(centerX + radius, 0, scrw - (centerX + radius), scrh)
  -- surface.DrawRect(centerX - radius, 0, diameter, centerY - radius)
  -- surface.DrawRect(centerX - radius, centerY + radius, diameter, scrh - (centerY + radius))
  local lineWidth = 2
  surface.DrawLine(0, centerY - lineWidth / 2, scrw, centerY + lineWidth / 2)
  surface.DrawLine(centerX - lineWidth / 2, 0, centerY + lineWidth / 2, scrh)
end

function SWEP:AdjustMouseSensitivity()
  return self:GetNWFloat("MouseSensitivity", 1.0)
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
  if not IsFirstTimePredicted() then return end
  local owner = self:GetOwner()
  ---@cast owner Player
  local zoom = self.Secondary.CFG_Zoom
  self:EmitSound(self.Secondary.CFG_Sound)
  if zoom == 0 then
    self.Secondary.CFG_Zoom = 1
    self:SetNWFloat("MouseSensitivity", 0.44)
    owner:SetFOV(owner:GetFOV() / 2.25, 0.1)
  elseif zoom == 1 then
    self.Secondary.CFG_Zoom = 2
    self:SetNWFloat("MouseSensitivity", 0.17)
    owner:SetFOV(owner:GetFOV() / 2.67, 0.1)
  elseif zoom == 2 then
    self.Secondary.CFG_Zoom = 0
    self:SetNWFloat("MouseSensitivity", 1)
    owner:SetFOV(0, 0.1)
  end
end

--[[
##################
#     RELOAD     #
##################
]]
function SWEP:Reload()
  local owner = self:GetOwner()
  ---@cast owner Player
  -- Convert AR2 ammo to XBowBolt ammo
  if self:Ammo1() == 0 then
    local ammoAR2 = owner:GetAmmoCount("AR2")
    owner:SetAmmo(0, "AR2")
    owner:SetAmmo(ammoAR2, "XBowBolt")
  end

  if self:Clip1() < self:GetMaxClip1() and self:Ammo1() > 0 then
    self:EmitSound("SCW.SCAR20.Reload")
    -- Reset zoom
    self.Secondary.CFG_Zoom = 0
    self:SetNWFloat("MouseSensitivity", 1)
    owner:SetFOV(0, 0.1)
  end

  self:DefaultReload(ACT_VM_RELOAD)
end
