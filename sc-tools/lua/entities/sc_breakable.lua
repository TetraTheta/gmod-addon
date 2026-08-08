--[[
Minor GLua-only knockoff of func_breakable for maps that cannot be recompiled.
Prefer a real func_breakable whenever the BSP can be rebuilt.
sc_breakable only provides a transparent box collision/damage volume, basic break I/O, simple hit/break sounds, effects,
spawnobject, and explosion damage.
It does not create a BSP brush model, read VMF side planes, use per-face materials, receive baked lighting, keep brush decals,
support bullet penetration, expose brush surface data, or make NPC/AI treat it like a compiled solid brush.
]]
if SERVER then AddCSLuaFile() end
---@class SCBreakable : Entity
---@field BreakableMaterial integer
---@field Enabled boolean
---@field ExplodeDamage number
---@field ExplodeMagnitude integer
---@field ExplodeRadius number
---@field Explosion integer
---@field GibDir Angle
---@field GibModel string|nil
---@field HealthValue integer
---@field MaxHealthValue integer
---@field MinHealthDamage integer
---@field NoDamageForces boolean
---@field PerformanceMode integer
---@field PhysDamageScale number
---@field PressureDelay number
---@field SpawnFlags integer
---@field SpawnObject integer
---@field StartDisabled boolean
---@field UseMaxs Vector
---@field UseMins Vector
---@field _break_pending boolean
---@field _broken boolean
DEFINE_BASECLASS("sc_anim")
ENT.Base = "sc_anim"
ENT.RenderGroup = RENDERGROUP_OTHER
ENT.Type = "anim"

if CLIENT then return end
--
local EXPLOSION_RANDOM = 0
local EXPLOSION_DIRECTED = 1
local EXPLOSION_PRECISE = 2
local MATERIAL_UNBREAKABLE_GLASS = 7
local PM_NO_GIBS = 1
local PM_REDUCED_GIBS = 2
local SF_BREAK_PHYSICS = 512
local SF_BREAK_PRESSURE = 4
local SF_BREAK_TOUCH = 2
local SF_BREAK_TRIGGER_ONLY = 1
local SF_NO_PHYSICS_DAMAGE = 1024
local ZERO_ANGLE = Angle(0, 0, 0)
local ZERO_VECTOR = Vector(0, 0, 0)
local DEFAULT_MINS = Vector(-16, -16, -16)
local DEFAULT_MAXS = Vector(16, 16, 16)
local MATERIAL_BREAK_SOUNDS = {
  [0] = "Breakable.Glass",
  [1] = "Breakable.Crate",
  [2] = "Breakable.Metal",
  [3] = "Breakable.Flesh",
  [4] = "Breakable.Concrete",
  [5] = "Breakable.Ceiling",
  [6] = "Breakable.Computer",
  [7] = "Breakable.MatGlass",
  [8] = "Breakable.Concrete"
}
local MATERIAL_HIT_SOUNDS = {
  [0] = "Breakable.MatGlass",
  [1] = "Breakable.MatWood",
  [2] = "Breakable.MatMetal",
  [3] = "Breakable.MatFlesh",
  [4] = "Breakable.MatConcrete",
  [6] = "Breakable.Computer",
  [7] = "Breakable.MatGlass",
  [8] = "Breakable.MatConcrete"
}
local MATERIAL_EFFECTS = {
  [0] = "GlassImpact",
  [2] = "MetalSpark",
  [6] = "ManhackSparks",
  [7] = "GlassImpact"
}
local SPAWN_OBJECTS = {
  [1] = "item_battery",
  [2] = "item_healthkit",
  [3] = "item_ammo_pistol",
  [4] = "item_ammo_pistol_large",
  [5] = "item_ammo_smg1",
  [6] = "item_ammo_smg1_large",
  [7] = "item_ammo_ar2",
  [8] = "item_ammo_ar2_large",
  [9] = "item_box_buckshot",
  [10] = "item_flare_round",
  [11] = "item_box_flare_rounds",
  [12] = "item_rpg_round",
  [16] = "weapon_stunstick",
  [18] = "weapon_ar2",
  [20] = "weapon_rpg",
  [21] = "weapon_smg1",
  [24] = "weapon_shotgun",
  [26] = "item_dynamic_resupply"
}
--
---@param value string|nil
---@return Angle
local function AngleFromString(value)
  if not isstring(value) then return ZERO_ANGLE end
  ---@cast value string
  local p, y, r = value:match("^%s*(%-?[%d%.]+)%s+(%-?[%d%.]+)%s+(%-?[%d%.]+)%s*$")
  return Angle(tonumber(p) or 0, tonumber(y) or 0, tonumber(r) or 0)
