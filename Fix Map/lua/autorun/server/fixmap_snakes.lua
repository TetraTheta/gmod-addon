local function CreateChangeLevel(curmap, nextmap, origin)
  for _, v in ipairs(ents.FindByClass("trigger_once")) do
    if v:GetPos() == origin then
      v:Input("AddOutput", v, nil, "OnStartTouch sc_changelevel_" .. curmap .. ",ChangeLevel,,0,1")
      print("Added new output to map changing trigger")
    end
  end

  local t = ents.Create("sc_changelevel")
  if t then
    t:SetName("sc_changelevel_" .. curmap)
    t:SetPos(origin)
    t:SetKeyValue("map", nextmap)
    t:Spawn()
    t:Activate()
  else
    print("Failed to create 'sc_changelevel'")
  end
end

hook.Add("InitPostEntity", "FixMap_Snakes_ChangeLevel", function()
  if SERVER then
    local cmap = game.GetMap()
    if cmap == "beta1f" then
      CreateChangeLevel("beta1f", "beta2f", Vector(1480, 449.5, -1158))
    elseif cmap == "beta2f" then
      CreateChangeLevel("beta2f", "beta3f", Vector(846, 2984.69, -510.09))
      local t = ents.FindByName("ftrigger")[1]
      if t ~= nil then
        t:Input("AddOutput", t, nil, "OnStartTouch lever,Unlock,,0,1")
      end
    elseif cmap == "beta3f" then
      CreateChangeLevel("beta3f", "beta4f", Vector(3587.27, 296.04, 255.09))
    elseif cmap == "beta4f" then
      CreateChangeLevel("beta4f", "beta5f", Vector(1372, 273, 888))
    elseif cmap == "beta5f" then
      CreateChangeLevel("beta5f", "beta6f", Vector(-397.5, 228, -604.5))
    end
  end
end)

hook.Add("PlayerSpawn", "FixMap_Snakes_beta6f", function(ply, _)
  if SERVER and (game.GetMap() == "beta6f") then
    ply:SetPos(Vector(3287, -1349.43, -50))
    ply:SetEyeAngles(Angle(0, 0, 0))
  end
end)
