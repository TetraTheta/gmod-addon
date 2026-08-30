-- Manage player's weapon via concommand
local TARGET_PLAYER_REQUIRED = "Target must be a player."
local BASE_WEAPON_CLASSES = {
  "gmod_camera",
  "gmod_tool",
  "weapon_357",
  "weapon_ar2",
  "weapon_bugbait",
  "weapon_crossbow",
  "weapon_crowbar",
  "weapon_frag",
  "weapon_physcannon",
  "weapon_physgun",
  "weapon_pistol",
  "weapon_rpg",
  "weapon_shotgun",
  "weapon_slam",
  "weapon_smg1",
  "weapon_stunstick",
}

---@param ply Player|Entity|nil
---@param msg string
local function PrintCommandMessage(ply, msg)
  if ply ~= nil and IsValid(ply) and ply:IsPlayer() then
    ---@cast ply Player
    ply:PrintMessage(HUD_PRINTCONSOLE, msg)
  else
    MsgN(msg)
  end
end

---@param raw string|nil
---@return string
local function StripQuotes(raw)
  raw = string.Trim(raw or "")
  if raw:len() >= 2 and raw:sub(1, 1) == '"' and raw:sub(-1) == '"' then
    return raw:sub(2, -2)
  end
  return raw
end

---@param name string
---@return Player|nil
local function FindPlayerByName(name)
  local lower = name:lower()
  -- exact match
  for _, candidate in ipairs(player.GetAll()) do
    if candidate:Nick():lower() == lower then return candidate end
  end
  -- partial match
  for _, candidate in ipairs(player.GetAll()) do
    if candidate:Nick():lower():find(lower, 1, true) ~= nil then
      return candidate
    end
  end
  return nil
end

---@param invoker Player|Entity|nil
---@param raw_name string|nil
---@return Player|nil
local function ResolveTargetPlayer(invoker, raw_name)
  local name = StripQuotes(raw_name)
  if name ~= "" then return FindPlayerByName(name) end
  if invoker ~= nil and IsValid(invoker) and invoker:IsPlayer() then
    ---@cast invoker Player
    return invoker
  end
  return nil
end

---@param value string
---@return string
local function QuoteArgument(value)
  return "\"" .. value:gsub("\"", "\\\"") .. "\""
end

---@param value string
---@param prefix string|nil
---@return boolean
local function StartsWith(value, prefix)
  prefix = StripQuotes(prefix):lower()
  return prefix == "" or value:lower():sub(1, #prefix) == prefix
end

---@param phrase string
---@return string
local function LocalizePhrase(phrase)
  if phrase:sub(1, 1) == "#" and language ~= nil and language.GetPhrase ~= nil then
    return language.GetPhrase(phrase)
  end
  return phrase
end

---@return string[]
local function GetSortedWeaponClasses()
  local classes = {}
  local seen = {}
  for _, class in ipairs(BASE_WEAPON_CLASSES) do
    seen[class] = true
    classes[#classes + 1] = class
  end
  for _, wep_data in ipairs(weapons.GetList()) do
    local class = wep_data.ClassName
    if type(class) == "string" and class ~= "" and not seen[class] then
      seen[class] = true
      classes[#classes + 1] = class
    end
  end
  table.sort(classes)
  return classes
end

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param cmd string
---@param raw_name string|nil
---@return string[]
local function CompletePlayers(cmd, raw_name)
  local options = {}
  for _, ply in ipairs(player.GetAll()) do
    local name = ply:Nick()
    if StartsWith(name, raw_name) then
      options[#options + 1] = cmd .. " " .. QuoteArgument(name)
    end
  end
  table.sort(options)
  return options
end

---@param cmd string
---@param arg_str string
---@param args string[]
---@return string[]
local function CompleteRemoveWeapon(cmd, arg_str, args)
  local wep_cls = args[1]
  local raw_name = string.match(arg_str or "", "^%S+%s+(.+)$")
  if wep_cls ~= nil and string.match(arg_str or "", "^%S+%s+") ~= nil then
    local opts = {}
    for _, ply in ipairs(player.GetAll()) do
      local name = ply:Nick()
      if StartsWith(name, raw_name) then
        opts[#opts + 1] = cmd .. " " .. wep_cls .. " " .. QuoteArgument(name)
      end
    end
    table.sort(opts)
    return opts
  end
  local opts = {}
  for _, class in ipairs(GetSortedWeaponClasses()) do
    if StartsWith(class, wep_cls) then
      opts[#opts + 1] = cmd .. " " .. class
    end
  end
  return opts
end

---@param wpn Weapon
---@param ply Player
---@return string
local function FormatWeaponAmmo(wpn, ply)
  local ammo_parts = {}
  local seen = {}
  for _, ammo_type in ipairs({ wpn:GetPrimaryAmmoType(), wpn:GetSecondaryAmmoType() }) do
    if ammo_type >= 0 and not seen[ammo_type] then
      seen[ammo_type] = true
      ammo_parts[#ammo_parts + 1] = string.format("%s(%d)", game.GetAmmoName(ammo_type) or tostring(ammo_type), ply:GetAmmoCount(ammo_type))
    end
  end
  if #ammo_parts == 0 then return "no ammo" end
  return table.concat(ammo_parts, ", ")
end

---@param ply Player
---@return Weapon[]
local function GetSortedPlayerWeapons(ply)
  local ply_weps = {}
  for _, wpn in ipairs(ply:GetWeapons()) do
    if IsValid(wpn) then ply_weps[#ply_weps + 1] = wpn end
  end
  table.sort(ply_weps, function(left, right) return left:GetClass() < right:GetClass() end)
  return ply_weps
end

--[[
#################
#    COMMAND    #
#################
]]

---@param ply Player|Entity|nil
---@param arg_str string
local function GetWeapons(ply, arg_str)
  local target = ResolveTargetPlayer(ply, arg_str)
  if target == nil then
    PrintCommandMessage(ply, TARGET_PLAYER_REQUIRED)
    return
  end
  for _, wpn in ipairs(GetSortedPlayerWeapons(target)) do
    PrintCommandMessage(ply, string.format("%s (%s): %s", wpn:GetClass(), LocalizePhrase(wpn:GetPrintName()), FormatWeaponAmmo(wpn, target)))
  end
end

---@param ply Player|Entity|nil
---@param args string[]
---@param arg_str string
local function RemoveWeapon(ply, args, arg_str)
  local wep_cls = args[1]
  if wep_cls == nil or wep_cls == "" then return end
  local raw_name = string.match(arg_str or "", "^%S+%s+(.+)$")
  local target = ResolveTargetPlayer(ply, raw_name)
  if target == nil then
    PrintCommandMessage(ply, TARGET_PLAYER_REQUIRED)
    return
  end
  if target:HasWeapon(wep_cls) then
    target:StripWeapon(wep_cls)
    PrintCommandMessage(ply, string.format("Removed %s from %s.", wep_cls, target:Nick()))
  else
    PrintCommandMessage(ply, string.format("%s does not have %s.", target:Nick(), wep_cls))
  end
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("get_weapons", function(ply, _, _, arg_str) GetWeapons(ply, arg_str) end, CompletePlayers, "Show a player's weapons and ammo.", { FCVAR_NONE })
concommand.Add("remove_weapon", function(ply, _, args, arg_str) RemoveWeapon(ply, args, arg_str) end, CompleteRemoveWeapon, "Remove a weapon from a player.", { FCVAR_NONE })
