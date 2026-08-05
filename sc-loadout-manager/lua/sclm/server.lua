AddCSLuaFile("sclm/client.lua")

SCLM.Groups = SCLM.Groups or {}
SCLM.Users = SCLM.Users or {}

local find = string.find
local lower = string.lower
local sort = table.sort
local RefreshOwner

util.AddNetworkString(SCLM.NetRunAction)
util.AddNetworkString(SCLM.NetState)

---@return table
local function EmptyLoadout()
  return {
    enforce = false,
    primary = "",
    weapons = {}
  }
end

---@param class string
---@param primary number?
---@param secondary number?
---@return table
local function WeaponData(class, primary, secondary)
  return {
    class = class,
    primary = tonumber(primary) or -1,
    secondary = tonumber(secondary) or -1
  }
end

---@param loadout table?
---@return table
local function NormalizeLoadout(loadout)
  loadout = istable(loadout) and loadout or EmptyLoadout()
  loadout.enforce = SCLM.ToBool(loadout.enforce)
  loadout.primary = isstring(loadout.primary) and loadout.primary or ""
  loadout.weapons = istable(loadout.weapons) and loadout.weapons or {}

  for class, weapon in pairs(loadout.weapons) do
    if not isstring(class) or not istable(weapon) then
      loadout.weapons[class] = nil
    else
      weapon.class = class
      weapon.primary = tonumber(weapon.primary) or -1
      weapon.secondary = tonumber(weapon.secondary) or -1
    end
  end

  return loadout
end

---@param ply Player
---@param callback fun(allowed: boolean)
local function HasAccess(ply, callback)
  if not IsValid(ply) then
    callback(true)
    return
  end

  if ULib and ULib.ucl and ULib.ucl.query then
    local ok, allowed = pcall(ULib.ucl.query, ply, SCLM.AccessPrivilege)
    if ok then
      callback(allowed == true)
      return
    end
  end

  if CAMI and CAMI.PlayerHasAccess then
    CAMI.PlayerHasAccess(ply, SCLM.AccessPrivilege, function(allowed)
      if allowed ~= nil then
        callback(allowed == true)
        return
      end

      callback(game.SinglePlayer() or (ply.IsListenServerHost and ply:IsListenServerHost()) or ply:IsSuperAdmin())
    end)
    return
  end

  if game.SinglePlayer() or (ply.IsListenServerHost and ply:IsListenServerHost()) or ply:IsSuperAdmin() then
    callback(true)
    return
  end

  callback(ply:IsSuperAdmin())
end

---@param ply Player
---@return boolean
local function CanUsePersonalMenu(ply)
  return IsValid(ply)
end

---@param ply Player
---@param text string
local function Deny(ply, text)
  if IsValid(ply) then
    ply:ChatPrint(text)
  end
end

---@param ply Player
---@param callback fun()
local function WithAccess(ply, callback)
  HasAccess(ply, function(allowed)
    if not allowed then
      Deny(ply, "You do not have access to SC Loadout Manager.")
      return
    end

    callback()
  end)
end

---@param token string
---@return Player?
local function FindPlayer(token)
  if not isstring(token) or token == "" then return nil end

  local needle = lower(token)
  for _, ply in ipairs(player.GetAll()) do
    if ply:SteamID() == token or ply:SteamID64() == token or find(lower(ply:Nick()), needle, 1, true) then
      return ply
    end
  end

  return nil
end

