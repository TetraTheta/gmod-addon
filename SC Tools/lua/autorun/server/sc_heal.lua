--[[
  Commands:
  * sc_heal [player] - Heal player
  * sc_overheal [player] - Heal player and charge the player's suit too
]]
--
require("sctools")
local GetPlayerByName = sctools.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.SuggestPlayer
--
local function Heal(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  local p
  if args[1] ~= nil then
    if args[2] ~= nil then SendMessage("[SC Heal] Only first player will be processed.", ply, HUD_PRINTCONSOLE) end
    p = GetPlayerByName(args[1])
  else
    p = ply
  end

  if IsValid(p) and p:IsPlayer() then
    p:SetHealth(p:GetMaxHealth())
    SendMessage("[SC Heal] " .. p:GetName() .. " is healed.", ply, HUD_PRINTTALK)
  end
end

local function HealAutoComplete(cmd, args)
  return SuggestPlayer("sc_heal", cmd, args)
end

local function OverHeal(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  local p
  if args[1] ~= nil then
    if args[2] ~= nil then SendMessage("[SC Heal] Only first player will be processed.", ply, HUD_PRINTCONSOLE) end
    p = GetPlayerByName(args[1])
  else
    p = ply
  end

  if IsValid(p) and p:IsPlayer() then
    p:SetHealth(p:GetMaxHealth())
    p:SetArmor(p:GetMaxArmor())
    SendMessage("[SC Heal] " .. p:GetName() .. " is healed.", ply, HUD_PRINTTALK)
  end
end

local function OverHealAutoComplete(cmd, args)
  return SuggestPlayer("sc_overheal", cmd, args)
end

concommand.Add("sc_heal", Heal, HealAutoComplete, "Heal player.", FCVAR_NONE)
concommand.Add("sc_overheal", OverHeal, OverHealAutoComplete, "Heal player.", FCVAR_NONE)
