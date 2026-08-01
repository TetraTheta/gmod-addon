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
  local loweredName = string.lower(name)
  for _, candidate in ipairs(player.GetAll()) do
    if string.lower(candidate:Nick()) == loweredName then return candidate end
  end

  for _, candidate in ipairs(player.GetAll()) do
    if string.find(string.lower(candidate:Nick()), loweredName, 1, true) ~= nil then
      return candidate
    end
  end

  return nil
end

---@param invoker Player|Entity|nil
---@param rawName string|nil
---@return Player|nil
local function ResolveTargetPlayer(invoker, rawName)
  local name = StripQuotes(rawName)
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
  return "\"" .. string.gsub(value, "\"", "\\\"") .. "\""
end

---@param value string
---@param prefix string|nil
---@return boolean
local function StartsWith(value, prefix)
  prefix = string.lower(StripQuotes(prefix))
  return prefix == "" or string.sub(string.lower(value), 1, #prefix) == prefix
end

---@param phrase string
---@return string
local function LocalizePhrase(phrase)
  if string.sub(phrase, 1, 1) == "#" and language ~= nil and language.GetPhrase ~= nil then
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

  for _, weaponData in ipairs(weapons.GetList()) do
    local class = weaponData.ClassName
    if type(class) == "string" and class ~= "" and not seen[class] then
      seen[class] = true
      classes[#classes + 1] = class
    end
  end

  table.sort(classes)
  return classes
end

---@param cmd string
---@param rawName string|nil
---@return string[]
local function CompletePlayers(cmd, rawName)
  local options = {}
  for _, ply in ipairs(player.GetAll()) do
    local name = ply:Nick()
    if StartsWith(name, rawName) then
      options[#options + 1] = cmd .. " " .. QuoteArgument(name)
    end
  end

  return options
end

---@param cmd string
---@param argStr string
---@param args string[]
---@return string[]
local function CompleteRemoveWeapon(cmd, argStr, args)
  local weaponClass = args[1]
  local rawName = string.match(argStr or "", "^%S+%s+(.+)$")

  if weaponClass ~= nil and string.match(argStr or "", "^%S+%s+") ~= nil then
    local options = {}
    for _, ply in ipairs(player.GetAll()) do
      local name = ply:Nick()
      if StartsWith(name, rawName) then
        options[#options + 1] = cmd .. " " .. weaponClass .. " " .. QuoteArgument(name)
      end
    end

    return options
  end

  local options = {}
  for _, class in ipairs(GetSortedWeaponClasses()) do
    if StartsWith(class, weaponClass) then
      options[#options + 1] = cmd .. " " .. class
    end
  end

  return options
end

---@param wpn Weapon
---@param ply Player
---@return string
local function FormatWeaponAmmo(wpn, ply)
  local ammoParts = {}
  local seen = {}

  for _, ammoType in ipairs({ wpn:GetPrimaryAmmoType(), wpn:GetSecondaryAmmoType() }) do
    if ammoType >= 0 and not seen[ammoType] then
      seen[ammoType] = true
      ammoParts[#ammoParts + 1] = string.format(
        "%s - %d",
        game.GetAmmoName(ammoType) or tostring(ammoType),
        ply:GetAmmoCount(ammoType)
      )
    end
  end

  if #ammoParts == 0 then return "no ammo" end
  return table.concat(ammoParts, ", ")
end

---@param ply Player
---@return Weapon[]
local function GetSortedPlayerWeapons(ply)
  local playerWeapons = {}
  for _, wpn in ipairs(ply:GetWeapons()) do
    if IsValid(wpn) then playerWeapons[#playerWeapons + 1] = wpn end
  end

  table.sort(playerWeapons, function(left, right)
    return left:GetClass() < right:GetClass()
  end)

  return playerWeapons
end

concommand.Add("get_weapons", function(ply, _, _, argStr)
  local target = ResolveTargetPlayer(ply, argStr)
  if target == nil then
    PrintCommandMessage(ply, TARGET_PLAYER_REQUIRED)
    return
  end

  for _, wpn in ipairs(GetSortedPlayerWeapons(target)) do
    PrintCommandMessage(
      ply,
      string.format("%s (%s): %s", wpn:GetClass(), LocalizePhrase(wpn:GetPrintName()), FormatWeaponAmmo(wpn, target))
    )
  end
end, CompletePlayers, "Show a player's weapons and ammo.", { FCVAR_NONE })

concommand.Add("remove_weapon", function(ply, _, args, argStr)
  local weaponClass = args[1]
  if weaponClass == nil or weaponClass == "" then return end

  local rawName = string.match(argStr or "", "^%S+%s+(.+)$")
  local target = ResolveTargetPlayer(ply, rawName)
  if target == nil then
    PrintCommandMessage(ply, TARGET_PLAYER_REQUIRED)
    return
  end

  if target:HasWeapon(weaponClass) then
    target:StripWeapon(weaponClass)
    PrintCommandMessage(ply, string.format("Removed %s from %s.", weaponClass, target:Nick()))
  else
    PrintCommandMessage(ply, string.format("%s does not have %s.", target:Nick(), weaponClass))
  end
end, CompleteRemoveWeapon, "Remove a weapon from a player.", { FCVAR_NONE })
