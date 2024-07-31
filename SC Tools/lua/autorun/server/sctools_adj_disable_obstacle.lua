require("sctools")
local b_band = bit.band
local Iterator = ents.Iterator
local SM = sctools._SmallModel
local SMD = sctools._SmallModelDir
--
local cg = COLLISION_GROUP_WORLD
timer.Create("SCTOOLS_DisableObstacle", 0.1, 0, function()
  if GetConVar("sc_disable_obstacle"):GetBool() then
    for _, e in Iterator() do
      ---@cast e Entity
      --if e.SCTOOLS_OBSTACLE or not IsValid(e:GetPhysicsObject()) then continue end ---@diagnostic disable-line: undefined-field
      if not IsValid(e:GetPhysicsObject()) then continue end ---@diagnostic disable-line: undefined-field
      local class = e:GetClass()
      local model = e:GetModel()
      if class == "prop_physics" then
        if b_band(e:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 or SM[model] then
          --e.SCTOOLS_OBSTACLE = true ---@diagnostic disable-line: inject-field
          e:SetCollisionGroup(cg)
        else
          for s, _ in pairs(SMD) do
            if model == s then
              --e.SCTOOLS_OBSTACLE = true ---@diagnostic disable-line: inject-field
              e:SetCollisionGroup(cg)
            end
          end
        end
      elseif class == "gibs" or class == "prop_ragdoll" then
        --e.SCTOOLS_OBSTACLE = true ---@diagnostic disable-line: inject-field
        e:SetCollisionGroup(cg)
      end
    end
  end
end)
