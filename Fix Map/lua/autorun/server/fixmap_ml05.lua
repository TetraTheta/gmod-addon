local function FindByClassAndOrigin(class, origin, name)
  local classes = ents.FindByClass(class)
  for _, v in ipairs(classes) do
    if v:GetPos() == origin then
      if name ~= nil then
        if v:GetName() == name then return v end
      else
        return v
      end
    end
  end
  return NULL
end

hook.Add("PlayerSpawn", "FixMap_ML05_ml05_bmi", function(ply, _)
  if SERVER and (game.GetMap() == "ml05_bmi") then
    ply:SetPos(Vector(128, 64, 91))
    ply:SetEyeAngles(Angle(0, 90, 0))
  end
end)

hook.Add("PlayerSpawn", "FixMap_ML05_ml05_grigoriswildride", function(ply, _)
  if SERVER and (game.GetMap() == "ml05_grigoriswildride") then
    ply:SetPos(Vector(-956, 592, 17))
    ply:SetEyeAngles(Angle(0, 0, 0))
  end
end)

hook.Add("PlayerSpawn", "FixMap_ML05_ml05_training_facilitea", function(ply, _)
  if SERVER and (game.GetMap() == "ml05_training_facilitea") then
    ply:SetPos(Vector(-256, 472, 80))
    ply:SetEyeAngles(Angle(0, 270, 0))
  end
end)

hook.Add("PlayerSpawn", "FixMap_ML05_ml05_wegothostiles", function(ply, _)
  if SERVER and (game.GetMap() == "ml05_wegothostiles") then
    ply:SetPos(Vector(-408, -384, 324))
    ply:SetEyeAngles(Angle(0, 180, 0))
  end
end)

hook.Add("InitPostEntity", "FixMap_ML05_ml05_werepullingout_IO", function()
  if SERVER and game.GetMap() == "ml05_werepullingout" then
    local to = FindByClassAndOrigin("trigger_once", Vector(-368, 2208, 475.81))
    if to ~= nil then ---@cast to Entity
      to:Input("AddOutput", to, nil, "OnTrigger FixMapCD01,SetAnimation,Open,7,1")
    end

    local cd = FindByClassAndOrigin("prop_dynamic", Vector(-468, 1912, 504))
    ---@cast cd Entity
    if cd ~= nil and cd:GetModel() == "models/props_combine/combine_door01.mdl" then
      cd:SetName("FixMapCD01")
      cd:SetKeyValue("HoldAnimation", "1")
    end
  end
end)

hook.Add("PlayerSpawn", "FixMap_ML05_ml05_werepullingout_PlayerSpawn", function(ply, _)
  if SERVER and (game.GetMap() == "ml05_werepullingout") then
    ply:SetPos(Vector(32, -280, 192))
    ply:SetEyeAngles(Angle(0, 315, 0))
  end
end)
