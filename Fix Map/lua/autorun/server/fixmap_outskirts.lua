hook.Add("PlayerSpawn", "FixMap_OUTSKIRTS_nuggie01", function(ply, _)
  if SERVER and (game.GetMap() == "nuggie01") then
    ply:SetPos(Vector(-6496, -413, 33))
    ply:SetEyeAngles(Angle(0, 90, 0))
  end
end)