end

---@param value string|nil
---@return boolean
local function BooleanFromString(value)
  return value == "1" or value == "true"
end

---@param value string|nil
---@param fallback Vector
---@return Vector
local function VectorFromString(value, fallback)
  if not isstring(value) then return fallback end
  ---@cast value string
  local x, y, z = value:match("^%s*(%-?[%d%.]+)%s+(%-?[%d%.]+)%s+(%-?[%d%.]+)%s*$")
  return Vector(tonumber(x) or fallback.x, tonumber(y) or fallback.y, tonumber(z) or fallback.z)
end

---@param ply Player
---@param tr TraceResult
---@param className string
---@return Entity|nil
function ENT.SpawnFunction(ply, tr, className)
  if not tr.Hit then return nil end
  local ent = ents.Create(className)
  if not IsValid(ent) then return nil end
  ent:SetPos(tr.HitPos + tr.HitNormal * 16)
  ent:SetAngles(Angle(0, ply:EyeAngles().y + 180, 0))
  ent:Spawn()
  ent:Activate()
  return ent
end

---@return nil
function ENT:Initialize()
  if self:CreatedByMap() then
    MsgN("[WARNING] [sc_breakable] sc_breakable is designed for direct GLua creation. Use func_breakable when the map can be recompiled.")
  end
  self.BreakableMaterial = self.BreakableMaterial or 1
  self.Enabled = not self.StartDisabled
  self.ExplodeDamage = self.ExplodeDamage or 0
  self.ExplodeMagnitude = self.ExplodeMagnitude or 0
  self.ExplodeRadius = self.ExplodeRadius or 0
  self.Explosion = self.Explosion or EXPLOSION_RANDOM
  self.GibDir = self.GibDir or ZERO_ANGLE
  self.HealthValue = self.HealthValue or 1
  self.MaxHealthValue = math.max(self.HealthValue, 1)
  self.MinHealthDamage = self.MinHealthDamage or 0
  self.NoDamageForces = self.NoDamageForces or false
  self.PerformanceMode = self.PerformanceMode or 0
  self.PhysDamageScale = self.PhysDamageScale or 1
  self.PressureDelay = self.PressureDelay or 0
  self.SpawnFlags = self.SpawnFlags or self:GetSpawnFlags()
  self.SpawnObject = self.SpawnObject or 0
  self.StartDisabled = self.StartDisabled or false
  self.UseMaxs = self.UseMaxs or DEFAULT_MAXS
  self.UseMins = self.UseMins or DEFAULT_MINS
  self._break_pending = false
  self._broken = false
  self:SetNoDraw(true)
  self:SCApplyEnabled()
end

---@param key string
---@param value string
---@return nil
function ENT:SCApplyKeyValue(key, value)
  local lkey = key:lower()
  if lkey == "angles" then
    self:SetAngles(AngleFromString(value))
  elseif lkey == "explodedamage" then
    self.ExplodeDamage = tonumber(value) or self.ExplodeDamage
  elseif lkey == "explodemagnitude" then
    self.ExplodeMagnitude = tonumber(value) or self.ExplodeMagnitude
  elseif lkey == "exploderadius" then
    self.ExplodeRadius = tonumber(value) or self.ExplodeRadius
  elseif lkey == "explosion" then
    self.Explosion = tonumber(value) or self.Explosion
  elseif lkey == "gibdir" then
    self.GibDir = AngleFromString(value)
  elseif lkey == "gibmodel" then
    self.GibModel = value
  elseif lkey == "health" then
    self.HealthValue = tonumber(value) or self.HealthValue
  elseif lkey == "material" then
    self.BreakableMaterial = tonumber(value) or self.BreakableMaterial
  elseif lkey == "maxs" then
    self.UseMaxs = VectorFromString(value, DEFAULT_MAXS)
  elseif lkey == "minhealthdmg" then
    self.MinHealthDamage = tonumber(value) or self.MinHealthDamage
  elseif lkey == "mins" then
    self.UseMins = VectorFromString(value, DEFAULT_MINS)
  elseif lkey == "nodamageforces" then
    self.NoDamageForces = BooleanFromString(value)
  elseif lkey == "origin" then
    self:SetPos(VectorFromString(value, ZERO_VECTOR))
  elseif lkey == "performancemode" then
    self.PerformanceMode = tonumber(value) or self.PerformanceMode
  elseif lkey == "physdamagescale" then
    self.PhysDamageScale = tonumber(value) or self.PhysDamageScale
  elseif lkey == "pressuredelay" then
    self.PressureDelay = tonumber(value) or self.PressureDelay
  elseif lkey == "spawnflags" then
    self.SpawnFlags = tonumber(value) or 0
  elseif lkey == "spawnobject" then
    self.SpawnObject = tonumber(value) or self.SpawnObject
  elseif lkey == "startdisabled" then
    self.StartDisabled = BooleanFromString(value)
  elseif lkey == "targetname" then
    self:SetName(value)
  end
