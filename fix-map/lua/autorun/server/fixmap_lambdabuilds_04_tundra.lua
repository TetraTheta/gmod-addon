--[[
Mod: LambdaBuilds #04: Tundra
Map:
- lb_c4_hiperborea
- lb_c4_hiperborea_2
]]

hook.Add("InitPostEntity", "FixMap_LB04_InitPostEntity", function()
  if not SERVER then return end
  local c = game.GetMap()
  if c == "lb_c4_hiperborea" then
    local cls = ents.FindByClass("trigger_changelevel")
    for _, v in ipairs(cls) do
      v:SetKeyValue("map", "lb_c4_hiperborea_2")
    end
  elseif c == "lb_c4_hiperborea_2" then
    local cls = ents.FindByClass("trigger_changelevel")
    for _, v in ipairs(cls) do
      local map = v:GetInternalVariable("map")
      if map == "lb_comp4_hiperborea" then
        v:SetKeyValue("map", "lb_c4_hiperborea")
      elseif map == "lb_comp4_hiperborea_3" then
        v:SetKeyValue("map", "lb_c4_hiperborea_3")
      end
    end
  elseif c == "lb_c4_hiperborea_3" then
    local cls = ents.FindByClass("trigger_changelevel")
    for _, v in ipairs(cls) do
      v:SetKeyValue("map", "lb_c4_hiperborea_2")
    end
  end
end)
