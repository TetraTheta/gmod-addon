--[[
Mod: Precursor
Map:
- r_map7
]]
hook.Add("InitPostEntity", "FixMap_Precursor_InitPostEntity", function()
  if SERVER and game.GetMap() == "r_map7" then
    local tm = ents.FindByName("hunter_boss")[1]
    tm:Input("AddOutput", tm, nil, "OnDeath hunter_retreat_relay,Trigger,,0,1")
  end
end)