end

---@return nil
function ENT:SCApplyDisabled()
  self.Enabled = false
  self:SetSolid(SOLID_NONE)
  self:SetMoveType(MOVETYPE_NONE)
  self:AddSolidFlags(FSOLID_NOT_SOLID)
end

---@return nil
function ENT:SCApplyEnabled()
  if not self.Enabled then
    self:SCApplyDisabled()
    return
  end
  self.Enabled = true
  self:RemoveSolidFlags(FSOLID_NOT_SOLID)
  self:SetMoveType(MOVETYPE_NONE)
  if self:PhysicsInitBox(self.UseMins, self.UseMaxs) then
    self:SetSolid(SOLID_VPHYSICS)
  else
    self:SetSolid(SOLID_OBB)
    self:SetCollisionBounds(self.UseMins, self.UseMaxs)
  end
  local phys = self:GetPhysicsObject()
  if IsValid(phys) then
    phys:EnableMotion(false)
    phys:Sleep()
  end
end

---@return nil
function ENT:SCBreakEffect()
  if self.PerformanceMode == PM_NO_GIBS then return end
  local effectName = MATERIAL_EFFECTS[self.BreakableMaterial] or "cball_bounce"
  local effect = EffectData()
  effect:SetMagnitude(self.PerformanceMode == PM_REDUCED_GIBS and 1 or 2)
  effect:SetNormal(self:SCGetGibDirection())
  effect:SetOrigin(self:WorldSpaceCenter())
  effect:SetScale(1)
  util.Effect(effectName, effect, true, true)
end

---@param activator Entity|nil
---@return nil
function ENT:SCBreakExplode(activator)
  local damage = self.ExplodeDamage
  if damage <= 0 then damage = self.ExplodeMagnitude end
  if damage <= 0 then return end
  local radius = self.ExplodeRadius
  if radius <= 0 then radius = damage * 2.5 end
  util.BlastDamage(self, activator or self, self:WorldSpaceCenter(), radius, damage)
  local effect = EffectData()
  effect:SetMagnitude(damage)
  effect:SetOrigin(self:WorldSpaceCenter())
  effect:SetRadius(radius)
  util.Effect("Explosion", effect, true, true)
end

---@return nil
function ENT:SCBreakSpawnObject()
  local className = SPAWN_OBJECTS[self.SpawnObject]
  if not isstring(className) then return end
  ---@cast className string
  local ent = ents.Create(className)
  if not IsValid(ent) then return end
  ent:SetAngles(self:GetAngles())
  ent:SetPos(self:WorldSpaceCenter())
  ent:Spawn()
  ent:Activate()
end

---@param amount number
---@param activator Entity|nil
---@return nil
function ENT:SCChangeHealth(amount, activator)
  if self._broken then return end
  self.HealthValue = amount
  self:TriggerOutput("OnHealthChanged", activator or self, tostring(math.Clamp(self.HealthValue / self.MaxHealthValue, 0, 1)))
  if self.HealthValue <= 0 then self:SCDoBreak(activator) end
end

---@param activator Entity|nil
---@return nil
function ENT:SCDoBreak(activator)
  if self._broken or self.BreakableMaterial == MATERIAL_UNBREAKABLE_GLASS then return end
  self._broken = true
  self:SCEmitBreakSound()
  self:SCBreakEffect()
  self:SetName("")
  self:TriggerOutput("OnBreak", activator or self)
  self:SCBreakSpawnObject()
  self:SCBreakExplode(activator)
  self:Remove()
end

---@return nil
function ENT:SCEmitBreakSound()
  local soundName = MATERIAL_BREAK_SOUNDS[self.BreakableMaterial]
  if isstring(soundName) then self:EmitSound(soundName, 75, math.random(95, 124)) end
end

