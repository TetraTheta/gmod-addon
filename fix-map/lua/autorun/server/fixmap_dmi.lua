hook.Add("InitPostEntity", "FixMap_DMI_deadman_island_IPE", function()
  local k1 = ents.FindByName("blackout")[1]
  local k2 = ents.FindByName("startcam")[2]
  if IsValid(k1) then k1:Remove() end
  if IsValid(k2) then k2:Remove() end
end)

hook.Add("PlayerSpawn", "FixMap_DMI_deadman_island_PS", function(ply, _)
  if SERVER and (game.GetMap() == "deadman_island") then
    ply:SetPos(Vector(-7680, 9024, -48))
    ply:SetEyeAngles(Angle(0, 270, 0))
  end
end)
