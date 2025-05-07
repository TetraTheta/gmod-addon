require("sctools")
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
local IsSuperAdmin = sctools.IsSuperAdmin
local GetPlayerByName = sctools.command.GetPlayerByName
--
--[[
#############################
#     AUTO ENABLE FLASH     #
#############################
]]
---@param p Player
hook.Add("PlayerSpawn", "SCTOOLS_EnableFlashlightAuto", function(p, _)
  local cv = GetConVar("sc_auto_flashlight"):GetInt()
  if cv == 1 and p:IsUserGroup("superadmin") and not p:CanUseFlashlight() then
    -- SuperAdmin only
    p:AllowFlashlight(true)
    SendMessage("[SC Flashlight] Flashlight is automatically enabled.", p, HUD_PRINTTALK)
  elseif cv == 2 and not p:CanUseFlashlight() then
    -- Everyone
    p:AllowFlashlight(true)
    SendMessage("[SC Flashlight] Flashlight is automatically enabled.", p, HUD_PRINTTALK)
  end
end)
--[[
################################
#     FLASH ENABLE COMMAND     #
################################
]]
---@param args string
---@return table
local function AllowFlashlightCompletion(_, args)
  return SuggestPlayer("sc_flashlight", args)
end

---@param p Player
---@param args table
concommand.Add("sc_flashlight", function(p, _, args, _)
  if not IsSuperAdmin(p) then return end
  if #args > 1 then SendMessage("[SC Flashlight] Only first player will be processed.", p) end
  if #args == 0 then SendMessage("[SC Flashlight] You must provide one player.", p) end
  local ply = GetPlayerByName(args[1])
  if IsValid(ply) and p:IsPlayer() and not p:CanUseFlashlight() then
    ply:AllowFlashlight(true)
    if p ~= ply then SendMessage(Format("[SC Flashlight] Flashlight is enabled to %s", ply:GetName()), p) end
    SendMessage("[SC Flashlight] Flashlight is enabled.", ply, HUD_PRINTTALK)
  end
end, AllowFlashlightCompletion, "Enable flashlight for the given player.", { FCVAR_NONE })
