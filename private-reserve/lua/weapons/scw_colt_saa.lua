AddCSLuaFile()
--
SWEP.AdminOnly = false
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = true
SWEP.AutoSwitchTo = true
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Weapon"
SWEP.DrawAmmo = true
SWEP.IconOverride = "materials/entities/scw_colt_saa.png"
SWEP.Instructions = "Colt Single Action Army"
SWEP.PrintName = "Colt SAA"
SWEP.Purpose = "Colt SAA"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_scw_colt_saa.mdl"
SWEP.ViewModelFOV = 54
SWEP.Weight = 999
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scw_colt_saa") or ""
SWEP.WorldModel = "models/weapons/w_scw_colt_saa.mdl"
SWEP.CFG_HoldType = "revolver"
SWEP.CFG_ReloadSound = "SCW.MP5SD.Reload"
-- SWEP Primary Fire
SWEP.Primary.Ammo = "357"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 24
SWEP.Primary.CFG_Damage = 200
SWEP.Primary.CFG_Delay = 0.4
SWEP.Primary.CFG_Force = 10
SWEP.Primary.CFG_Recoil = 0.1
SWEP.Primary.CFG_ShotCount = 1
SWEP.Primary.CFG_Sound = "Weapon_357.Single"
SWEP.Primary.CFG_Spread = Vector(0.002, 0.002, 0)
-- SWEP Secondary Fire (None)
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)
--[[
########################
#     SWEP UTILITY     #
########################
]]
function SWEP:_DoIdle()
  self:SendWeaponAnim(ACT_VM_IDLE)
  timer.Adjust("scw_colt_saa_idle_anim_" .. self:EntIndex(), self:SequenceDuration(), 0, function()
    if not IsValid(self) then
      timer.Remove("scw_colt_saa_idle_anim_" .. self:EntIndex())
      return
    end
    self:SendWeaponAnim(ACT_VM_IDLE)
  end)
end

---@param recoil number
---@param delay number
function SWEP:_FireEffect(recoil, delay)
  self:ShootEffects()
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

function SWEP:_Idle()
  if CLIENT or not IsValid(self:GetOwner()) then return end
  timer.Create("scw_colt_saa_idle_anim_" .. self:EntIndex(), self:SequenceDuration() - 0.2, 1, function()
    if (not IsValid(self)) then return end
    self:_DoIdle()
  end)
end

function SWEP:_StopIdle()
  timer.Remove("scw_colt_saa_idle_anim_" .. self:EntIndex())
end

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

function SWEP:CustomAmmoDisplay()
  self.AmmoDisplay = self.AmmoDisplay or {}
  self.AmmoDisplay.Draw = true
  self.AmmoDisplay.PrimaryClip = self:Clip1()
  self.AmmoDisplay.PrimaryAmmo = self:Ammo1()
  self.AmmoDisplay.SecondaryAmmo = nil
  self.AmmoDisplay.SecondaryClip = nil
  return self.AmmoDisplay
end

function SWEP:Deploy()
  self:SendWeaponAnim(ACT_VM_DRAW)
  self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
  self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
  self:NextThink(CurTime() + self:SequenceDuration())
  self:_Idle()
  return true
end

function SWEP:Holster()
  ---@diagnostic disable-next-line: undefined-field -- I'm not sure what '.Sound' field does
  if self.Sound then
    self.Sound:Stop()
    self.Sound = nil
  end
  self:_StopIdle()
  return true
end

function SWEP:OnRemove()
  self:Holster()
end

function SWEP:Precache()
  util.PrecacheSound(self.Primary.CFG_Sound)
end

function SWEP:ShouldDropOnDie()
  -- Prevent weapon drop when user dies
  return false
end

function SWEP:Think()
  local owner = self:GetOwner() ---@cast owner Player
  if owner:KeyReleased(IN_ATTACK) or (not owner:KeyDown(IN_ATTACK) and self.Sound) then
    self:_Idle()
  end
end

--[[
########################
#     PRIMARY FIRE     #
########################
]]
function SWEP:PrimaryAttack()
  if not self:CanPrimaryAttack() then return end
  local owner = self:GetOwner() ---@cast owner NPC
  ---@type Bullet
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self.Primary.CFG_Damage,
    Dir = owner:GetAimVector(),
    Force = self.Primary.CFG_Force,
    Num = self.Primary.CFG_ShotCount,
    Spread = self.Primary.CFG_Spread,
    Src = owner:GetShootPos(),
    Tracer = 1,
    TracerName = "Tracer",
  }
  self:TakePrimaryAmmo(1)
  owner:FireBullets(bullet)
  self:EmitSound(self.Primary.CFG_Sound)
  self:_FireEffect(self.Primary.CFG_Recoil, self.Primary.CFG_Delay)
  if self:Clip1() == 0 then timer.Simple(0.01, function() self:Reload() end) else self:_Idle() end
end

--[[
##########################
#     SECONDARY FIRE     #
##########################
]]
function SWEP:SecondaryAttack()
end

--[[
##################
#     RELOAD     #
##################
]]
function SWEP:Reload()
  if self:DefaultReload(ACT_VM_RELOAD) then
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
    self:NextThink(CurTime() + self:SequenceDuration())
    self:_Idle()
  end
end
