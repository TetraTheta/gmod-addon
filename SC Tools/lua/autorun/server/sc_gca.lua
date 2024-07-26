--[[
  Commands:
  * sc_gca [player] - Refill the ammo of the weapon that the given player is holding.
--]]
require("sctools")
local GetPlayerByName = sctools.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.SuggestPlayer
--
util.AddNetworkString("SCGCA")
local function GiveCurrentAmmo(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  local p
  if args[1] ~= nil then
    if args[2] ~= nil then SendMessage("[SC GCA] Only first player will be processed.", ply, HUD_PRINTCONSOLE) end
    p = GetPlayerByName(args[1])
  else
    p = ply
  end

  if IsValid(p) and p:IsPlayer() then
    local wep = p:GetActiveWeapon()
    local maxcvar = GetConVar("gmod_maxammo"):GetInt()
    local max = isnumber(maxcvar) and maxcvar or 9999
    p:SetAmmo(max, wep:GetPrimaryAmmoType())
    p:SetAmmo(max, wep:GetSecondaryAmmoType())
    SendMessage("[SC GCA] Ammo of " .. p:GetName() .. "'s weapon is refilled.", ply, HUD_PRINTCONSOLE)
    SendMessage("[SC GCA] Your ammo has been refilled.", p, HUD_PRINTTALK)
  end
end

local function GiveCurrentAmmoAutocomplete(cmd, args)
  return SuggestPlayer("sc_gca", cmd, args)
end

concommand.Add("sc_gca", GiveCurrentAmmo, GiveCurrentAmmoAutocomplete, "Refill the ammo of the weapon that the given player is holding.", FCVAR_NONE)
