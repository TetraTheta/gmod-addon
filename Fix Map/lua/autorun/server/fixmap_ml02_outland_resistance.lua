hook.Add("PlayerSpawn", "FixMap_ML02_outland_resistance", function(ply, _)
  if SERVER and (game.GetMap() == "outland_resistance") then
    ply:SetPos(Vector(230, -770, -60))
    ply:SetEyeAngles(Angle(0, -180, 0))
  end
end)
