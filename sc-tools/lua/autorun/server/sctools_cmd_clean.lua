require("sctools")
local b_band = bit.band
local e_GetAll = ents.GetAll
local IsSuperAdmin = sctools.IsSuperAdmin
local Iterator = ents.Iterator
local p_GetHumans = player.GetHumans
local RemoveEntity = sctools.RemoveEntity
local s_lower = string.lower
local s_StartsWith = string.StartsWith
local s_Trim = string.Trim
local SendMessage = sctools.SendMessage
local SM = sctools._SmallModel
local SMD = sctools._SmallModelDir
local t_insert = table.insert
local u_Compress = util.Compress
local u_TableToJSON = util.TableToJSON
--
util.AddNetworkString("SCTOOLS_CleanResult")
--
---@return integer
local function CleanAmmo()
  local target = {
    item_ammo_357 = true,
    item_ammo_357_large = true,
    item_ammo_ar2 = true,
    item_ammo_ar2_altfire = true,
    item_ammo_ar2_large = true,
    item_ammo_crossbow = true,
    item_ammo_pistol = true,
    item_ammo_pistol_large = true,
    item_ammo_smg1 = true,
    item_ammo_smg1_grenade = true,
    item_ammo_smg1_large = true,
    item_box_buckshot = true,
    item_rpg_round = true
  }

  local result = 0
  for _, v in ipairs(e_GetAll()) do
    if IsValid(v) and IsValid(v:GetPhysicsObject()) then
      local c = v:GetClass()
      if target[c] then
        RemoveEntity(v)
        result = result + 1
      end
    end
  end
  return result
end

