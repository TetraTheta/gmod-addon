local m_floor = math.floor
local n_AddLegacy = notification.AddLegacy
local s_PlaySound = surface.PlaySound
local u_Decompress = util.Decompress
local u_JSONToTable = util.JSONToTable
--
---@param value any
---@param msg string
---@return boolean
local function _ShowNotification(value, msg)
  if isnumber(value) and m_floor(value) > 0 then
    n_AddLegacy("Cleaned " .. value .. " " .. msg, NOTIFY_GENERIC, 3)
    return true
  elseif isbool(value) and value then
    n_AddLegacy("Cleaned " .. msg, NOTIFY_GENERIC, 3)
    return true
  else
    return false
  end
end

net.Receive("SCTOOLS_CleanResult", function(_, _)
  local result = u_JSONToTable(u_Decompress(net.ReadData(net.ReadUInt(16)))) ---@cast result table
  local sound = false
  --
  if _ShowNotification(result.ammo, "Ammo") then sound = true end
  if _ShowNotification(result.debris, "Debris") then sound = true end
  if _ShowNotification(result.gibs, "Gibs") then sound = true end
  if _ShowNotification(result.powerups, "Powerups") then sound = true end
  if _ShowNotification(result.ragdolls, "Ragdolls") then sound = true end
  if _ShowNotification(result.small, "Small objects") then sound = true end
  if _ShowNotification(result.weapons, "Weapons") then sound = true end
  if sound then _ShowNotification(result.decals, "Decals") end
  if sound then s_PlaySound("garrysmod/ui_hover.wav") end
end)
