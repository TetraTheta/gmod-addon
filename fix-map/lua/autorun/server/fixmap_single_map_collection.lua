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

hook.Add("InitPostEntity", "FixMap_SMC_InitPostEntity", function()
  if not SERVER then return end
  local c = game.GetMap()
  if c == "abandon" then
    --[[
      #############
      #  abandon  #
      #############
      ]]
    print("[Single Map Collection] DEV: Fixing (possibly) broken garage door...")
    local button = FindByClassAndName("func_button", "button_gate1")
    button:Input("AddOutput", button, nil, "OnPressed Gate1,Open,,30.0,-1")
  elseif c == "facility" then
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
  elseif c == "lab_ex" then
    --[[
      ############
      #  lab_ex  #
      ############
      ]]
    local trigs = ents.FindByClass("trigger_physics_trap")
    for _, t in ipairs(trigs) do
      if t:GetName() == "physicstrap_ball_killer" then
        timer.Simple(0.01, function() t:Remove() end)
      end
    end
  elseif c == "mining_complex" then
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
  elseif c == "precinct_17" then
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
  elseif c == "random_17" then
    --[[
      ###############
      #  random_17  #
      ###############
      ]]
    print("[Single Map Collection] DEV: Fixing slow winch...")
    local train = FindByClassAndName("func_tracktrain", "winch_r_ds_pp")
    train:SetKeyValue("startspeed", "100")
  end
end)

hook.Add("PlayerSpawn", "FixMap_SMC_PlayerSpawn", function(ply, _)
  if SERVER then
    if c == "a_brief_detour" then
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
