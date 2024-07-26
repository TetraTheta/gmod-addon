--[[
  ConVars:
  * sc_no_obstacle <0|1> - Disable collision check for obstacle objects
--]]
timer.Create("SCNoObstacle", 0.1, 0, function()
  local cv = GetConVar("sc_no_obstacle"):GetBool()
  if cv then
    for _, e in ipairs(ents.GetAll()) do
      if e:GetClass() == "prop_physics" then
        if bit.band(e:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 or SC_SMALL_MODELS[e:GetModel()] then
          e:SetCollisionGroup(COLLISION_GROUP_WORLD)
        else
          for d, _ in pairs(SC_SMALL_MODELS_DIRS) do
            if string.StartsWith(e:GetModel(), d) then e:SetCollisionGroup(COLLISION_GROUP_WORLD) end
          end
        end
      elseif e:GetClass() == "gibs" then
        e:SetCollisionGroup(COLLISION_GROUP_WORLD)
      elseif e:GetClass() == "prop_ragdoll" then
        e:SetCollisionGroup(COLLISION_GROUP_WORLD)
      end
    end
  end
end)
