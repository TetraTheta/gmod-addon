require("sctools")
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
local IsSuperAdmin = sctools.IsSuperAdmin
local GetPlayerByName = sctools.command.GetPlayerByName
--
util.AddNetworkString("SCTOOLS_GiveCurrentAmmoSound")
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
local function GiveCurrentAmmo(ply, args, silent)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 and not silent then SendMessage("[SC GiveCurrentAmmo] Only first player will be processed.", ply) end
  local p = #args > 0 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    local wep = p:GetActiveWeapon()
    local max = GetConVar("gmod_maxammo"):GetInt()
    p:SetAmmo(max, wep:GetPrimaryAmmoType())
    p:SetAmmo(max, wep:GetSecondaryAmmoType())
    if p ~= ply and not silent then SendMessage(Format("[SC GiveCurrentAmmo] Ammunition of %s's weapon is refilled.", p:Nick()), ply) end
    if not silent then SendMessage("[SC GiveCurrentAmmo] Your current weapon's ammunition is refilled.", p, HUD_PRINTTALK) end
  end
end

--
--[[
#################################
#     COMMAND AUTO COMPLETE     #
#################################
]]
--
---@param args string
---@return table
local function GiveCurrentAmmoCompletion(_, args)
  return SuggestPlayer("sc_gca", args)
end

---@param args string
---@return table
local function GiveCurrentAmmoSCompletion(_, args)
  return SuggestPlayer("sc_gca_s", args)
end

--
--[[
############################
#     COMMAND REGISTER     #
############################
]]
--
concommand.Add("sc_gca", function(ply, _, args, _) GiveCurrentAmmo(ply, args, false) end, GiveCurrentAmmoCompletion, "Refill the ammo of the weapon that the given player is holding.", {FCVAR_NONE})
concommand.Add("sc_gca_s", function(ply, _, args, _) GiveCurrentAmmo(ply, args, true) end, GiveCurrentAmmoSCompletion, "Refill the ammo of the weapon that the given player is holding. (Silent)", {FCVAR_NONE})
