util.AddNetworkString("FixMap_RavenholmNCZ")
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
  return nil
end

hook.Add("InitPostEntity", "FixMap_RavenholmNCZ_IO", function()
  local m = game.GetMap()
  if SERVER then
    if m == "ravenholm10" then
      local lr = ents.Create("lua_run")
      lr:SetName("luarun")
      lr:SetPos(Vector(2130, -660, -540))
      lr:Spawn()
      lr:Activate()
      -- First message button
      local b1 = FindByClassAndOrigin("func_button", Vector(1978, -740, -525))
      if b1 ~= nil then ---@cast b1 Entity
        print("Processing first message button")
        b1:ClearAllOutputs()
        b1:Input("AddOutput", b1, nil, "OnPressed luarun,RunPassedCode,net.Start('FixMap_RavenholmNCZ') net.WriteString('Message') net.WriteString('ravenholm_papv_01') net.Send(ACTIVATOR),0,1")
      end

      -- Second message button
      local b2 = FindByClassAndOrigin("func_button", Vector(2163.97, -625.74, -525))
      if b2 ~= nil then ---@cast b2 Entity
        print("Processing second message button")
        b2:ClearAllOutputs()
        b2:Input("AddOutput", b2, nil, "OnPressed luarun,RunPassedCode,net.Start('FixMap_RavenholmNCZ') net.WriteString('Message') net.WriteString('ravenholm_papv_02') net.Send(ACTIVATOR),0,1")
      end

      -- Third message button
      local b3 = FindByClassAndOrigin("func_button", Vector(2419.54, -846.57, -517))
      if b3 ~= nil then ---@cast b3 Entity
        print("Processing third message button")
        b3:ClearAllOutputs()
        b3:Input("AddOutput", b3, nil, "OnPressed luarun,RunPassedCode,net.Start('FixMap_RavenholmNCZ') net.WriteString('Message') net.WriteString('ravenholm_papv_03') net.Send(ACTIVATOR),0,1")
        b3:Input("AddOutput", b3, nil, "OnPressed buttko,Kill,,0,1")
        b3:Input("AddOutput", b3, nil, "OnPressed buttok,Unlock,,0,1")
        b3:Input("AddOutput", b3, nil, "OnPressed amp,Kill,,5,1")
        b3:Input("AddOutput", b3, nil, "OnPressed pick,PlaySound,,5,1")
        b3:Input("AddOutput", b3, nil, "OnPressed xxxxxxt,Display,,5,1")
      end

      -- Fourth message button
      local b4 = FindByClassAndOrigin("func_button", Vector(2223.43, -625.54, -525))
      if b4 ~= nil then ---@cast b4 Entity
        print("Processing fourth message button")
        b4:ClearAllOutputs()
        b4:Input("AddOutput", b4, nil, "OnPressed luarun,RunPassedCode,net.Start('FixMap_RavenholmNCZ') net.WriteString('Message') net.WriteString('ravenholm_papv_04') net.Send(ACTIVATOR),0,1")
      end
    elseif m == "ravenholm15" then
      -- Kill viewcontrol triggers
      local lg = FindByClassAndOrigin("logic_relay", Vector(1676, 1580, -390.348), "traps")
      if lg ~= nil then ---@cast lg Entity
        lg:Remove()
      end
      local sc9 = FindByClassAndOrigin("logic_choreographed_scene", Vector(1241.04, 1421, -250.596), "sc9")
      if sc9 ~= nil then ---@cast sc9 Entity
        sc9:ClearAllOutputs()
        sc9:Input("AddOutput", sc9, nil, "OnCompletion aizustat,StartSchedule,,1,-1")
        sc9:Input("AddOutput", sc9, nil, "OnCompletion mpzus,Enable,,5,-1")
        sc9:Input("AddOutput", sc9, nil, "OnCompletion sc10,Start,,5,-1")
      end
    end
  end
end)
