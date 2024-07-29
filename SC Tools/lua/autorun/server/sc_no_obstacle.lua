--[[
  ConVars:
  * sc_no_obstacle <0|1> - Disable collision check for obstacle objects
--]]
local SM = sctools.SMALL_MODELS
local SMD = sctools.SMALL_MODELS_DIRS
local function SCG(ent)
  ---@cast ent Entity
  print("noobs - " .. ent:GetModel())
  ent.SCNoObstacle = true ---@diagnostic disable-line: inject-field
  timer.Simple(0, function() ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS) end)
end

timer.Create("SCNoObstacle", 0.1, 0, function()
  local cv = GetConVar("sc_no_obstacle"):GetBool()
  if cv then
    for _, e in ipairs(ents.GetAll()) do ---@cast e Entity
      if e.SCNoObstacle then continue end ---@diagnostic disable-line: undefined-field
      local class = e:GetClass()
      local pobj = e:GetPhysicsObject()
      local model = e:GetModel()
      if not IsValid(pobj) then continue end
      if class == "prop_physics" then
        if bit.band(e:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 or SM[model] then
          SCG(e)
        else
          for d, _ in pairs(SMD) do
            if model:StartsWith(d) then SCG(e) end
          end
        end
      elseif e:GetClass() == "gibs" then
        SCG(e)
      elseif e:GetClass() == "prop_ragdoll" then
        SCG(e)
      end
    end
  end
end)
