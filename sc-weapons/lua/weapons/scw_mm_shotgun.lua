AddCSLuaFile()
--
SWEP.AdminOnly = false
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = true
SWEP.AutoSwitchTo = true
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Weapon"
SWEP.DrawAmmo = true
SWEP.IconOverride = "materials/entities/weapon_shotgun.png"
SWEP.Instructions = "Shotgun (MMod)"
SWEP.PrintName = "Shotgun (MMod)"
SWEP.Purpose = "SPAS-12 Shotgun (MMod)"
SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_scw_mm_shotgun.mdl"
SWEP.ViewModelFOV = 54
SWEP.Weight = 4
SWEP.WorldModel = "models/weapons/w_scw_mm_shotgun.mdl"
SWEP.CFG_HoldType = "shotgun"
SWEP.CFG_LastMotionState = "idle"
-- SWEP Primary Fire
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 8 -- 6
SWEP.Primary.DefaultClip = 8 -- 6
SWEP.Primary.CFG_Damage = ConVarExists("sk_plr_dmg_buckshot") and GetConVar("sk_plr_dmg_buckshot"):GetInt() * 2 or 16
SWEP.Primary.CFG_Delay = 0.7
SWEP.Primary.CFG_Force = 4
SWEP.Primary.CFG_Num = 12 -- 8
SWEP.Primary.CFG_NPCSpread = Vector(0.08716, 0.08716, 0)
SWEP.Primary.CFG_Sound = "SCW.MM.Shotgun.Single"
SWEP.Primary.CFG_SoundNPC = "SCW.MM.Shotgun.Single_NPC"
SWEP.Primary.CFG_Spread = Vector(0.04, 0.04, 0)
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = "Buckshot"
SWEP.Secondary.Automatic = true
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.CFG_AmmoTake = 2
SWEP.Secondary.CFG_Num = 24 -- 12
SWEP.Secondary.CFG_Sound = "SCW.MM.Shotgun.Double"
--
SWEP.NPCFireRate = 0.7
SWEP.NPCMinBurst = 1
SWEP.NPCMaxBurst = 3
SWEP.NPCMinRest = 0.3
SWEP.NPCMaxRest = 0.6
SWEP.CFG_NPCProficiencySpread = {
  [0] = 10,
  [1] = 10,
  [2] = 10,
  [3] = 10,
  [4] = 10,
}
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)

