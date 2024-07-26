--[[
  Commands:
  * sc_clean <all|ammo|debris|decal|gibs|powerups|ragdoll|small|weapon> - Remove objects from the current map.

  ConVars:
  * (Shared) sc_remove_effect <0|1> - Entity remove effect type. 0 = Remove, 1 = Dissolve.
--]]
require("sctools")
local IsSuperAdmin = sctools.IsSuperAdmin
local RemoveEffect = sctools.RemoveEffect
local SendMessage = sctools.SendMessage
--
util.AddNetworkString("SCCleanResult")
local function CleanAmmo()
  local clean = {
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
  for _, v in ipairs(ents.GetAll()) do
    if not IsValid(v:GetPhysicsObject()) then continue end
    local c = v:GetClass()
    if clean[c] then
      RemoveEffect(v)
      result = result + 1
    end
  end
  return result
end

local function CleanDebris()
  local result = 0
  for _, v in ipairs(ents.GetAll()) do
    if v:GetClass() == "prop_physics" and bit.band(v:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 then
      RemoveEffect(v)
      result = result + 1
    end
  end
  return result
end

local function CleanDecals()
  for _, v in ipairs(player.GetHumans()) do
    v:ConCommand("r_cleardecals")
  end
end

local function CleanGibs()
  local result = 0
  for _, v in ipairs(ents.GetAll()) do
    if v:GetClass() == "gib" then
      RemoveEffect(v)
      result = result + 1
    end
  end
  return result
end

local function CleanPowerups()
  local result = 0
  for _, v in ipairs(ents.GetAll()) do
    local c = v:GetClass()
    if c == "item_healthkit" or c == "item_healthvial" or c == "item_battery" then
      RemoveEffect(v)
      result = result + 1
    end
  end
  return result
end

local function CleanRagdoll()
  local result = 0
  -- Server-sided ragdoll
  for _, v in ipairs(ents.GetAll()) do
    if v:GetClass() == "prop_ragdoll" and v:GetName() == "" then
      RemoveEffect(v)
      result = result + 1
    end
  end

  -- ConVar
  local maxCountConVar = GetConVar("g_ragdoll_maxcount"):GetInt()
  local maxCount = (isnumber(maxCountConVar) and (maxCountConVar > 0)) and maxCountConVar or 32
  RunConsoleCommand("g_ragdoll_maxcount", "0")
  timer.Simple(1, function() RunConsoleCommand("g_ragdoll_maxcount", tostring(maxCount)) end)
  -- TODO: Client-sided ragdoll
  return result
end

local function CleanSmall()
  local result = 0
  for _, v in ipairs(ents.GetAll()) do
    if v:GetClass() == "prop_physics" then
      if SC_SMALL_MODELS[v:GetModel()] and v:GetName() == "" then
        RemoveEffect(v)
        result = result + 1
      end

      for d, _ in pairs(SC_SMALL_MODELS_DIRS) do
        if string.StartsWith(v:GetModel(), d) and v:GetName() == "" then
          RemoveEffect(v)
          result = result + 1
        end
      end
    end
  end
  return result
end

local function CleanWeapon()
  local clean = {
    grenade_ar2 = true,
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
  for _, v in ipairs(ents.GetAll()) do
    if not IsValid(v:GetPhysicsObject()) then continue end
    local c = v:GetClass()
    if clean[c] then
      RemoveEffect(v)
      result = result + 1
    end
  end
  return result
end

local function CleanAutoComplete(_, args)
  local astr = string.Trim(args:lower())
  local tbl = {}
  -- No argument
  if astr == nil or astr == "" then
    table.insert(tbl, "sc_clean all")
    table.insert(tbl, "sc_clean ammo")
    table.insert(tbl, "sc_clean debris")
    table.insert(tbl, "sc_clean decal")
    table.insert(tbl, "sc_clean gibs")
    table.insert(tbl, "sc_clean powerups")
    table.insert(tbl, "sc_clean ragdoll")
    table.insert(tbl, "sc_clean small")
    table.insert(tbl, "sc_clean weapon")
    return tbl
  end

  -- One argument
  if astr:StartsWith("a") then
    table.insert(tbl, "sc_clean all")
    table.insert(tbl, "sc_clean ammo")
  elseif string.StartsWith(astr, "d") then
    table.insert(tbl, "sc_clean debris")
    table.insert(tbl, "sc_clean decal")
  elseif string.StartsWith(astr, "g") then
    table.insert(tbl, "sc_clean gibs")
  elseif string.StartsWith(astr, "p") then
    table.insert(tbl, "sc_clean powerups")
  elseif string.StartsWith(astr, "r") then
    table.insert(tbl, "sc_clean ragdoll")
  elseif string.StartsWith(astr, "s") then
    table.insert(tbl, "sc_clean small")
  elseif string.StartsWith(astr, "w") then
    table.insert(tbl, "sc_clean weapon")
  else
    -- Wrong argument
    table.insert(tbl, "sc_clean all")
    table.insert(tbl, "sc_clean ammo")
    table.insert(tbl, "sc_clean debris")
    table.insert(tbl, "sc_clean decal")
    table.insert(tbl, "sc_clean gibs")
    table.insert(tbl, "sc_clean powerups")
    table.insert(tbl, "sc_clean ragdoll")
    table.insert(tbl, "sc_clean small")
    table.insert(tbl, "sc_clean weapon")
  end
  return tbl
end

local function Clean(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  -- Filter wrong arguments
  local arg = string.lower(args[1])
  local validArgs = {}
  validArgs["all"] = true
  validArgs["ammo"] = true
  validArgs["debris"] = true
  validArgs["decal"] = true
  validArgs["gibs"] = true
  validArgs["powerups"] = true
  validArgs["ragdoll"] = true
  validArgs["small"] = true
  validArgs["weapon"] = true
  if not validArgs[arg] then
    SendMessage("[SC Clean] You must specify one of these argument: all, ammo, debris, decal, gibs, powerups, ragdoll, small, weapon. Aborting...", ply, HUD_PRINTCONSOLE)
    return
  end

  -- Parse argument
  local resTable = {}
  if arg == "all" or arg == "ammo" then
    local resAmmo = CleanAmmo()
    if resAmmo > 0 then resTable.ammo = resAmmo end
  end

  if arg == "all" or arg == "debris" then
    local resDebris = CleanDebris()
    if resDebris > 0 then resTable.debris = resDebris end
  end

  if arg == "all" or arg == "decal" then
    CleanDecals()
    resTable.decal = true
  end

  if arg == "all" or arg == "gibs" then
    local resGibs = CleanGibs()
    if resGibs > 0 then resTable.gibs = resGibs end
  end

  if arg == "all" or arg == "powerups" then
    local resPowerups = CleanPowerups()
    if resPowerups > 0 then resTable.powerups = resPowerups end
  end

  if arg == "all" or arg == "ragdoll" then
    local resRagdoll = CleanRagdoll()
    if resRagdoll > 0 then resTable.ragdoll = resRagdoll end
  end

  if arg == "all" or arg == "small" then
    local resSmall = CleanSmall()
    if resSmall > 0 then resTable.small = resSmall end
  end

  if arg == "all" or arg == "weapon" then
    local resWeapon = CleanWeapon()
    if resWeapon > 0 then resTable.weapon = resWeapon end
  end

  -- Convert table to Compressed JSON
  local resJsonComp = util.Compress(util.TableToJSON(resTable))
  net.Start("SCCleanResult")
  net.WriteUInt(#resJsonComp, 16)
  net.WriteData(resJsonComp)
  net.Send(ply)
end

concommand.Add("sc_clean", Clean, CleanAutoComplete, "Remove objects from the current map.", FCVAR_NONE)
