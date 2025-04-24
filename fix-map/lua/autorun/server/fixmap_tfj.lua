hook.Add("PlayerSpawn", "FixMap_TFJ_interlopers_jimonions", function(ply, _)
  if SERVER and (game.GetMap() == "interlopers_jimonions") then
    ply:SetPos(Vector(-320, -1264, -8176))
    ply:SetEyeAngles(Angle(0, 90, 0))
  end
end)

hook.Add("InitPostEntity", "FixMap_TFJ_overflow", function()
  if SERVER and game.GetMap() == "overflow" then
    local mathCounter = ents.FindByName("bridge_wave2_counter")[1]
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax apc01_bullseye,Break,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax apc01_driver,SetRelationship,!player D_HT 9999,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax apc01_bullseye,Kill,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax sniper_relay_zoomout,Trigger,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax combine_mine_counter,Enable,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax sniper_wall_break,Break,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax sniper_wall_break_snd,PlaySound,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax sniper_boards,Break,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax bridge01_playerclip,KillHierarchy,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax sniper_boards_front,Break,,11,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax sniper_tank,Deactivate,,11.01,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax sniper_tank,Kill,,11.1,1")
    mathCounter:Input("AddOutput", mathCounter, nil, "OnHitMax sniper_controlvolume,Kill,,11.1,1")
  end
end)