if CLIENT then
  local SHOTGUN_SELECT_ICON_FONT = "scw_mm_shotgun_select_icon"
  local SHOTGUN_SELECT_ICON_GLYPH = "b"
  local SHOTGUN_SELECT_ICON_COLOR = Color(255, 220, 0)

  surface.CreateFont(SHOTGUN_SELECT_ICON_FONT, {
    font = "HalfLife2",
    size = 140,
    weight = 500,
    antialias = true,
    scanlines = 4,
    additive = true,
  })

  ---@param x number
  ---@param y number
  ---@param width number
  ---@param height number
  ---@param alpha number
  function SWEP:DrawWeaponSelection(x, y, width, height, alpha)
    SHOTGUN_SELECT_ICON_COLOR.a = alpha
    draw.SimpleText(SHOTGUN_SELECT_ICON_GLYPH, SHOTGUN_SELECT_ICON_FONT, x + width / 2, y + height / 2, SHOTGUN_SELECT_ICON_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
end

--[[
########################
#     SWEP UTILITY     #
########################
]]

---@return boolean
function SWEP:_CanReload()
  local owner = self:GetOwner()
  if not (IsValid(owner) and owner:IsPlayer()) then return false end
  ---@cast owner Player
  return self:Clip1() < self.Primary.ClipSize and owner:GetAmmoCount(self.Primary.Ammo) > 0
end

---@return nil
function SWEP:_DryFire()
  self:EmitSound("Weapon_Shotgun.Empty")
  self:SendWeaponAnim(ACT_VM_DRYFIRE)
  self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
  self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
end

---@return nil
function SWEP:_FinishReload()
  self.CFG_InReload = false
  self.CFG_ReloadFinishPending = false
  self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
  self:SetBodygroup(1, 1)
  local duration = self:SequenceDuration()
  self:SetNextPrimaryFire(CurTime() + duration)
  self:SetNextSecondaryFire(CurTime() + duration)
  self.CFG_NextReloadStep = CurTime() + duration
  self.CFG_LastMotionState = "reload_finish"
end

---@return number
function SWEP:_GetNPCDamage()
  if ConVarExists("sk_npc_dmg_buckshot") then return GetConVar("sk_npc_dmg_buckshot"):GetInt() end
  return 8
end

---@return number
function SWEP:_GetPrimaryDamage()
  return self.Primary.CFG_Damage
end

---@return nil
function SWEP:_InsertShell()
  local owner = self:GetOwner()
  if not (IsValid(owner) and owner:IsPlayer()) then return end
  ---@cast owner Player
  if owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self:Clip1() >= self.Primary.ClipSize then return end
  self:SetClip1(self:Clip1() + 1)
  owner:RemoveAmmo(1, self.Primary.Ammo)
end

---@return nil
function SWEP:_Pump()
  self.CFG_NeedPump = false
  self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
  local duration = self:SequenceDuration()
  self:SetNextPrimaryFire(CurTime() + duration)
  self:SetNextSecondaryFire(CurTime() + duration)
  self.CFG_LastMotionState = "pump"
end

---@param name string
---@return boolean, number
function SWEP:_SendSequence(name)
  local owner = self:GetOwner()
  if not owner:IsPlayer() then return false, 0 end
  ---@cast owner Player
  local vm = owner:GetViewModel()
  if not IsValid(vm) then return false, 0 end
  local sequence = vm:LookupSequence(name)
  if sequence < 0 then return false, 0 end
  vm:SendViewModelMatchingSequence(sequence)
  return true, vm:SequenceDuration(sequence) or 0
end

---@return boolean
function SWEP:_StartReload()
  if not self:_CanReload() then return false end
  if self:Clip1() <= 0 then self.CFG_NeedPump = true end
  self.CFG_InReload = true
  self.CFG_ReloadFinishPending = false
  self.CFG_LastMotionState = "reload_start"
  self.CFG_NextReloadStep = CurTime()
  self.CFG_DelayedFire1 = false
  self.CFG_DelayedFire2 = false
  self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
  self:SetBodygroup(1, 0)
  local duration = self:SequenceDuration()
  self:SetNextPrimaryFire(CurTime() + duration)
  self:SetNextSecondaryFire(CurTime() + duration)
  self.CFG_NextReloadStep = CurTime() + duration
  return true
end

---@return nil
function SWEP:_ThinkMotion()
  local owner = self:GetOwner()
  if not owner:IsPlayer() then return end
  ---@cast owner Player
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

---@return nil
function SWEP:_ThinkReload()
  if not self.CFG_InReload or (self.CFG_NextReloadStep or 0) > CurTime() then return end
  local owner = self:GetOwner()
  if not IsValid(owner) then
    self.CFG_InReload = false
    return
  end

  if owner:IsPlayer() then
    ---@cast owner Player
    if owner:KeyDown(IN_ATTACK) and self:Clip1() >= 1 then
      self.CFG_DelayedFire1 = true
    elseif owner:KeyDown(IN_ATTACK2) and self:Clip1() >= self.Secondary.CFG_AmmoTake then
      self.CFG_DelayedFire2 = true
    end
  end

  if self.CFG_DelayedFire1 or self.CFG_DelayedFire2 then
    self.CFG_InReload = false
    self.CFG_NeedPump = false
    self:SetBodygroup(1, 1)
    return
  end

  if not self:_CanReload() then
    self:_FinishReload()
    return
  end

  self:_InsertShell()
  self:EmitSound("SCW.MM.Shotgun.Reload")
  self:SendWeaponAnim(ACT_VM_RELOAD)
  local duration = self:SequenceDuration()
  self:SetNextPrimaryFire(CurTime() + duration)
  self:SetNextSecondaryFire(CurTime() + duration)
  self.CFG_NextReloadStep = CurTime() + duration
  self.CFG_LastMotionState = "reload"
end

---@return nil
function SWEP:_TryDelayedFire()
  if self.CFG_InReload or self.CFG_NeedPump or self:GetNextPrimaryFire() > CurTime() then return end
  if self.CFG_DelayedFire2 then
    self.CFG_DelayedFire2 = false
    self:SecondaryAttack()
  elseif self.CFG_DelayedFire1 then
    self.CFG_DelayedFire1 = false
    self:PrimaryAttack()
  end
end

--[[
#########################
#     SWEP FUNCTION     #
#########################
]]

---@return boolean
function SWEP:CanBePickedUpByNPCs()
  return true
end

---@return table
function SWEP:CustomAmmoDisplay()
  self.AmmoDisplay = self.AmmoDisplay or {}
  self.AmmoDisplay.Draw = true
  self.AmmoDisplay.PrimaryClip = self:Clip1()
  self.AmmoDisplay.PrimaryAmmo = self:Ammo1()
  self.AmmoDisplay.SecondaryAmmo = nil
  self.AmmoDisplay.SecondaryClip = nil
  return self.AmmoDisplay
end

---@return boolean
function SWEP:Deploy()
  self.CFG_LastMotionState = "draw"
  self:SendWeaponAnim(ACT_VM_DRAW)
  local duration = self:SequenceDuration()
  self:SetNextPrimaryFire(CurTime() + duration)
  self:SetNextSecondaryFire(CurTime() + duration)
  return true
end

---@param _pos any
---@param _ang any
---@param evt number
---@param _options any
---@return boolean?
function SWEP:FireAnimationEvent(_pos, _ang, evt, _options)
  -- Disable Brass Shell Ejection
  if evt == 6001 then return true end
end

---@return number
function SWEP:GetCapabilities()
  return bit.bor(CAP_WEAPON_RANGE_ATTACK1, CAP_USE_SHOT_REGULATOR)
end

---@param proficiency number
---@return number
function SWEP:GetNPCBulletSpread(proficiency)
  return self.CFG_NPCProficiencySpread[proficiency] or 10
end

---@return number, number, number
function SWEP:GetNPCBurstSettings()
  return self.NPCMinBurst, self.NPCMaxBurst, self.NPCFireRate
end

---@return number, number
function SWEP:GetNPCRestTimes()
  return self.NPCMinRest, self.NPCMaxRest
end

---@return boolean
function SWEP:Holster()
  self.CFG_LastMotionState = "idle"
  return true
end

---@return nil
function SWEP:Initialize()
  self.CFG_DelayedFire1 = false
  self.CFG_DelayedFire2 = false
  self.CFG_InReload = false
  self.CFG_LastMotionState = "idle"
  self.CFG_NeedPump = false
  self.CFG_NextReloadStep = 0
  self.CFG_ReloadFinishPending = false
  self:SetHoldType(self.CFG_HoldType)
  self:SetBodygroup(1, 1)
end

---@return nil
function SWEP:OnRemove()
  self:Holster()
end

---@param shootPos Vector
---@param shootDir Vector
---@return nil
function SWEP:NPCShoot_Primary(shootPos, shootDir)
  local owner = self:GetOwner()
  if not (IsValid(owner) and owner:IsNPC()) then return end
  ---@cast owner NPC
  ---@type Bullet
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self:_GetNPCDamage(),
    Dir = shootDir or owner:GetAimVector(),
    Force = 2,
    Num = self.Primary.CFG_Num,
    Spread = self.Primary.CFG_NPCSpread,
    Src = shootPos or owner:GetShootPos(),
    Tracer = 0,
  }
  owner:FireBullets(bullet)
  owner:MuzzleFlash()
  self:TakePrimaryAmmo(1)
  self:EmitSound(self.Primary.CFG_SoundNPC)
