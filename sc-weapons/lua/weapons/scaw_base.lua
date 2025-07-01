AddCSLuaFile()
--
SWEP.AdminOnly = true
SWEP.Author = "TetraTheta"
SWEP.AutoSwitchFrom = false
SWEP.AutoSwitchTo = false
SWEP.BounceWeaponIcon = false
SWEP.Category = "SC Admin Weapon"
SWEP.DrawAmmo = false
SWEP.IconOverride = "" -- [!!!!] Override this from child SWEPs!
SWEP.Instructions = "" -- [!!!!] Override this from child SWEPs!
SWEP.PrintName = ""    -- [!!!!] Override this from child SWEPs!
SWEP.Purpose = ""      -- [!!!!] Override this from child SWEPs!
SWEP.Slot = 0          -- [!!!!] Override this from child SWEPs!
SWEP.SlotPos = 0       -- [!!!!] Override this from child SWEPs!
SWEP.Spawnable = false -- [!!!!] Override this from child SWEPs!
SWEP.UseHands = true
SWEP.ViewModel = ""    -- [!!!!] Override this from child SWEPs!
SWEP.Weight = 999
SWEP.WorldModel = ""   -- [!!!!] Override this from child SWEPs!
SWEP.CFG_HoldType = "" -- [!!!!] Override this from child SWEPs!
-- SWEP Primary Fire
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 10
SWEP.Primary.CFG_Damage = 99999999999
SWEP.Primary.CFG_Delay = 0.05
SWEP.Primary.CFG_Force = 1000000
SWEP.Primary.CFG_Recoil = 0.1
SWEP.Primary.CFG_ShotCount = 75
SWEP.Primary.CFG_Sound = "" -- [!!!!] Override this from child SWEPs!
SWEP.Primary.CFG_Spread = 0.015
-- SWEP Secondary Fire
SWEP.Secondary.Ammo = "Pistol"
SWEP.Secondary.Automatic = true
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 10
SWEP.Secondary.CFG_Recoil = 0.1
SWEP.Secondary.MOD_Max = 4
SWEP.Secondary.MOD_Current = ConVarExists("scaw_pistol_default") and GetConVar("scaw_pistol_default"):GetInt() or 1
-- SWEP Secondary Fire | Mode 1 - Explosion
SWEP.Secondary.MOD_EXP_Delay = 0.05
SWEP.Secondary.MOD_EXP_Magnitude = 175
SWEP.Secondary.MOD_EXP_Sound = "SCAW.Base.Explosion"
-- SWEP Secondary Fire | Mode 2 - Airboat Gun
SWEP.Secondary.MOD_ABG_Damage = 50
SWEP.Secondary.MOD_ABG_Delay = 0.05
SWEP.Secondary.MOD_ABG_Force = 1000000
SWEP.Secondary.MOD_ABG_ShotCount = 7
SWEP.Secondary.MOD_ABG_Sound = "SCAW.Base.Airboat"
SWEP.Secondary.MOD_ABG_Spread = 0.2
-- SWEP Secondary Fire | Mode 3 - Combine Ball
SWEP.Secondary.MOD_CMB_Delay = 0.5
SWEP.Secondary.MOD_CMB_Lifespan = 5
SWEP.Secondary.MOD_CMB_Sound1 = "SCAW.Base.CombineBall1"
SWEP.Secondary.MOD_CMB_Sound2 = "SCAW.Base.CombineBall2"
SWEP.Secondary.MOD_CMB_Speed = 3000
-- SWEP Secondary Fire | Mode 4 - Armed Grenade
SWEP.Secondary.MOD_GRN_Delay = 0.25
SWEP.Secondary.MOD_GRN_Force = 1000
SWEP.Secondary.MOD_GRN_Lifespan = 3
SWEP.Secondary.MOD_GRN_Sound = "SCAW.Base.Grenade"
--
-- [!!!!] Precache ViewModel and WorldModel!
--util.PrecacheModel(SWEP.ViewModel)
--util.PrecacheModel(SWEP.WorldModel)
--[[
########################
#     SWEP UTILITY     #
########################
]]

