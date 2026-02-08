require("sctools")
local b_band = bit.band
local e_Iterator = ents.Iterator
local SM = sctools._SmallModel
local SMD = sctools._SmallModelDir
--
local cv = GetConVar("sc_disable_obstacle")
--[[
#################
#     TIMER     #
#################
]]
--
timer.Create("SCTOOLS_DisableObstacle", 0.1, 0, function()
  if cv:GetBool() then
    for _, e in e_Iterator() do
      if not IsValid(e:GetPhysicsObject()) then continue end
      local class = e:GetClass()
      local model = e:GetModel()
      if class == "prop_physics" then
        if b_band(e:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 or SM[model] then
          e:SetCollisionGroup(COLLISION_GROUP_WORLD)
        else
          for s, _ in pairs(SMD) do
            if model == s then e:SetCollisionGroup(COLLISION_GROUP_WORLD) end
          end
        end
      elseif class == "gibs" or class == "prop_ragdoll" then
        e:SetCollisionGroup(COLLISION_GROUP_WORLD)
      end
    end
  end
end)
