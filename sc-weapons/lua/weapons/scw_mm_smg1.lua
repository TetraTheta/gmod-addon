AddCSLuaFile()
--
SWEP.AdminOnly = false
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = true
SWEP.AutoSwitchTo = true
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Weapon"
SWEP.DrawAmmo = true
SWEP.IconOverride = "materials/entities/weapon_smg1.png"
SWEP.Instructions = "SMG1 (MMod)"
SWEP.PrintName = "SMG1 (MMod)"
SWEP.Purpose = "Submachine Gun (MMod)"
SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_scw_mm_smg1.mdl"
SWEP.ViewModelFOV = 54
SWEP.Weight = 3
SWEP.WorldModel = "models/weapons/w_scw_mm_smg1.mdl"
SWEP.CFG_HoldType = "smg"
SWEP.CFG_LastMotionState = "idle"
SWEP.CFG_SlideLimit = 2
-- SWEP Primary Fire
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 90
SWEP.Primary.DefaultClip = 90
SWEP.Primary.CFG_Damage = ConVarExists("sk_plr_dmg_smg1") and GetConVar("sk_plr_dmg_smg1"):GetInt() * 2 or 8
SWEP.Primary.CFG_Delay = 0.075
SWEP.Primary.CFG_Force = 4
SWEP.Primary.CFG_MaxVerticalKick = 1
SWEP.Primary.CFG_Sound = "SCW.MM.SMG1.Single"
SWEP.Primary.CFG_SoundNPC = "SCW.MM.SMG1.Single_NPC"
SWEP.Primary.CFG_Spread = Vector(0.005, 0.005, 0)
SWEP.Primary.CFG_NPCSpread = Vector(0.08716, 0.08716, 0)
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = "SMG1_Grenade"
SWEP.Secondary.Automatic = true
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.CFG_Damage = ConVarExists("sk_plr_dmg_smg1_grenade") and GetConVar("sk_plr_dmg_smg1_grenade"):GetInt() or 100
SWEP.Secondary.CFG_Delay = 1
SWEP.Secondary.CFG_PrimaryDelay = 0.5
SWEP.Secondary.CFG_Force = 1000
SWEP.Secondary.CFG_Sound = "SCW.MM.SMG1.Secondary"
--
SWEP.NPCFireRate = SWEP.Primary.CFG_Delay
SWEP.NPCMinBurst = 2
SWEP.NPCMaxBurst = 5
SWEP.NPCMinRest = 0.3
SWEP.NPCMaxRest = 0.75
SWEP.CFG_NPCProficiencySpread = {
  [0] = 7,
  [1] = 5,
  [2] = 10 / 3,
  [3] = 5 / 3,
  [4] = 1,
}
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)

if CLIENT then
  local SMG1_SELECT_ICON_FONT = "scw_mm_smg1_select_icon"
  local SMG1_SELECT_ICON_GLYPH = "a"
  local SMG1_SELECT_ICON_COLOR = Color(255, 220, 0)

  surface.CreateFont(SMG1_SELECT_ICON_FONT, {
    font = "HalfLife2",
    size = 140,
    weight = 500,
    antialias = true,
    scanlines = 4,
    additive = true,
  })

  function SWEP:DrawWeaponSelection(x, y, width, height, alpha)
    SMG1_SELECT_ICON_COLOR.a = alpha
    draw.SimpleText(SMG1_SELECT_ICON_GLYPH, SMG1_SELECT_ICON_FONT, x + width / 2, y + height / 2, SMG1_SELECT_ICON_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
end

--[[
########################
#     SWEP UTILITY     #
########################
]]
function SWEP:_GetPrimaryDamage()
  local owner = self:GetOwner()
  if owner:IsNPC() and ConVarExists("sk_npc_dmg_smg1") then return GetConVar("sk_npc_dmg_smg1"):GetInt() end
  return self.Primary.CFG_Damage
end

---@param name string
---@return boolean
function SWEP:_SendSequence(name)
  local owner = self:GetOwner()
  if not owner:IsPlayer() then return false end
  ---@cast owner Player
  local vm = owner:GetViewModel()
  if not IsValid(vm) then return false end
  local sequence = vm:LookupSequence(name)
  if sequence < 0 then return false end
  vm:SendViewModelMatchingSequence(sequence)
  return true
end

--[[
#########################
#     SWEP FUNCTION     #
#########################
]]
function SWEP:Initialize()
  self.CFG_FireDuration = 0
  self.CFG_LastPrimary = 0
  self.CFG_LastMotionState = "idle"
  self.CFG_ShotsFired = 0
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
  self.AmmoDisplay.SecondaryAmmo = self:Ammo2()
  self.AmmoDisplay.SecondaryClip = nil
  return self.AmmoDisplay
end

function SWEP:Deploy()
  self.CFG_FireDuration = 0
  self.CFG_LastPrimary = 0
  self.CFG_LastMotionState = "idle"
  self.CFG_ShotsFired = 0
  self:SendWeaponAnim(ACT_VM_DRAW)
  self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
  self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
  return true
end

function SWEP:GetCapabilities()
  return bit.bor(CAP_WEAPON_RANGE_ATTACK1, CAP_USE_SHOT_REGULATOR)
end

function SWEP:GetNPCBulletSpread(proficiency)
  return self.CFG_NPCProficiencySpread[proficiency] or 7
end

function SWEP:GetNPCBurstSettings()
  return self.NPCMinBurst, self.NPCMaxBurst, self.NPCFireRate
end

function SWEP:GetNPCRestTimes()
  return self.NPCMinRest, self.NPCMaxRest
end

function SWEP:Holster()
  self.CFG_FireDuration = 0
  self.CFG_ShotsFired = 0
  return true
end

function SWEP:OnRemove()
  self:Holster()
end

function SWEP:NPCShoot_Primary(shootPos, shootDir)
  local owner = self:GetOwner()
  if not (IsValid(owner) and owner:IsNPC()) then return end
  ---@cast owner NPC
  ---@type Bullet
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self:_GetPrimaryDamage(),
    Dir = shootDir or owner:GetAimVector(),
    Force = 2,
    Num = 1,
    Spread = Vector(0, 0, 0),
    Src = shootPos or owner:GetShootPos(),
    Tracer = 2,
  }
  owner:FireBullets(bullet)
  owner:MuzzleFlash()
  self:TakePrimaryAmmo(1)
  self:EmitSound(self.Primary.CFG_SoundNPC)
