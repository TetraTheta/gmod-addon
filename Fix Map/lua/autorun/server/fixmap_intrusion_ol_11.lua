hook.Add("PlayerSpawn", "FixMap_Intrusion_ol_11", function(ply, _)
  if SERVER and (game.GetMap() == "ol_11") then
    ply:SetPos(Vector(-600, 496, 1.7))
    ply:SetEyeAngles(Angle(0, 232, 0))
  end
end)
