AddCSLuaFile()
--
SWEP.AdminOnly = false
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = true
SWEP.AutoSwitchTo = false
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Weapon"
SWEP.DisableDuplicator = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.IconOverride = "materials/entities/scw_empty.png"
SWEP.Instructions = "Just an empty weapon that mimics 'No Weapon' state"
SWEP.m_bPlayPickupSound = false
SWEP.PrintName = "Empty Hands"
SWEP.Purpose = "Just an empty weapon that mimics 'No Weapon' state"
SWEP.Slot = 0
SWEP.SlotPos = 3
SWEP.Spawnable = true
SWEP.UseHands = false
SWEP.ViewModel = ""
SWEP.Weight = 999
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scw_empty") or ""
SWEP.WorldModel = ""
SWEP.CFG_HoldType = "normal"
-- SWEP Primary Fire
SWEP.Primary.Ammo = ""
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
--
local isSpawned = true
--[[
#########################
#     SWEP FUNCTION     #
#########################
]]
function SWEP:Initialize()
  self:SetHoldType(self.CFG_HoldType)
  isSpawned = true
  timer.Simple(0.2, function()
    if SERVER and IsValid(self) then
      if isSpawned then
        self:Remove()
        isSpawned = true
      else
        isSpawned = true
      end
    end
  end)
end

function SWEP:CanBePickedUpByNPCs()
  return false
end

function SWEP:Equip(_)
  isSpawned = false
end

function SWEP:ShouldDropOnDie()
  -- Prevent weapon drop when user dies
  return false
end

--[[
########################
#     PRIMARY FIRE     #
########################
]]
function SWEP:PrimaryAttack()
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
end
