--[[
  Commands:
  * sc_flashlight <player> - Enable flashlight for the given player.

  ConVars:
  * sc_flashlight_auto <0|1|2> - Automatically enable flashlight to players. 0 = Disable, 1 = Super Admin Only, 2 = All Players.
--]]
local function AllowFlashlightAutomatic(_)
  local cv = GetConVar("sc_flashlight_auto"):GetInt()
  if not isnumber(cv) then return end
  if cv == 1 then
    for _, p in ipairs(player.GetHumans()) do
      if p:IsUserGroup("superadmin") and not p:CanUseFlashlight() then
        p:AllowFlashlight(true)
        SendMessage(p, HUD_PRINTTALK, "[SC Flashlight] Flashlight is enabled.")
      end
    end
  elseif cv == 2 then
    for _, p in ipairs(player.GetHumans()) do
      if not p:CanUseFlashlight() then
        p:AllowFlashlight(true)
        SendMessage(p, HUD_PRINTTALK, "[SC Flashlight] Flashlight is enabled.")
      end
    end
  end
end

local function AllowFlashlightAutocomplete(cmd, args)
  return SuggestPlayer("sc_flashlight", cmd, args)
end

local function AllowFlashlight(ply, cmd, args, str)
  if not CheckSAdminConsole(ply) then return end
  if args[1] ~= nil then
    if args[2] ~= nil then SendMessage(ply, HUD_PRINTCONSOLE, "[SC Flashlight] Only first player will be processed.") end
    local p = GetPlayerByName(args[1])
    if p ~= nil and IsValid(p) and p:IsPlayer() then
      p:AllowFlashlight(true)
      SendMessage(ply, HUD_PRINTTALK, "[SC Flashlight] Flashlight is enabled to " .. p:GetName() .. ".")
    else
      SendMessage(ply, HUD_PRINTTALK, "[SC Flashlight] Failed to get player named '" .. args[1] .. "'.")
    end
  else
    SendMessage(ply, HUD_PRINTCONSOLE, "[SC Flashlight] You must provide one player.")
  end
end

concommand.Add("sc_flashlight", AllowFlashlight, AllowFlashlightAutocomplete, "Enable flashlight for the given player.", FCVAR_NONE)
hook.Add("PlayerSpawn", "SCAllowFlashlightAuto", AllowFlashlightAutomatic)