end

function SWEP:Precache()
  util.PrecacheSound(self.Primary.CFG_Sound)
  util.PrecacheSound(self.Primary.CFG_SoundNPC)
  util.PrecacheSound(self.Secondary.CFG_Sound)
  util.PrecacheSound("Weapon_SMG1.Empty")
  util.PrecacheModel("models/Items/AR2_Grenade.mdl")
end

function SWEP:ShouldDropOnDie()
  return true
end

function SWEP:Think()
  local owner = self:GetOwner()
  if not owner:IsPlayer() then return end
  ---@cast owner Player
  if not owner:KeyDown(IN_ATTACK) then
    self.CFG_FireDuration = 0
    self.CFG_ShotsFired = 0
  end

  -- MMod viewmodel has explicit idle/walk/sprint/lowidle sequences.
  if owner:KeyDown(IN_ATTACK) or owner:KeyDown(IN_ATTACK2) then return end
  if self:GetNextPrimaryFire() > CurTime() or self:GetNextSecondaryFire() > CurTime() then return end
  local moving = owner:GetVelocity():Length2D() > 20
  local state = "idle"
  if moving and owner:KeyDown(IN_SPEED) then
    state = "sprint"
  elseif moving then
    state = "walk"
  elseif owner:KeyDown(IN_WALK) then
    state = "lowidle"
  end

  if state == self.CFG_LastMotionState then return end
  if state == "lowidle" and self.CFG_LastMotionState ~= "lowidle" then self:_SendSequence("idletolow") end
  if state == "idle" and self.CFG_LastMotionState == "lowidle" then self:_SendSequence("lowtoidle") end
  if state == "walk" or state == "sprint" or state == "lowidle" then self:_SendSequence(state) end
  if state == "idle" then self:SendWeaponAnim(ACT_VM_IDLE) end
  self.CFG_LastMotionState = state
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
  if not (owner:IsPlayer() or owner:IsNPC()) then return end
  ---@cast owner Player|NPC
  local now = CurTime()
  if now - (self.CFG_LastPrimary or 0) > self.CFG_SlideLimit then
    self.CFG_FireDuration = 0
    self.CFG_ShotsFired = 0
  end

  self.CFG_LastPrimary = now
  self.CFG_FireDuration = (self.CFG_FireDuration or 0) + self.Primary.CFG_Delay
  self.CFG_ShotsFired = (self.CFG_ShotsFired or 0) + 1
  local dir = owner:GetAimVector()
  local spread = self.Primary.CFG_Spread
  if owner:IsNPC() then
    ---@cast owner NPC
    local enemy = owner:GetEnemy()
    if IsValid(enemy) then dir = (enemy:WorldSpaceCenter() - owner:GetShootPos()):GetNormalized() end
    spread = self.Primary.CFG_NPCSpread
  end

  ---@type Bullet
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self:_GetPrimaryDamage(),
    Dir = dir,
    Force = self.Primary.CFG_Force,
    Num = 1,
    Spread = spread,
    Src = owner:GetShootPos(),
    Tracer = 2,
  }
  owner:FireBullets(bullet)
  self:TakePrimaryAmmo(1)
  self:EmitSound(owner:IsNPC() and self.Primary.CFG_SoundNPC or self.Primary.CFG_Sound)
  if owner:IsPlayer() then
    ---@cast owner Player
    local kickPerc = math.min(self.CFG_FireDuration or 0, self.CFG_SlideLimit) / self.CFG_SlideLimit
    local pitch = 0.2 + self.Primary.CFG_MaxVerticalKick * kickPerc
    local yaw = (0.2 + self.Primary.CFG_MaxVerticalKick * kickPerc) / 3
    local roll = 0.1 + self.Primary.CFG_MaxVerticalKick * kickPerc / 8
    owner:ViewPunchReset(10)
    owner:ViewPunch(Angle(-pitch, math.random(0, 1) == 0 and -yaw or yaw, math.random(0, 1) == 0 and -roll or roll) * 0.5)
  end

  local primary = ACT_VM_PRIMARYATTACK --[[@as number]]
  self:ShootEffects()
  if self.CFG_ShotsFired < 2 then
    self:SendWeaponAnim(primary)
  elseif self.CFG_ShotsFired < 3 then
    self:SendWeaponAnim(ACT_VM_RECOIL1 or primary)
  elseif self.CFG_ShotsFired < 4 then
    self:SendWeaponAnim(ACT_VM_RECOIL2 or primary)
  else
    self:SendWeaponAnim(ACT_VM_RECOIL3 or primary)
  end

  self:SetNextPrimaryFire(CurTime() + self.Primary.CFG_Delay)
  self.CFG_LastMotionState = "fire"
  if self:Clip1() == 0 then
    timer.Simple(self.Primary.CFG_Delay, function()
      if not IsValid(self) or self:Clip1() > 0 then return end
      local reloadOwner = self:GetOwner()
      ---@diagnostic disable-next-line: undefined-field
      if reloadOwner:IsPlayer() and reloadOwner:GetActiveWeapon() ~= self then return end
      self:Reload()
    end)
  end
