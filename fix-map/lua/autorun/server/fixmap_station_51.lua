--[[
Mod: Station 51
Map:
- station51_1
]]

hook.Add("PlayerSpawn", "FixMap_Station51_PlayerSpawn", function(ply, is_transition)
  if SERVER then
    local cm = game.GetMap()
    if cm == "station51_1" then
      -- set location
      ply:SetPos(Vector(-168, -40, 0))
      ply:SetEyeAngles(Angle(0, 0, 0))
    end
  end
end)