end

---@return nil
function SWEP:Precache()
  util.PrecacheSound(self.Primary.CFG_Sound)
  util.PrecacheSound(self.Primary.CFG_SoundNPC)
  util.PrecacheSound(self.Secondary.CFG_Sound)
  util.PrecacheSound("SCW.MM.Shotgun.CockBack")
  util.PrecacheSound("SCW.MM.Shotgun.CockForward")
  util.PrecacheSound("SCW.MM.Shotgun.Double_NPC")
  util.PrecacheSound("SCW.MM.Shotgun.Draw")
  util.PrecacheSound("SCW.MM.Shotgun.Reload")
  util.PrecacheSound("Weapon_Shotgun.Empty")
end

---@return boolean
function SWEP:ShouldDropOnDie()
  return true
end

---@return nil
function SWEP:Think()
  self:_ThinkReload()
  if self.CFG_NeedPump and not self.CFG_InReload and self:GetNextPrimaryFire() <= CurTime() then
    self:_Pump()
    return
  end

  self:_TryDelayedFire()
  local owner = self:GetOwner()
  ---@diagnostic disable-next-line: undefined-field
  local active = IsValid(owner) and owner:IsPlayer() and owner:GetActiveWeapon() == self
  if active and self:Clip1() <= 0 and self:_CanReload() and self:GetNextPrimaryFire() <= CurTime() then
    self:_StartReload()
    return
  end

  self:_ThinkMotion()
