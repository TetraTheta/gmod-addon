require("sctools")
local b_band = bit.band
local e_Iterator = ents.Iterator
local s_StartsWith = string.StartsWith
--
local cv = GetConVar("sc_disable_obstacle")

---@param ent Entity
---@return boolean
local function _ShouldDisableObstacle(ent)
  if not IsValid(ent:GetPhysicsObject()) then return false end

  local class = ent:GetClass()
  if class == "gibs" or class == "prop_ragdoll" then return true end
  if class ~= "prop_physics" then return false end
  if b_band(ent:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 then return true end

  local model = ent:GetModel()
  if not isstring(model) then return false end
  ---@cast model string
  if sctools._SmallModel[model] then return true end
  for dir, _ in pairs(sctools._SmallModelDir) do
    ---@cast dir string
    if s_StartsWith(model, dir) then return true end
  end

  return false
end

---@param ent Entity
local function _ApplyCollision(ent)
  if not cv:GetBool() or not IsValid(ent) then return end
  if _ShouldDisableObstacle(ent) then
    ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
  end
end

local function _ApplyAllCollisions()
  for _, ent in e_Iterator() do
    _ApplyCollision(ent)
  end
end

hook.Add("InitPostEntity", "SCTOOLS_DisableObstacle_Init", _ApplyAllCollisions)
hook.Add("OnEntityCreated", "SCTOOLS_DisableObstacle_Create", function(ent)
  if not cv:GetBool() then return end
  timer.Simple(0, function()
    if IsValid(ent) then _ApplyCollision(ent) end
  end)
end)

cvars.AddChangeCallback("sc_disable_obstacle", function(_, _, new)
  if tobool(new) then _ApplyAllCollisions() end
end, "SCTOOLS_DisableObstacle")