---@return Entity exp env_explosion
function SWEP:_CreateEnvExplosion()
  local exp = ents.Create("env_explosion")
  exp:SetKeyValue("iMagnitude", tostring(self.Secondary.MOD_EXP_Magnitude))
  -- Repeatable(2) + No Fireball(4) + No Smoke(8) + No Decal(16) + No Sparks(32) + No Sound(64) + No Fireball Smoke(256) + No Particles(512)
  exp:SetKeyValue("spawnflags", "894")
  self:DeleteOnRemove(exp)
  -- self:GetOwner() isn't available in here!
  return exp
end

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

function SWEP:GetSecondaryMode()
  return self.Secondary.MOD_Current
end

function SWEP:SetSecondaryMode(new)
  self.Secondary.MOD_Current = new
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
--
function SWEP:Initialize()
  self:SetHoldType(self.CFG_HoldType)

  if SERVER then
    self.ExpPool = {}
    self.NxtExpNum = 1

    for i = 1, 7 do
      local e = self:_CreateEnvExplosion()
      e:Spawn()
      e:Activate()
      table.insert(self.ExpPool, i, e)
    end
  end
end

function SWEP:CanBePickedUpByNPCs()
  return true
end

-- Disable ammo display
function SWEP:CustomAmmoDisplay()
  return { false, 0, 0, 0 }
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
local no_damage = {
  npc_rollermine = true,
  npc_turret_floor = true,
}
local no_damage_force = {
  npc_strider = true,
}

