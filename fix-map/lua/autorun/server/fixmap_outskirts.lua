--[[
Mod: OUTSKIRTS
Map:
- nuggie01
]]

hook.Add("PlayerSpawn", "FixMap_OUTSKIRTS_PlayerSpawn", function(ply, _)
  if game.GetMap() == "nuggie01" then
    ply:SetPos(Vector(-6496, -413, 33))
    ply:SetEyeAngles(Angle(0, 90, 0))
  end
end)
