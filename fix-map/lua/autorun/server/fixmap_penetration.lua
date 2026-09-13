--[[
Mod: Penetration
Map:
- penetration05
]]

hook.Add("InitPostEntity", "FixMap_Penetration_InitPostEntity", function()
  if not SERVER then return end
  if game.GetMap() == "penetration05" then
    local tm = ents.FindByName("template_gunship01")[1]
    tm:Input("AddOutput", tm, nil, "OnSpawnNPC gunship01,SetTrack,gunship01_path3,0,1")
  end
end)
