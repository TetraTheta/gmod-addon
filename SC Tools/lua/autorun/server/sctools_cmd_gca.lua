require("sctools")
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
local IsSuperAdmin = sctools.IsSuperAdmin
local GetPlayerByName = sctools.command.GetPlayerByName
--
util.AddNetworkString("SCTOOLS_GiveCurrentAmmoSound")
--
---@param ply Player
---@param args table
local function GiveCurrentAmmo(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 then SendMessage("[SC GCA] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    local wep = p:GetActiveWeapon()
    local max = GetConVar("gmod_maxammo"):GetInt()
    p:SetAmmo(max, wep:GetPrimaryAmmoType())
    p:SetAmmo(max, wep:GetSecondaryAmmoType())
    if p ~= ply then SendMessage(Format("[SC GCA] Ammunition of %s's weapon is refilled.", p:GetName()), ply) end
    SendMessage("[SC GCA] Your current weapon's ammunition is refilled.", p, HUD_PRINTTALK)
  end
end

---@param args string
---@return table
local function GiveCurrentAmmoCompletion(_, args)
  return SuggestPlayer("sc_gca", args)
end

concommand.Add("sc_gca", GiveCurrentAmmo, GiveCurrentAmmoCompletion, "Refill the ammo of the weapon that the given player is holding.", FCVAR_NONE)
