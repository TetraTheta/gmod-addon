AddCSLuaFile()
--
SWEP.AdminOnly = false
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = false
SWEP.AutoSwitchTo = true
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Weapon"
SWEP.DisableDuplicator = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.IconOverride = "materials/entities/scw_fastcrowbar.png"
SWEP.Instructions = "Fast HL2 Crowbar"
SWEP.m_bPlayPickupSound = true
SWEP.PrintName = "Fast Crowbar"
SWEP.Purpose = "Fast HL2 Crowbar"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.Weight = 999
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scw_fastcrowbar") or ""
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.CFG_HoldType = "melee"
-- SWEP Primary Fire
SWEP.Primary.Ammo = ""
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.CFG_Damage = ConVarExists("sk_plr_dmg_crowbar") and GetConVar("sk_plr_dmg_crowbar"):GetInt() or 10
SWEP.Primary.CFG_Delay = 0.1
SWEP.Primary.CFG_Force = 1
SWEP.Primary.CFG_Recoil = 0.1
SWEP.Primary.CFG_Sound_MeleeHit = "Weapon_Crowbar.Melee_Hit"
SWEP.Primary.CFG_Sound_MeleeHitWorld = "Weapon_Crowbar.Melee_HitWorld"
SWEP.Primary.CFG_Sound_Single = "Weapon_Crowbar.Single"
SWEP.Primary.CFG_Spread = 0.015
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
--[[
#########################
#     SWEP FUNCTION     #
#########################
]]
function SWEP:Initialize()
  self:SetHoldType(self.CFG_HoldType)
end

function SWEP:CanBePickedUpByNPCs()
  return false
end

function SWEP:ShouldDropOnDie()
  return false
end

--[[
########################
#     PRIMARY FIRE     #
########################
]]
function SWEP:PrimaryAttack()
  local owner = self:GetOwner()
  ---@cast owner Player
  ---@type TraceResult
  local tr = util.TraceHull({
    start = owner:GetShootPos(),
    endpos = owner:GetShootPos() + (owner:GetAimVector() * 80),
    filter = owner,
    mins = Vector(-10, -10, -10),
    maxs = Vector(10, 10, 10),
    mask = MASK_SHOT_HULL
  })
  if tr.Hit then
    local e = tr.Entity
    self:SendWeaponAnim(ACT_VM_HITCENTER)
    ---@type Bullet
    self:FireBullets({
      Attacker = owner,
      Src = owner:GetShootPos(),
      Distance = 90,
      Dir = tr.Normal,
      Tracer = 0,
      Force = self.Primary.CFG_Force,
      Damage = (IsValid(e) and string.find(e:GetClass(), "npc_headcrab")) and 10000 or self.Primary.CFG_Damage
    })
    if not (e:IsPlayer() or string.find(e:GetClass(), "npc") or e:GetClass() == "prop_ragdoll") then
      self:EmitSound(self.Primary.CFG_Sound_MeleeHit)
    end
  else
    self:SendWeaponAnim(ACT_VM_MISSCENTER)
    self:EmitSound(self.Primary.CFG_Sound_Single)
  end
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
