--[[
Mod: Intrusion
Map:
- ol_11
]]

hook.Add("PlayerSpawn", "FixMap_Intrusion_PlayerSpawn", function(ply, _)
  if game.GetMap() == "ol_11" then
    ply:SetPos(Vector(-600, 496, 1.7))
    ply:SetEyeAngles(Angle(0, 232, 0))
  end
end)