end

--[[
########################
#     PRIMARY FIRE     #
########################
]]

---@return nil
function SWEP:PrimaryAttack()
  if game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end
  if self.CFG_InReload then
    if self:Clip1() >= 1 then self.CFG_DelayedFire1 = true end
    return
  end

  if self.CFG_NeedPump then return end
  local owner = self:GetOwner()
  if not (owner:IsPlayer() or owner:IsNPC()) then return end
  if owner:IsNPC() then
    ---@cast owner NPC
    self:NPCShoot_Primary(owner:GetShootPos(), owner:GetAimVector())
    return
  end

  ---@cast owner Player
  if self:Clip1() <= 0 then
    if owner:GetAmmoCount(self.Primary.Ammo) > 0 then
      self:Reload()
    else
      self:_DryFire()
    end

    return
  end

  if not (IsFirstTimePredicted() and self:CanPrimaryAttack()) then return end
  ---@type Bullet
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self:_GetPrimaryDamage(),
    Dir = owner:GetAimVector(),
    Force = self.Primary.CFG_Force,
    Num = self.Primary.CFG_Num,
    Spread = self.Primary.CFG_Spread,
    Src = owner:GetShootPos(),
    Tracer = 0,
  }
  owner:FireBullets(bullet)
  owner:MuzzleFlash()
  owner:SetAnimation(PLAYER_ATTACK1)
  owner:ViewPunch(Angle(math.Rand(-2, -1), math.Rand(-2, 2), 0))
  self:TakePrimaryAmmo(1)
  self:EmitSound(self.Primary.CFG_Sound)
  self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
  self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
  self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
  self.CFG_LastMotionState = "fire"
  if self:Clip1() > 0 then self.CFG_NeedPump = true end
end

--[[
##########################
#     SECONDARY FIRE     #
##########################
]]

---@return nil
function SWEP:SecondaryAttack()
  local owner = self:GetOwner()
  if not owner:IsPlayer() then return end
  if game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end
  if self.CFG_InReload then
    if self:Clip1() >= self.Secondary.CFG_AmmoTake then self.CFG_DelayedFire2 = true end
    return
  end

  if self.CFG_NeedPump or not IsFirstTimePredicted() then return end
  ---@cast owner Player
  if self:Clip1() <= 1 then
    if self:Clip1() == 1 then
      self:PrimaryAttack()
    elseif owner:GetAmmoCount(self.Primary.Ammo) > 0 then
      self:Reload()
    else
      self:_DryFire()
    end

    return
  end

  ---@type Bullet
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self:_GetPrimaryDamage(),
    Dir = owner:GetAimVector(),
    Force = self.Primary.CFG_Force,
    Num = self.Secondary.CFG_Num,
    Spread = self.Primary.CFG_Spread,
    Src = owner:GetShootPos(),
    Tracer = 0,
  }
  owner:FireBullets(bullet)
  owner:MuzzleFlash()
  owner:SetAnimation(PLAYER_ATTACK1)
  owner:ViewPunch(Angle(math.Rand(-5, 5), 0, 0))
  self:TakePrimaryAmmo(self.Secondary.CFG_AmmoTake)
  self:EmitSound(self.Secondary.CFG_Sound)
  self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
  self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
  self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
  self.CFG_LastMotionState = "alt"
  if self:Clip1() > 0 then self.CFG_NeedPump = true end
end

--[[
##################
#     RELOAD     #
##################
]]

---@return nil
function SWEP:Reload()
  if self.CFG_InReload then return end
  self:_StartReload()
end
