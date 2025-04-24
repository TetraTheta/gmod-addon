hook.Add("InitPostEntity", "FixMap_Penetration_penetration05", function()
  if SERVER and game.GetMap() == "penetration05" then
    local tm = ents.FindByName("template_gunship01")[1]
    tm:Input("AddOutput", tm, nil, "OnSpawnNPC gunship01,SetTrack,gunship01_path3,0,1")
  end
end)