end

--[[
##########################
#     SECONDARY FIRE     #
##########################
]]
function SWEP:SecondaryAttack()
  local owner = self:GetOwner()
  if not owner:IsPlayer() then return end
  if game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end
  if not IsFirstTimePredicted() then return end
  ---@cast owner Player
  if owner:GetAmmoCount(self.Secondary.Ammo) <= 0 then
    self:SendWeaponAnim(ACT_VM_DRYFIRE)
    self:EmitSound("Weapon_SMG1.Empty")
    self:SetNextSecondaryFire(CurTime() + 0.5)
    return
  end

  self:EmitSound(self.Secondary.CFG_Sound)
  self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
  owner:SetAnimation(PLAYER_ATTACK1)
  owner:RemoveAmmo(1, self.Secondary.Ammo)
  self:SetNextPrimaryFire(CurTime() + self.Secondary.CFG_PrimaryDelay)
  self:SetNextSecondaryFire(CurTime() + self.Secondary.CFG_Delay)
  self.CFG_LastMotionState = "alt"

  if CLIENT then return end
  local dir = owner:EyeAngles():Forward()
  local grenade = ents.Create("grenade_ar2")
  if not IsValid(grenade) then return end
  grenade:SetPos(owner:GetShootPos())
  grenade:SetAngles(dir:Angle())
  grenade:SetOwner(owner)
  grenade:SetPhysicsAttacker(owner)
  grenade:Spawn()
  grenade:Activate()
  grenade:SetMoveType(MOVETYPE_FLYGRAVITY)
  grenade:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
  grenade:SetVelocity(dir * self.Secondary.CFG_Force)
  grenade:SetLocalAngularVelocity(Angle(math.Rand(-400, 400), math.Rand(-400, 400), math.Rand(-400, 400)))
  grenade:SetSaveValue("m_flDamage", self.Secondary.CFG_Damage)
end

--[[
##################
#     RELOAD     #
##################
]]
function SWEP:Reload()
  local nextSecondaryFire = self:GetNextSecondaryFire()
  if self:DefaultReload(ACT_VM_RELOAD) then
    self:SetNextSecondaryFire(nextSecondaryFire)
    self.CFG_FireDuration = 0
    self.CFG_LastMotionState = "reload"
    self.CFG_ShotsFired = 0
  end
end
