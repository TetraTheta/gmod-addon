hook.Add("PlayerSpawn", "FixMap_C27_c27_industrial_01b_release", function(ply, _)
  if SERVER and (game.GetMap() == "c27_industrial_01b_release") then
    ply:SetPos(Vector(822, 839, -319))
    ply:SetEyeAngles(Angle(0, 0, 0))
  end
end)
