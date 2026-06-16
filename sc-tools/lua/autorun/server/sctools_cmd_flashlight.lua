require("sctools")
local b_band = bit.band
local GetPlayerByName = sctools.command.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
--
local AUTO_FLASHLIGHT_ENABLED = 1
local AUTO_FLASHLIGHT_ALL_PLAYERS = 2
local AUTO_FLASHLIGHT_VERBOSE = 4
local cv = GetConVar("sc_auto_flashlight")
--
--[[
################
#     HOOK     #
################
]]
--
---@param p Player
hook.Add("PlayerSpawn", "SCTOOLS_EnableFlashlightAuto", function(p, _)
  local cvv = cv:GetInt()
  local toggle = b_band(cvv, AUTO_FLASHLIGHT_ENABLED) > 0
  local allplayer = b_band(cvv, AUTO_FLASHLIGHT_ALL_PLAYERS) > 0
  local verbose = b_band(cvv, AUTO_FLASHLIGHT_VERBOSE) > 0
  if not toggle then return end
  if not allplayer and p:IsUserGroup("superadmin") and not p:CanUseFlashlight() then
    -- Super Admin Only
    p:AllowFlashlight(true)
    if verbose then SendMessage("[SC Flashlight] Flashlight is automatically enabled.", p, HUD_PRINTTALK) end
  elseif allplayer then
    -- All Players
    p:AllowFlashlight(true)
    if verbose then SendMessage("[SC Flashlight] Flashlight is automatically enabled.", p, HUD_PRINTTALK) end
  end
end)

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
local function EnableFlashlight(ply, args, silent)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 and not silent then SendMessage("[SC Flashlight] Only first player will be processed.", ply) end
  local p = #args > 0 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() and not p:CanUseFlashlight() then
    p:AllowFlashlight(true)
    if p ~= ply then SendMessage(Format("[SC Flashlight] Flashlight is enabled to %s", p:Nick()), p) end
    SendMessage("[SC Flashlight] Flashlight is enabled.", p, HUD_PRINTTALK)
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
local function AllowFlashlightCompletion(_, args)
  return SuggestPlayer("sc_flashlight", args)
end

---@param args string
---@return table
local function AllowFlashlightSCompletion(_, args)
  return SuggestPlayer("sc_flashlight", args)
end

--
--[[
############################
#     COMMAND REGISTER     #
############################
]]
--
concommand.Add("sc_flashlight", function(p, _, args, _) EnableFlashlight(p, args, false) end, AllowFlashlightCompletion, "Enable flashlight for the given player.", { FCVAR_NONE })
concommand.Add("sc_flashlight_s", function(p, _, args, _) EnableFlashlight(p, args, true) end, AllowFlashlightSCompletion, "Enable flashlight for the given player. (Silent)", { FCVAR_NONE })
