hook.Add("PlayerSpawn", "FixMap_ML02_ep1_eeh", function(ply, _)
  if SERVER and (game.GetMap() == "ep1_eeh") then
    ply:Give("item_suit", false)
    ply:Give("weapon_pistol", false)
    ply:Give("weapon_smg1", false)
    ply:Give("weapon_stunstick", false)
    ply:Give("weapon_physcannon", false)
  end
end)

hook.Add("PlayerSpawn", "FixMap_ML02_outland_resistance", function(ply, _)
  if SERVER and (game.GetMap() == "outland_resistance") then
    ply:SetPos(Vector(230, -770, -60))
    ply:SetEyeAngles(Angle(0, -180, 0))
  end
end)