---@return nil
function ENT:SCEmitHitSound()
  local soundName = MATERIAL_HIT_SOUNDS[self.BreakableMaterial]
  if isstring(soundName) then self:EmitSound(soundName, 75, math.random(95, 129)) end
end

---@return Vector
function ENT:SCGetGibDirection()
  if self.Explosion == EXPLOSION_PRECISE then
    return self.GibDir:Forward()
  elseif self.Explosion == EXPLOSION_DIRECTED then
    return -self:GetForward()
  end
  return VectorRand()
end

---@param flag integer
---@return boolean
function ENT:SCHasSpawnFlag(flag)
  return bit.band(self.SpawnFlags or self:GetSpawnFlags(), flag) ~= 0
end

---@param activator Entity|nil
---@param delay number
---@return nil
function ENT:SCScheduleBreak(activator, delay)
  if self._break_pending then return end
  self._break_pending = true
  timer.Simple(math.max(delay, 0), function()
    if not IsValid(self) then return end
    self._break_pending = false
    self:SCDoBreak(activator)
  end)
end

---@param damageInfo CTakeDamageInfo
---@return nil
function ENT:OnTakeDamage(damageInfo)
  if not self.Enabled or self._broken then return end
  if self:SCHasSpawnFlag(SF_BREAK_TRIGGER_ONLY) then return end
  if self.HealthValue <= 0 then return end
  if self.BreakableMaterial == MATERIAL_UNBREAKABLE_GLASS then
    self:SCEmitHitSound()
    return
  end
  local damage = damageInfo:GetDamage() * self.PhysDamageScale
  if self.MinHealthDamage > 0 and damage < self.MinHealthDamage then return end
  self:SCEmitHitSound()
  self:TriggerOutput("OnTakeDamage", damageInfo:GetAttacker())
  if self:SCHasSpawnFlag(SF_BREAK_PHYSICS) and bit.band(damageInfo:GetDamageType(), DMG_CRUSH) ~= 0 then
    self:SCDoBreak(damageInfo:GetAttacker())
    return
  elseif self:SCHasSpawnFlag(SF_NO_PHYSICS_DAMAGE) and bit.band(damageInfo:GetDamageType(), DMG_CRUSH) ~= 0 then
    return
  end
  self:SCChangeHealth(self.HealthValue - damage, damageInfo:GetAttacker())
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputAddHealth(activator, caller, data)
  self:SCChangeHealth(self.HealthValue + (tonumber(data) or 0), activator)
end

---@param activator Entity
---@return nil
function ENT:InputBreak(activator)
  self:SCDoBreak(activator)
end

---@return nil
function ENT:InputDisable()
  self:SCApplyDisabled()
end

---@return nil
function ENT:InputDisableDamageForces()
  self.NoDamageForces = true
end

---@return nil
function ENT:InputDisablePhyscannonPickup()
end

---@return nil
function ENT:InputEnable()
  self.Enabled = true
  self:SCApplyEnabled()
end

---@return nil
function ENT:InputEnableDamageForces()
  self.NoDamageForces = false
end

---@return nil
function ENT:InputEnablePhyscannonPickup()
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputRemoveHealth(activator, caller, data)
  self:SCChangeHealth(self.HealthValue - (tonumber(data) or 0), activator)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetHealth(activator, caller, data)
  self:SCChangeHealth(tonumber(data) or self.HealthValue, activator)
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputSetMass(activator, caller, data)
  local phys = self:GetPhysicsObject()
  if IsValid(phys) then phys:SetMass(math.max(tonumber(data) or 1, 1)) end
end

---@return nil
function ENT:InputToggle()
  if self.Enabled then
    self:SCApplyDisabled()
  else
    self:InputEnable()
  end
end

---@param ent Entity
---@return nil
function ENT:Touch(ent)
  if not self.Enabled or self._broken then return end
  if self:SCHasSpawnFlag(SF_BREAK_TRIGGER_ONLY) then return end
  if self:SCHasSpawnFlag(SF_BREAK_TOUCH) and IsValid(ent) and ent:IsPlayer() then
    local damage = ent:GetVelocity():Length() * 0.01
    if damage >= self.HealthValue then self:SCChangeHealth(self.HealthValue - damage, ent) end
  end
  if self:SCHasSpawnFlag(SF_BREAK_PRESSURE) and IsValid(ent) and ent:IsPlayer() and ent:GetGroundEntity() == self then
    self:SCEmitHitSound()
    self:SCScheduleBreak(ent, self.PressureDelay)
  end
end
