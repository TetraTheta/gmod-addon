hook.Add("PlayerSpawn", "FixMap_RTBV_delayed_rtbv", function(ply, _)
  if SERVER and (game.GetMap() == "delayed_rtbv") then
    ply:SetPos(Vector(-6909, 13232, 11448))
    ply:SetEyeAngles(Angle(0, 175, 0))
  end
end)
