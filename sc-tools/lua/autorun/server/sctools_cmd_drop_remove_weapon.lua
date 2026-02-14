require("sctools")
local GetPlayerByName = sctools.command.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SuggestPlayer = sctools.command.SuggestPlayer
local SendMessage = sctools.SendMessage
--
--[[
###########################
#     COMMAND EXECUTE     #
###########################
]]
--
---@param ply Player
---@param args table
---@param silent boolean
local function DropWeapon(ply, args, silent)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 and not silent then SendMessage("[SC Drop Weapon] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    local wep = p:GetActiveWeapon()
    if IsValid(wep) then
      p:DropWeapon(wep)
      if p ~= ply and not silent then SendMessage(Format("[SC Drop Weapon] Dropped weapon that %s was holding.", p:Nick()), ply) end
    end
  end
end

---@param ply Player
---@param args table
---@param silent boolean
local function RemoveWeapon(ply, args, silent)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 and not silent then SendMessage("[SC Remove Weapon] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    local wep = p:GetActiveWeapon()
    if IsValid(wep) then
      p:StripWeapon(wep:GetClass())
      if p ~= ply and not silent then SendMessage(Format("[SC Remove Weapon] Removed weapon that %s was holding.", p:Nick()), ply) end
    end
  end
end

--
--[[
#################################
#     COMMAND AUTO COMPLETE     #
#################################
]]
--
local function DropWeaponComplete(_, args)
  return SuggestPlayer("sc_drop_weapon", args)
end

local function DropWeaponSComplete(_, args)
  return SuggestPlayer("sc_drop_weapon_s", args)
end

local function RemoveWeaponComplete(_, args)
  return SuggestPlayer("sc_remove_weapon", args)
end

local function RemoveWeaponSComplete(_, args)
  return SuggestPlayer("sc_remove_weapon_s", args)
end

--
--[[
############################
#     COMMAND REGISTER     #
############################
]]
--
concommand.Add("sc_drop_weapon", function(ply, _, args, _) DropWeapon(ply, args, false) end, DropWeaponComplete, "Drop weapon that given player is currently holding.", { FCVAR_NONE })
concommand.Add("sc_drop_weapon_s", function(ply, _, args, _) DropWeapon(ply, args, true) end, DropWeaponSComplete, "Drop weapon that given player is currently holding. (Silent)", { FCVAR_NONE })
concommand.Add("sc_remove_weapon", function(ply, _, args, _) RemoveWeapon(ply, args, false) end, RemoveWeaponComplete, "Remove weapon that given player is currently holding.", { FCVAR_NONE })
concommand.Add("sc_remove_weapon_s", function(ply, _, args, _) RemoveWeapon(ply, args, true) end, RemoveWeaponSComplete, "Remove weapon that given player is currently holding. (Silent)", { FCVAR_NONE })
