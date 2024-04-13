hook.Add("PlayerSpawn", "FixMap_TFJ_interlopers_jimonions", function(ply, _)
  if SERVER and (game.GetMap() == "interlopers_jimonions") then
    ply:SetPos(Vector(-320, -1264, -8176))
    ply:SetEyeAngles(Angle(0, 90, 0))
  end
end)