---@return integer
local function CleanDebris()
  local result = 0
  for _, v in ipairs(e_GetAll()) do
    if IsValid(v) and v:GetClass() == "prop_physics" and IsValid(v:GetPhysicsObject()) and b_band(v:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 then
      RemoveEntity(v)
      result = result + 1
    end
  end
  return result
end

local function CleanDecals()
  for _, v in ipairs(p_GetHumans()) do
    ---@cast v Player
    v:ConCommand("r_cleardecals")
  end
end

---@return integer
local function CleanGibs()
  local result = 0
  for _, v in ipairs(e_GetAll()) do
    if IsValid(v) and v:GetClass() == "gib" and IsValid(v:GetPhysicsObject()) then
      RemoveEntity(v)
      result = result + 1
    end
  end
  return result
end

---@return integer
local function CleanPowerups()
  local target = {
    item_battery = true,
    item_healthkit = true,
    item_healthvial = true
  }

  local result = 0
  for _, v in ipairs(e_GetAll()) do
    if IsValid(v) and IsValid(v:GetPhysicsObject()) then
      local c = v:GetClass()
      if target[c] then
        RemoveEntity(v)
        result = result + 1
      end
    end
  end
  return result
end

---@return integer
local function CleanRagdolls()
  local result = 0
  for _, v in ipairs(e_GetAll()) do
    if IsValid(v) and v:GetClass() == "prop_ragdoll" and IsValid(v:GetPhysicsObject()) and v:GetName() == "" then
      RemoveEntity(v)
      result = result + 1
    end
  end

  local max = GetConVar("g_ragdoll_maxcount"):GetInt()
  max = max > 0 and max or 32
  RunConsoleCommand("g_ragdoll_maxcount", "0")
  local function run(count)
    timer.Simple(1, function() RunConsoleCommand("g_ragdoll_maxcount", tostring(count)) end)
  end

  run(max)
  --
  return result
end

---@return integer
local function CleanSmall()
  local result = 0
  for _, v in ipairs(e_GetAll()) do
    if IsValid(v) and v:GetClass() == "prop_physics" and IsValid(v:GetPhysicsObject()) then
      if SM[v:GetModel()] then
        RemoveEntity(v)
        if not v.SCTOOLS_REMOVAL then result = result + 1 end
      else
        for d, _ in pairs(SMD) do
          if s_StartsWith(v:GetModel(), d) then
            RemoveEntity(v)
            if not v.SCTOOLS_REMOVAL then result = result + 1 end
          end
        end
      end
    end
  end
  return result
end

---@return integer
local function CleanWeapons()
  local target = {
    weapon_357 = true,
    weapon_ar2 = true,
    weapon_bugbait = true,
    weapon_crossbow = true,
    weapon_crowbar = true,
    weapon_frag = true,
    weapon_pistol = true,
    weapon_rpg = true,
    weapon_shotgun = true,
    weapon_slam = true,
    weapon_smg1 = true,
    weapon_stunstick = true
  }

  local result = 0
  for _, v in ipairs(e_GetAll()) do
    if IsValid(v) and IsValid(v:GetPhysicsObject()) then
      local c = v:GetClass()
      if target[c] and not v:CreatedByMap() then
        RemoveEntity(v)
        result = result + 1
      end
    end
  end
  return result
end

---@param ply Player
---@param args table
local function Clean(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  local arg = s_lower(args[1])
  local valid = {
    all = true,
    ammo = true,
    debris = true,
    decals = true,
    gibs = true,
    powerups = true,
    ragdolls = true,
    small = true,
    weapons = true
  }

  if not valid[arg] then
    SendMessage("[SC Clean] You must specify one of these arguments: all, ammo, debris, decals, gibs, powerups, ragdolls, small, weapons", ply)
    return
  end

  -- Parse argument
  local result = {}
  if arg == "all" or arg == "ammo" then
    local ammo = CleanAmmo()
    if ammo > 0 then result.ammo = ammo end
  end

  if arg == "all" or arg == "debris" then
    local debris = CleanDebris()
    if debris > 0 then result.debris = debris end
  end

  if arg == "all" or arg == "decals" then
    CleanDecals()
    result.decals = true
  end

  if arg == "all" or arg == "gibs" then
    local gibs = CleanGibs()
    if gibs > 0 then result.gibs = gibs end
  end

  if arg == "all" or arg == "powerups" then
    local powerups = CleanPowerups()
    if powerups > 0 then result.powerups = powerups end
  end

  if arg == "all" or arg == "ragdolls" then
    local ragdolls = CleanRagdolls()
    if ragdolls > 0 then result.ragdolls = ragdolls end
  end

  if arg == "all" or arg == "small" then
    local small = CleanSmall()
    if small > 0 then result.small = small end
  end

  if arg == "all" or arg == "weapons" then
    local weapons = CleanWeapons()
    if weapons > 0 then result.weapons = weapons end
  end

  local comp = u_Compress(u_TableToJSON(result))
  net.Start("SCTOOLS_CleanResult")
  net.WriteUInt(#comp, 16)
  net.WriteData(comp)
  net.Send(ply)
end

--
---@param args string
---@return table
local function CleanAutoComplete(_, args)
  local arg = s_Trim(args:lower())
  local tbl = {}
  if s_StartsWith(arg, "a") then
    t_insert(tbl, "sc_clean all")
    t_insert(tbl, "sc_clean ammo")
  elseif s_StartsWith(arg, "d") then
    t_insert(tbl, "sc_clean debris")
    t_insert(tbl, "sc_clean decals")
  elseif s_StartsWith(arg, "g") then
    t_insert(tbl, "sc_clean gibs")
  elseif s_StartsWith(arg, "p") then
    t_insert(tbl, "sc_clean powerups")
  elseif s_StartsWith(arg, "r") then
    t_insert(tbl, "sc_clean ragdolls")
  elseif s_StartsWith(arg, "s") then
    t_insert(tbl, "sc_clean small")
  elseif s_StartsWith(arg, "w") then
    t_insert(tbl, "sc_clean weapons")
  else
    t_insert(tbl, "sc_clean all")
    t_insert(tbl, "sc_clean ammo")
    t_insert(tbl, "sc_clean debris")
    t_insert(tbl, "sc_clean decals")
    t_insert(tbl, "sc_clean gibs")
    t_insert(tbl, "sc_clean powerups")
    t_insert(tbl, "sc_clean ragdolls")
    t_insert(tbl, "sc_clean small")
    t_insert(tbl, "sc_clean weapons")
  end
  return tbl
end

concommand.Add("sc_clean", Clean, CleanAutoComplete, "Remove objects from the current map.", FCVAR_NONE)
