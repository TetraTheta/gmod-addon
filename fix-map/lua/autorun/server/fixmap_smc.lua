--[[
Mod: Single Map Collection
Map:
- a_brief_detour
- facility
- mining_complex
- precinct_17
- random_17
- so_much_for_freeman
]]
local curmap = game.GetMap()

---@param class string
---@param origin Vector
---@param name string|nil
---@return Entity
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
  local target = ""
  if name == nil then
    target = string.format("%s (%s, %s, %s)", class, origin.x, origin.y, origin.z)
  else
    target = string.format("%s (%s, %s, %s) [%s]", class, origin.x, origin.y, origin.z, name)
  end
  MsgC(Color(255, 0, 0), "ERROR: Could not find " .. target)
  return NULL
end

local function FindByClassAndName(class, name)
  local classes = ents.FindByClass(class)
  for _, v in ipairs(classes) do
    if name ~= nil then
      if v:GetName() == name then return v end
    else
      return v
    end
  end
  return NULL
end

hook.Add("InitPostEntity", "FixMap_SingleMapCollection_InitPostEntity", function()
  if SERVER then
    if curmap == "abandon" then
      --[[
      #############
      #  abandon  #
      #############
      ]]
      print("[Single Map Collection] DEV: Fixing (possibly) broken garage door...")
      local button = FindByClassAndName("func_button", "button_gate1")
      button:Input("AddOutput", button, nil, "OnPressed Gate1,Open,,30.0,-1")
    elseif curmap == "facility" then
      --[[
      ##############
      #  facility  #
      ##############
      ]]
      print("[Single Map Collection] DEV: Fixing weak explosion...")
      local exp = FindByClassAndName("env_physexplosion", "physexplosion_ambush")
      exp:SetKeyValue("magnitude", "1600")
      local logic = FindByClassAndName("logic_relay", "relay_ambush_group1")
      logic:Input("AddOutput", logic, nil, "OnTrigger door_combine_assault1,Kill,,1.9,-1")
    elseif curmap == "mining_complex" then
      --[[
      ####################
      #  mining_complex  #
      ####################
      ]]
      print("[Single Map Collection] DEV: Fixing text...")
      local text1 = FindByClassAndName("game_text", "sat_text_1")
      text1:SetKeyValue("message", "Earth, do you copy me?")
      local text2 = FindByClassAndName("game_text", "finale_dish_scene_text_3")
      text2:SetKeyValue("message", "Mars? Mars, do you copy me?")
    elseif curmap == "precinct_17" then
      --[[
      #################
      #  precinct_17  #
      #################
      ]]
      -- local base_breakable = ents.Create("sc_breakable")
      -- if IsValid(base_breakable) then
      --   base_breakable:SetPos(Vector(448, -256.5, -128))
      --   base_breakable:SetKeyValue("mins", "-128 -0.5 -64")
      --   base_breakable:SetKeyValue("maxs", "128 0.5 64")
      --   base_breakable:SetKeyValue("ExplodeDamage", "0")
      --   base_breakable:SetKeyValue("explodemagnitude", "0")
      --   base_breakable:SetKeyValue("ExplodeRadius", "0")
      --   base_breakable:SetKeyValue("explosion", "0")
      --   base_breakable:SetKeyValue("gibdir", "0 0 0")
      --   base_breakable:SetKeyValue("health", "1")
      --   base_breakable:SetKeyValue("material", "10")
      --   base_breakable:SetKeyValue("minhealthdmg", "0")
      --   base_breakable:SetKeyValue("nodamageforces", "0")
      --   base_breakable:SetKeyValue("PerformanceMode", "0")
      --   base_breakable:SetKeyValue("physdamagescale", "1.0")
      --   base_breakable:SetKeyValue("pressuredelay", "0")
      --   base_breakable:SetKeyValue("propdata", "0")
      --   base_breakable:SetKeyValue("spawnflags", "0")
      --   base_breakable:SetKeyValue("spawnobject", "0")
      --   base_breakable:SetKeyValue("StartDisabled", "1")
      --   base_breakable:SetKeyValue("targetname", "base_breakable")
      --   base_breakable:Spawn()
      --   base_breakable:Activate()
      --   --
      --   base_breakable:Input("AddOutput", base_breakable, nil, "OnBreak smrly2,Trigger,,0,1")
      -- end
      -- local relay = FindByClassAndName("logic_relay", "smrly1")
      -- relay:Input("AddOutput", relay, nil, "OnTrigger base_breakable,Enable,,0,1")
      --
      local crowbar = ents.Create("weapon_crowbar")
      crowbar:SetPos(Vector(517, -64, 396))
      crowbar:SetAngles(Angle(0, 90, 0))
      crowbar:Spawn()
      print("[Single Map Collection] DEV: Created weapon_crowbar")
      --
      local pistol_old = FindByClassAndOrigin("weapon_pistol", Vector(300, -460, -191))
      pistol_old:Remove()
      local pistol = ents.Create("weapon_pistol")
      pistol:SetPos(Vector(300, -460, -191))
      pistol:SetAngles(Angle(0, 140, 90))
      pistol:Spawn()
      pistol:Input("AddOutput", pistol, nil, "OnPlayerPickup z1rly,Trigger,,0,1")
      pistol:Input("AddOutput", pistol, nil, "OnPlayerPickup smct,Add,1,0,1")
      print("[Single Map Collection] DEV: Replaced weapon_pistol")
    elseif curmap == "random_17" then
      --[[
      ###############
      #  random_17  #
      ###############
      ]]
      print("[Single Map Collection] DEV: Fixing slow winch...")
      local train = FindByClassAndName("func_tracktrain", "winch_r_ds_pp")
      train:SetKeyValue("startspeed", "100")
      -- print("[Single Map Collection] Fixing sequence...")
      -- local drum = FindByClassAndName("prop_physics", "ug_exp")
      -- drum:Input("AddOutput", drum, nil, "OnBreak up_powerbox,SetAnimation,openPowerBox,0.5,-1")
      -- drum:Input("AddOutput", drum, nil, "OnBreak up_door,Unlock,,1.0,-1")
      -- drum:Input("AddOutput", drum, nil, "OnBreak up_sound,PlaySound,,1.0,-1")
      -- drum:Input("AddOutput", drum, nil, "OnBreak up_door,Open,,1.2,-1")
    elseif curmap == "so_much_for_freeman" then
      --[[
      #########################
      #  so_much_for_freeman  #
      #########################
      ]]
      print("[Single Map Collection] DEV: Fixing slow pod...")
      ents.FindByName("pathTrack_PlayerTrain_Path6")[1]:Fire("SetSpeed", "150")
      ents.FindByName("pathTrack_PlayerTrain_Path2")[1]:Fire("SetSpeed", "150")
      ents.FindByName("pathTrack_PlayerTrain_Path3")[1]:Fire("SetSpeed", "150")
      ents.FindByName("pathTrack_PlayerTrain_Path4")[1]:Fire("SetSpeed", "150")
      print("[Single Map Collection] Fixing sequence...")
      local sg1 = FindByClassAndOrigin("weapon_shotgun", Vector(5941.39, 4732.3, -207.627))
      local sg2 = FindByClassAndOrigin("weapon_shotgun", Vector(5940.39, 4741.3, -207.627))
      timer.Simple(0, function()
        if not IsValid(sg1) then return end
        sg1:SetKeyValue("spawnflags", 0)
        sg1:SetPos(Vector(5957, 4732, -207.627))
        sg1:PhysicsInit(SOLID_VPHYSICS)
        local sg1p = sg1:GetPhysicsObject()
        if IsValid(sg1p) then
          sg1p:EnableMotion(true)
          sg1p:Wake()
        end
        print("shotgun1 fixed")
      end)
      timer.Simple(0, function()
        if not IsValid(sg2) then return end
        sg2:SetKeyValue("spawnflags", 0)
        sg2:SetPos(Vector(5958, 4741, -207.627))
        sg2:PhysicsInit(SOLID_VPHYSICS)
        local sg2p = sg2:GetPhysicsObject()
        if IsValid(sg2p) then
          sg2p:EnableMotion(true)
          sg2p:Wake()
        end
        print("shotgun2 fixed")
      end)
      print("[Single Map Collection] DEV: Fixing Hammer I/O...")
      local airel1 = ents.GetMapCreatedEntity(10485)
      ---@cast airel1 Entity
      if IsValid(airel1) and airel1:GetClass() == "ai_relationship" then
        airel1:SetKeyValue("target", "!player")
        airel1:Fire("ApplyRelationship", "", 0)
      end
    end
  end
end)

hook.Add("PlayerSpawn", "FixMap_SingleMapCollection_PlayerSpawn", function(ply, _)
  if SERVER then
    if curmap == "a_brief_detour" then
      --[[
      ####################
      #  a_brief_detour  #
      ####################
      ]]
      ply:SetPos(Vector(-1000, 256, 160))
      ply:SetEyeAngles(Angle(0, 0, 0))
    end
  end
end)
