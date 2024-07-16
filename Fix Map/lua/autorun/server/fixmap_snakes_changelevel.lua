hook.Add("InitPostEntity", "FixMap_Snakes", function()
  if SERVER then
    local cmap = game.GetMap()
    if cmap == "beta1f" then
      -- change output
      for _, v in ipairs(ents.FindByClass("trigger_once")) do
        if v:GetPos() == Vector(1480,449.5,-1158) then
          v:Input("AddOutput", v, nil, "OnStartTouch sc_changelevel_" .. cmap .. ",ChangeLevel,,0,1")
          print("Got it")
        end
      end
      -- create entity
      local t = ents.Create("sc_changelevel")
      if t then
        t:SetName("sc_changelevel_" .. cmap)
        t:SetPos(Vector(1480, 449.5, -1158))
        t:SetKeyValue("map", "beta2f")
        t:Spawn()
        t:Activate()
      else
        print("Failed to create 'sc_changelevel'")
      end
    elseif cmap == "beta2f" then
    end
  end
end)
