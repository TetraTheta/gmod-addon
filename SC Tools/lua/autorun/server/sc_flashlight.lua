--[[
  Commands:
  * sc_flashlight <player> - Enable flashlight for the given player.

  ConVars:
  * sc_flashlight_auto <0|1|2> - Automatically enable flashlight to players. 0 = Disable, 1 = Super Admin Only, 2 = All Players.
--]]
require("sctools")
local GetPlayerByName = sctools.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.SuggestPlayer
--
local function AllowFlashlightAutomatic(_)
  local cv = GetConVar("sc_flashlight_auto"):GetInt()
  if not isnumber(cv) then return end
  if cv == 1 then
    for _, p in ipairs(player.GetHumans()) do
      if p:IsUserGroup("superadmin") and not p:CanUseFlashlight() then
        p:AllowFlashlight(true)
        SendMessage("[SC Flashlight] Flashlight is enabled.", p, HUD_PRINTTALK)
      end
    end
  elseif cv == 2 then
    for _, p in ipairs(player.GetHumans()) do
      if not p:CanUseFlashlight() then
        p:AllowFlashlight(true)
        SendMessage("[SC Flashlight] Flashlight is enabled.", p, HUD_PRINTTALK)
      end
    end
  end
end

local function AllowFlashlightAutocomplete(cmd, args)
  return SuggestPlayer("sc_flashlight", cmd, args)
end

local function AllowFlashlight(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if args[1] ~= nil then
    if args[2] ~= nil then SendMessage("[SC Flashlight] Only first player will be processed.", ply, HUD_PRINTCONSOLE) end
    local p = GetPlayerByName(args[1])
    if p ~= nil and IsValid(p) and p:IsPlayer() then
      p:AllowFlashlight(true)
      SendMessage("[SC Flashlight] Flashlight is enabled to " .. p:GetName() .. ".", ply, HUD_PRINTTALK)
    else
      SendMessage("[SC Flashlight] Failed to get player named '" .. args[1] .. "'.", ply, HUD_PRINTTALK)
    end
  else
    SendMessage("[SC Flashlight] You must provide one player.", ply, HUD_PRINTCONSOLE)
  end
end

concommand.Add("sc_flashlight", AllowFlashlight, AllowFlashlightAutocomplete, "Enable flashlight for the given player.", FCVAR_NONE)
hook.Add("PlayerSpawn", "SCAllowFlashlightAuto", AllowFlashlightAutomatic)