function SWEP:PrimaryAttack()
  -- Skip ammo check performed by 'CanPrimaryAttack'
  local owner = self:GetOwner() ---@cast owner NPC
  ---@type Bullet
  ---@diagnostic disable-next-line: missing-fields
  local bullet = {
    AmmoType = self.Primary.Ammo,
    Damage = self.Primary.CFG_Damage,
    Dir = owner:GetAimVector(),
    Force = self.Primary.CFG_Force,
    Num = self.Primary.CFG_ShotCount,
    Spread = Vector(self.Primary.CFG_Spread, self.Primary.CFG_Spread, 0),
    Src = owner:GetShootPos(),
    Tracer = 1,
    TracerName = "Tracer",
    Callback = function(_, tr, _)
      local ent = tr.Entity
      if IsValid(ent) then
        local cls = ent:GetClass()
        if no_damage_force[cls] then return { damage = false, effects = false } end
        if no_damage[cls] then
          local pushDir = tr.Normal
          local phys = ent:GetPhysicsObject()
          if IsValid(phys) then
            phys:ApplyForceOffset(pushDir * self.Primary.CFG_Force, tr.HitPos)
          else
            ent:SetVelocity(pushDir * self.Primary.CFG_Force)
          end
          return { damage = false, effects = true }
        end
        return { damage = true, effects = true }
      end
    end
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
  -- Skip ammo check performed by 'CanSecondaryAttack'
  local mode = self:GetSecondaryMode()
  if mode == 1 then
    self:_SA_Explosion()
  elseif mode == 2 then
    self:_SA_AirboatGun()
  elseif mode == 3 then
    self:_SA_CombineBall()
  elseif mode == 4 then
    self:_SA_Grenade()
  end
end

function SWEP:_SA_Explosion()
  -- NPC cannot do secondary attack
  local owner = self:GetOwner() ---@cast owner Player
  if not IsValid(owner) then return end
  if SERVER then
    local hitpos = owner:GetEyeTrace().HitPos
    local idx = self.NxtExpNum
    local e = self.ExpPool[idx]
    if not IsValid(e) then
      e = self:_CreateEnvExplosion()
      e:Spawn()
      e:Activate()
      table.insert(self.ExpPool, idx, e)
    end
    e:SetCreator(owner)
    e:SetOwner(owner)
    e:SetPos(hitpos)
    e:Fire("Explode")

    self.NxtExpNum = idx % #self.ExpPool + 1
  end

  self:EmitSound(self.Secondary.MOD_EXP_Sound)
  self:_FireEffect(false, self.Secondary.CFG_Recoil, self.Secondary.MOD_EXP_Delay)
end

function SWEP:_SA_AirboatGun()
  -- NPC cannot do secondary attack
  local owner = self:GetOwner() ---@cast owner Player
  ---@type Bullet
  ---@diagnostic disable-next-line: missing-fields
  local bullet = {
    AmmoType = self.Secondary.Ammo,
    ---@param di CTakeDamageInfo
    Callback = function(_, _, di)
      local r = math.random(1, 2) -- either 1 or 2
      if r == 1 then
        di:SetDamageType(DMG_AIRBOAT)
      else
        di:SetDamageType(DMG_BLAST)
      end
    end,
    Damage = self.Secondary.MOD_ABG_Damage,
    Dir = owner:GetAimVector(),
    Force = self.Secondary.MOD_ABG_Force,
    Num = self.Secondary.MOD_ABG_ShotCount,
    Spread = self.Secondary.MOD_ABG_Spread,
    Src = owner:GetShootPos(),
    Tracer = 1,
    TracerName = "AirboatGunTracer"
  }

  owner:FireBullets(bullet)
  self:EmitSound(self.Secondary.MOD_ABG_Sound)
  self:_FireEffect(true, self.Secondary.CFG_Recoil, self.Secondary.MOD_ABG_Delay)
end

function SWEP:_SA_CombineBall()
  -- NPC cannot do secondary attack
  local owner = self:GetOwner() ---@cast owner Player
  if SERVER then
    local cb = ents.Create("prop_combine_ball")
    local ang = owner:GetAimVector():Angle()
    local fwd = ang:Forward()
    cb:SetPos(owner:GetShootPos())
    cb:SetAngles(ang)
    cb:SetOwner(owner)
    cb:SetSaveValue("m_flRadius", 5)
    cb:SetSaveValue("m_nMaxBounces", 10)
    cb:Spawn()
    cb:Activate()
    cb:SetSaveValue("m_nState", 2) -- STATE_THROWN
    cb:SetSaveValue("m_flSpeed", self.Secondary.MOD_CMB_Speed)
    cb:GetPhysicsObject():SetVelocity(fwd * self.Secondary.MOD_CMB_Speed)
    cb:Fire("Explode", nil, self.Secondary.MOD_CMB_Lifespan)
  end

  self:EmitSound(self.Secondary.MOD_CMB_Sound1)
  self:EmitSound(self.Secondary.MOD_CMB_Sound2)
  self:_FireEffect(false, self.Secondary.CFG_Recoil, self.Secondary.MOD_CMB_Delay)
end

function SWEP:_SA_Grenade()
  -- NPC cannot do secondary attack
  local owner = self:GetOwner() ---@cast owner Player
  if SERVER then
    local fwd = owner:EyeAngles():Forward()
    local g = ents.Create("npc_grenade_frag")
    g:SetPos(owner:GetShootPos() + fwd * 32)
    g:SetAngles(owner:EyeAngles())
    g:SetOwner(owner)
    g:SetPhysicsAttacker(owner)
    g:Spawn()
    g:Fire("SetTimer", tostring(self.Secondary.MOD_GRN_Lifespan))
    g:SetName(self:GetClass() .. "_grenade_" .. self:_CreateRandomString())
    g:SetSaveValue("m_flDetonateTime", tostring(self.Secondary.MOD_GRN_Lifespan))
    g:SetSaveValue("m_hThrower", owner)
    local p = g:GetPhysicsObject()
    if IsValid(p) then p:SetVelocity(owner:GetAimVector() * self.Secondary.MOD_GRN_Force) end
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