---@return string[]
local function GroupNames()
  local names = { "admin", "superadmin", "user" }

  if CAMI and CAMI.GetUsergroups then
    for group, _ in pairs(CAMI.GetUsergroups()) do
      if not table.HasValue(names, group) then
        names[#names + 1] = group
      end
    end
  end

  sort(names)
  return names
end

---@return string[]
local function WeaponNames()
  local names = {}

  for class, _ in pairs(list.Get("Weapon")) do
    names[#names + 1] = class
  end

  sort(names)
  return names
end

---@param prefix string
---@param values string[]
---@return string[]
local function CompleteValues(prefix, values)
  local out = {}
  local needle = lower(prefix or "")

  for _, value in ipairs(values) do
    if needle == "" or find(lower(value), needle, 1, true) then
      out[#out + 1] = value
    end
  end

  return out
end

---@param cmd string
---@param args string
---@return string[]
local function CompleteGroupWeapon(cmd, args)
  local parts = string.Explode(" ", args:Trim())
  local values = #parts <= 1 and GroupNames() or WeaponNames()
  local prefix = parts[#parts] or ""
  local out = CompleteValues(prefix, values)

  for i, value in ipairs(out) do
    out[i] = cmd .. " " .. value
  end

  return out
end

---@param cmd string
---@param args string
---@return string[]
local function CompletePlayerWeapon(cmd, args)
  local parts = string.Explode(" ", args:Trim())
  local values = {}

  if #parts <= 1 then
    for _, ply in ipairs(player.GetAll()) do
      values[#values + 1] = ply:Nick()
    end
    sort(values)
  else
    values = WeaponNames()
  end

  local out = CompleteValues(parts[#parts] or "", values)
  for i, value in ipairs(out) do
    out[i] = cmd .. " " .. value
  end

  return out
end

---@param loadout table
---@return table
local function CopyLoadout(loadout)
  return util.JSONToTable(util.TableToJSON(loadout)) or EmptyLoadout()
end

---@param owner string?
---@param class string?
---@return boolean
local function HasOwnerAndClass(owner, class)
  return isstring(owner) and owner ~= "" and isstring(class) and class ~= ""
end

---@param group string
---@return table
function SCLM.GetGroupLoadout(group)
  SCLM.Groups[group] = NormalizeLoadout(SCLM.Groups[group])
  return SCLM.Groups[group]
end

---@param steamid string
---@return table
function SCLM.GetUserLoadout(steamid)
  SCLM.Users[steamid] = NormalizeLoadout(SCLM.Users[steamid])
  return SCLM.Users[steamid]
end

---@param ply Player
---@return table
function SCLM.GetEffectiveLoadout(ply)
  local group_loadout = SCLM.Groups[ply:GetUserGroup()] or EmptyLoadout()
  local loadout = CopyLoadout(NormalizeLoadout(group_loadout))
  local personal = SCLM.Users[ply:SteamID()]

  -- Merge at apply time. It keeps v1 inheritance cheap and explicit without
  -- cloning per-player rule trees until richer override semantics are needed.
  if personal then
    personal = NormalizeLoadout(personal)
    loadout.enforce = loadout.enforce or personal.enforce
    if personal.primary ~= "" then loadout.primary = personal.primary end

    for class, weapon in pairs(personal.weapons) do
      loadout.weapons[class] = table.Copy(weapon)
    end
  end

  return loadout
end

---@param ply Player
---@param loadout table
function SCLM.GiveLoadout(ply, loadout)
  if loadout.enforce then
    ply:StripWeapons()
    ply:StripAmmo()
  end

  -- Keep ammo writes conservative. Older loadout managers derive clip/reserve
  -- splits from SWEP clip sizes; switch only if reserve-only ammo becomes a bug.
  for class, weapon in pairs(loadout.weapons) do
    if list.Get("Weapon")[class] and not ply:HasWeapon(class) then
      ply:Give(class)
    end

    local swep = ply:GetWeapon(class)
    if IsValid(swep) then
      if weapon.primary >= 0 and swep:GetPrimaryAmmoType() >= 0 then ply:SetAmmo(weapon.primary, swep:GetPrimaryAmmoType()) end
      if weapon.secondary >= 0 and swep:GetSecondaryAmmoType() >= 0 then ply:SetAmmo(weapon.secondary, swep:GetSecondaryAmmoType()) end
    end
  end

  if loadout.primary ~= "" and ply:HasWeapon(loadout.primary) then
    ply:SelectWeapon(loadout.primary)
  end
end

---@param ply Player
---@return boolean?
function SCLM.PlayerLoadout(ply)
  local override = hook.Run(SCLM.HookPlayerLoadout, ply)
  if override ~= nil then return override end

  local loadout = SCLM.GetEffectiveLoadout(ply)
  SCLM.GiveLoadout(ply, loadout)

  if loadout.enforce then return true end
end

---@param target table
---@param owner string
---@param class string
---@param primary number?
---@param secondary number?
function SCLM.AddWeapon(target, owner, class, primary, secondary)
  if not HasOwnerAndClass(owner, class) then return end

  target[owner] = NormalizeLoadout(target[owner])
  target[owner].weapons[class] = WeaponData(class, primary, secondary)
  SCLM.Save()
end

---@param target table
---@param owner string
function SCLM.Clear(target, owner)
  if not isstring(owner) or owner == "" then return end

  target[owner] = nil
  SCLM.Save()
end

---@param target table
---@param owner string
---@param enforce boolean
function SCLM.SetEnforce(target, owner, enforce)
  if not isstring(owner) or owner == "" then return end

  target[owner] = NormalizeLoadout(target[owner])
  target[owner].enforce = enforce
  SCLM.Save()
end

---@param target table
---@param owner string
---@param class string
function SCLM.SetPrimary(target, owner, class)
  if not HasOwnerAndClass(owner, class) then return end

  target[owner] = NormalizeLoadout(target[owner])
  target[owner].primary = target[owner].primary == class and "" or class
  SCLM.Save()
end

---@param target table
---@param owner string
---@param class string
function SCLM.RemoveWeapon(target, owner, class)
  if not HasOwnerAndClass(owner, class) then return end

  target[owner] = NormalizeLoadout(target[owner])
  target[owner].weapons[class] = nil
  if target[owner].primary == class then target[owner].primary = "" end
  SCLM.Save()
end

function SCLM.Load()
  file.CreateDir(SCLM.DataDir)

  local data = util.JSONToTable(file.Read(SCLM.DataFile, "DATA") or "") or {}
  SCLM.Groups = istable(data.groups) and data.groups or {}
  SCLM.Users = istable(data.users) and data.users or {}

  for group, loadout in pairs(SCLM.Groups) do
    SCLM.Groups[group] = NormalizeLoadout(loadout)
  end

  for steamid, loadout in pairs(SCLM.Users) do
    SCLM.Users[steamid] = NormalizeLoadout(loadout)
  end
end

function SCLM.Save()
  file.CreateDir(SCLM.DataDir)
  file.Write(SCLM.DataFile, util.TableToJSON({
    groups = SCLM.Groups,
    users = SCLM.Users
  }, true))
end

---@return table
function SCLM.State()
  return {
    groups = SCLM.Groups,
    users = SCLM.Users,
    usergroups = GroupNames(),
    weapons = WeaponNames()
  }
end

---@param ply Player
function SCLM.SendState(ply)
  net.Start(SCLM.NetState)
  net.WriteTable(SCLM.State())
  net.Send(ply)
end

---@param ply Player
function SCLM.OpenAdminMenu(ply)
  if not IsValid(ply) then return end

  WithAccess(ply, function()
    SCLM.SendState(ply)
    -- Menu opens use client Lua so the finite NetworkString pool is spent only
    -- on state/action messages needed for normal editor sync.
    ply:SendLua("SCLM.OpenMenu(true)")
  end)
end

---@param ply Player
function SCLM.OpenPersonalMenu(ply)
  if not CanUsePersonalMenu(ply) then return end

  SCLM.SendState(ply)
  -- Menu opens use client Lua so the finite NetworkString pool is spent only
  -- on state/action messages needed for normal editor sync.
  ply:SendLua("SCLM.OpenMenu(false)")
end

---@param ply Player
function SCLM.RefreshAdminState(ply)
  if not IsValid(ply) then return end

  WithAccess(ply, function()
    SCLM.SendState(ply)
  end)
end

---@param ply Player
---@param action string
---@param data table
local function RunAction(ply, action, data)
  if action == "add_personal_weapon" then
    SCLM.AddWeapon(SCLM.Users, ply:SteamID(), data.class, data.primary, data.secondary)
    RefreshOwner(SCLM.Users, ply:SteamID(), ply)
  elseif action == "remove_personal_weapon" then
    SCLM.RemoveWeapon(SCLM.Users, ply:SteamID(), data.class)
    RefreshOwner(SCLM.Users, ply:SteamID(), ply)
  elseif action == "clear_personal" then
    SCLM.Clear(SCLM.Users, ply:SteamID())
    RefreshOwner(SCLM.Users, ply:SteamID(), ply)
  elseif action == "enforce_personal" then
    SCLM.SetEnforce(SCLM.Users, ply:SteamID(), SCLM.ToBool(data.enforce))
    RefreshOwner(SCLM.Users, ply:SteamID(), ply)
  elseif action == "primary_personal" then
    SCLM.SetPrimary(SCLM.Users, ply:SteamID(), data.class)
    RefreshOwner(SCLM.Users, ply:SteamID(), ply)
  else
    WithAccess(ply, function()
      if action == "add_group_weapon" then
        SCLM.AddWeapon(SCLM.Groups, data.owner, data.class, data.primary, data.secondary)
        RefreshOwner(SCLM.Groups, data.owner, ply)
      elseif action == "remove_group_weapon" then
        SCLM.RemoveWeapon(SCLM.Groups, data.owner, data.class)
        RefreshOwner(SCLM.Groups, data.owner, ply)
      elseif action == "clear_group" then
        SCLM.Clear(SCLM.Groups, data.owner)
        RefreshOwner(SCLM.Groups, data.owner, ply)
      elseif action == "enforce_group" then
        SCLM.SetEnforce(SCLM.Groups, data.owner, SCLM.ToBool(data.enforce))
        RefreshOwner(SCLM.Groups, data.owner, ply)
      elseif action == "primary_group" then
        SCLM.SetPrimary(SCLM.Groups, data.owner, data.class)
        RefreshOwner(SCLM.Groups, data.owner, ply)
      end

      SCLM.SendState(ply)
    end)
    return
  end

  SCLM.SendState(ply)
end

---@param ply Player
---@param args table
---@param callback fun(target: table, owner: string)?
local function WithPlayerTarget(ply, args, callback)
  local target = FindPlayer(args[1])
  if not target then
    Deny(ply, "Player not found.")
    return
  end

  callback(SCLM.Users, target:SteamID())
end

---@param target table
---@param owner string
---@param ply Player
function RefreshOwner(target, owner, ply)
  if target == SCLM.Users then
    local target_ply = player.GetBySteamID(owner)
    if IsValid(target_ply) then SCLM.GiveLoadout(target_ply, SCLM.GetEffectiveLoadout(target_ply)) end
    return
  end

  for _, target_ply in ipairs(player.GetAll()) do
    if target_ply:GetUserGroup() == owner then
      SCLM.GiveLoadout(target_ply, SCLM.GetEffectiveLoadout(target_ply))
    end
  end
end

---@param target table
---@param owner string
---@param args table
---@param ply Player
local function AddFromCommand(target, owner, args, ply)
  SCLM.AddWeapon(target, owner, args[2], args[3], args[4])
  RefreshOwner(target, owner, ply)
end

net.Receive(SCLM.NetRunAction, function(_, ply)
  RunAction(ply, net.ReadString(), net.ReadTable())
end)

---@param ply Player
---@param _ string
---@param args table
local function AddGroupWeapon(ply, _, args)
  WithAccess(ply, function()
    AddFromCommand(SCLM.Groups, args[1], { args[1], args[2], args[3], args[4] }, ply)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function AddUserWeapon(ply, _, args)
  WithAccess(ply, function()
    WithPlayerTarget(ply, args, function(target, owner)
      AddFromCommand(target, owner, { args[1], args[2], args[3], args[4] }, ply)
    end)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function ClearGroup(ply, _, args)
  WithAccess(ply, function()
    SCLM.Clear(SCLM.Groups, args[1])
    RefreshOwner(SCLM.Groups, args[1], ply)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function ClearUser(ply, _, args)
  WithAccess(ply, function()
    WithPlayerTarget(ply, args, function(target, owner)
      SCLM.Clear(target, owner)
      RefreshOwner(target, owner, ply)
    end)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function EnforceGroup(ply, _, args)
  WithAccess(ply, function()
    SCLM.SetEnforce(SCLM.Groups, args[1], SCLM.ToBool(args[2]))
    RefreshOwner(SCLM.Groups, args[1], ply)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function EnforceUser(ply, _, args)
  WithAccess(ply, function()
    WithPlayerTarget(ply, args, function(target, owner)
      SCLM.SetEnforce(target, owner, SCLM.ToBool(args[2]))
      RefreshOwner(target, owner, ply)
    end)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function PrimaryGroup(ply, _, args)
  WithAccess(ply, function()
    SCLM.SetPrimary(SCLM.Groups, args[1], args[2])
    RefreshOwner(SCLM.Groups, args[1], ply)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function PrimaryUser(ply, _, args)
  WithAccess(ply, function()
    WithPlayerTarget(ply, args, function(target, owner)
      SCLM.SetPrimary(target, owner, args[2])
      RefreshOwner(target, owner, ply)
    end)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function RemoveGroupWeapon(ply, _, args)
  WithAccess(ply, function()
    SCLM.RemoveWeapon(SCLM.Groups, args[1], args[2])
    RefreshOwner(SCLM.Groups, args[1], ply)
  end)
end

---@param ply Player
---@param _ string
---@param args table
local function RemoveUserWeapon(ply, _, args)
  WithAccess(ply, function()
    WithPlayerTarget(ply, args, function(target, owner)
      SCLM.RemoveWeapon(target, owner, args[2])
      RefreshOwner(target, owner, ply)
    end)
  end)
end

hook.Add("PlayerLoadout", "SCLM_PlayerLoadout", SCLM.PlayerLoadout)

if CAMI and CAMI.RegisterPrivilege then
  CAMI.RegisterPrivilege({
    Name = SCLM.AccessPrivilege,
    MinAccess = "superadmin",
    Description = "Access to SC Loadout Manager"
  })
end

if ULib and ULib.ucl and ULib.ucl.registerAccess then
  ULib.ucl.registerAccess(SCLM.AccessPrivilege, ULib.ACCESS_SUPERADMIN, "Access to SC Loadout Manager", "SC Loadout Manager")
end

concommand.Add("sclm_menu", function(ply, _, _, _) SCLM.OpenAdminMenu(ply) end, nil, "Open SC Loadout Manager.", { FCVAR_NONE })
concommand.Add("sclm_loadout", function(ply, _, _, _) SCLM.OpenPersonalMenu(ply) end, nil, "Open your SC Loadout Manager loadout.", { FCVAR_NONE })
concommand.Add("sclm_refresh", function(ply, _, _, _) SCLM.RefreshAdminState(ply) end, nil, "Refresh SC Loadout Manager state.", { FCVAR_NONE })
concommand.Add("sclm_add_group_weapon", AddGroupWeapon, CompleteGroupWeapon, "Add a weapon to a group loadout.", { FCVAR_NONE })
concommand.Add("sclm_add_user_weapon", AddUserWeapon, CompletePlayerWeapon, "Add a weapon to a player loadout.", { FCVAR_NONE })
concommand.Add("sclm_clear_group", ClearGroup, CompleteGroupWeapon, "Clear a group loadout.", { FCVAR_NONE })
concommand.Add("sclm_clear_user", ClearUser, CompletePlayerWeapon, "Clear a player loadout.", { FCVAR_NONE })
concommand.Add("sclm_enforce_group", EnforceGroup, CompleteGroupWeapon, "Set group loadout enforce state.", { FCVAR_NONE })
concommand.Add("sclm_enforce_user", EnforceUser, CompletePlayerWeapon, "Set player loadout enforce state.", { FCVAR_NONE })
concommand.Add("sclm_primary_group", PrimaryGroup, CompleteGroupWeapon, "Toggle a group primary weapon.", { FCVAR_NONE })
concommand.Add("sclm_primary_user", PrimaryUser, CompletePlayerWeapon, "Toggle a player primary weapon.", { FCVAR_NONE })
concommand.Add("sclm_remove_group_weapon", RemoveGroupWeapon, CompleteGroupWeapon, "Remove a weapon from a group loadout.", { FCVAR_NONE })
concommand.Add("sclm_remove_user_weapon", RemoveUserWeapon, CompletePlayerWeapon, "Remove a weapon from a player loadout.", { FCVAR_NONE })

SCLM.Load()
hook.Run("OnSCLMLoaded")
SCLM.Log("SC Loadout Manager version %s loaded.", SCLM.Version)
