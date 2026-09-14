--[[
Mod: Map Labs #03: RunThinkShootLiveVille2
Map:
- ml03_cityescape2
]]

hook.Add("InitPostEntity", "FixMap_ML03_InitPostEntity", function()
  if not SERVER then return end
  local c = game.GetMap()
  if c == "ml03_cityescape2" then
    -- Create RPG Launcher (which is missing for some reason)
    local rpg = ents.Create("weapon_rpg")
    rpg:SetPos(Vector(6335, 10412, 284))
    rpg:SetAngles(Angle(0, 90, 270))
    rpg:Spawn()
    local flt = ents.Create("filter_activator_class")
    flt:SetName("filter_heli2_rpg")
    flt:SetKeyValue("filterclass", "rpg_missile")
    flt:Spawn()
    flt:Input("AddOutput", flt, nil, "OnPass mc_heli2,Add,1,0,-1")
    -- WIP: Reduce Combine Helicopter health
    -- NOTE: Find out why this method doesn't work
    local mc = ents.Create("math_counter")
    mc:SetName("mc_heli2")
    mc:SetPos(Vector(1800, 7744, 415))
    mc:SetKeyValue("max", "3")
    mc:Spawn()
    mc:Input("AddOutput", mc, nil, "OnHitMax heli2,SelfDestruct,,0,1")
  elseif c == "ml03_railway_industrial" then
    -- Create fallback button for Shotgun pickup
    local btn = ents.Create("prop_interactable")
    btn:SetPos(Vector(-7680, -2021, 100))
    btn:SetAngles(Angle(0, 180, 0))
    btn:SetKeyValue("spawnflags", "512") -- this is important for manually created prop_interactable!
    btn:SetModel("models/props_mining/freightelevatorbutton02.mdl")
    btn:SetKeyValue("DefaultAnim", "idleoff")
    btn:SetKeyValue("InSequence", "turn_ON")
    btn:SetKeyValue("PressedSound", "Buttons.snd10")
    btn:Spawn()
    btn:Input("AddOutput", btn, nil, "OnPressed train_platform,Close,,1,-1")
    btn:Input("AddOutput", btn, nil, "OnPressed malunfuction_sound,Kill,,0,-1")
    btn:Input("AddOutput", btn, nil, "OnPressed flick2,Kill,,0,-1")
    btn:Input("AddOutput", btn, nil, "OnPressed ayra_amb1,FadeOut,5,0,-1")
    btn:Input("AddOutput", btn, nil, "OnPressed this_is_diabolical_renegadist,PlaySound,,0,-1")
    btn:Input("AddOutput", btn, nil, "OnPressed yard_egg,Spawn,,0,-1")
    btn:Input("AddOutput", btn, nil, "OnPressed yard_egg,Enable,,0,-1")
    btn:Input("AddOutput", btn, nil, "OnPressed locked_yard_door1,Close,,0,-1")
    btn:Input("AddOutput", btn, nil, "OnPressed locked_yard_door1,Lock,,0,-1")
  end
end)

hook.Add("OnEntityCreated", "FixMap_ML03_OnEntityCreated", function(e)
  if not SERVER then return end
  if game.GetMap() ~= "ml03_cityescape2" then return end
  -- WIP: Reduce Combine Helicopter health
  -- NOTE: Find out why this method doesn't work
  timer.Simple(0, function()
    if not IsValid(e) or e:GetClass() ~= "npc_helicopter" or e:GetName() ~= "heli2" then return end
    e:Input("AddOutput", e, nil, "OnDamaged filter_heli2_rpg,TestActivator,,0,-1")
  end)
end)

hook.Add("PlayerSpawn", "FixMap_ML03_PlayerSpawn", function(ply, _)
  local c = game.GetMap()
  if c == "ml03_cityescape2" then
    -- Fix spawn point
    ply:SetPos(Vector(-9792, -15201, 264))
    ply:SetEyeAngles(Angle(0, 90, 0))
  end
end)
