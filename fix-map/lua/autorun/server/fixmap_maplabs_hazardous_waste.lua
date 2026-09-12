--[[
Mod: Map Labs: Hazardous Waste
Map:
- acid_exchange
- drain_grain
- inner_city_17_metro_wastework_channel
]]
hook.Add("PlayerSpawn", "FixMap_ML_HW_PlayerSpawn", function(ply, _)
  if SERVER then
    local m = game.GetMap()
    if m == "acid_exchange" then
      ply:SetPos(Vector(-331, -1925, 84))
      ply:SetEyeAngles(Angle(0, 90, 0))
    elseif m == "booger_monster" then
      ply:SetPos(Vector(-4548, 4082, 3072))
      ply:SetEyeAngles(Angle(0, 0, 0))
    elseif m == "drain_grain" then
      ply:SetPos(Vector(224, -288, 4))
      ply:SetEyeAngles(Angle(0, 45, 0))
    elseif m == "inner_city_17_metro_wastework_channel" then
      ply:SetPos(Vector(-10080, 12448, 256))
      ply:SetEyeAngles(Angle(0, 0, 0))
    end
  end
end)
