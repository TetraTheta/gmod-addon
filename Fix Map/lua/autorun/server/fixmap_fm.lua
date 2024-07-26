hook.Add("PlayerSpawn", "FixMap_FM_fm_map9", function(ply, _)
  if SERVER and (game.GetMap() == "fm_map9") then
    ply:SetPos(Vector(16064, -16176, 227.5))
    ply:SetEyeAngles(Angle(0, 180, 0))
  end
end)
