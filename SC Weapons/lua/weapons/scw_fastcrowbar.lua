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
---@param weapon SWEP
---@param owner Entity|Player
---@param target Entity
local function _HitEntity(weapon, owner, target)
  local dmg = DamageInfo()
  dmg:SetAttacker(owner)
  dmg:SetInflictor(weapon)
  dmg:SetDamage(target:GetClass():match("npc_headcrab") and 10000 or weapon.Primary.CFG_Damage)
  dmg:SetDamageType(DMG_CLUB)
  dmg:SetDamageForce(owner:GetAimVector():GetNormalized() * 1000)
  target:TakeDamageInfo(dmg)
end

---@param weapon SWEP
---@param owner Entity|Player
local function _FireBullet(weapon, owner)
  ---@type Bullet
  local bullet = {
    Attacker = owner,
    Damage = weapon.Primary.CFG_Damage,
    Force = weapon.Primary.CFG_Force,
    Distance = 100,
    Tracer = 0,
    Dir = owner:GetAimVector(),
    Src = owner:GetShootPos()
  }
  weapon:FireBullets(bullet)
end

function SWEP:PrimaryAttack()
  local owner = self:GetOwner()
  ---@cast owner Player
  ---@type TraceResult
  local tr = util.TraceHull({
    start = owner:GetShootPos(),
    endpos = owner:GetShootPos() + (owner:GetAimVector() * 100),
    filter = owner,
    mins = Vector(-18, -18, -18),
    maxs = Vector(18, 18, 18),
    mask = MASK_SHOT_HULL
  })

  if tr.Hit then
    local e = tr.Entity
    self:SendWeaponAnim(ACT_VM_HITCENTER)
    if IsValid(e) then
      local cls = e:GetClass()
      if string.find(cls, "npc") or cls == "prop_ragdoll" or e:IsPlayer() then
        _HitEntity(self, owner, e)
      else
        _FireBullet(self, owner)
      end
    else
      _FireBullet(self, owner)
    end
    self:EmitSound(self.Primary.CFG_Sound_MeleeHit)
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
