require("sctools")
local m_floor = math.floor
local n_AddLegacy = notification.AddLegacy
local s_PlaySound = surface.PlaySound
local t_insert = table.insert
local u_Decompress = util.Decompress
local u_JSONToTable = util.JSONToTable
--
local ragdolls = setmetatable({}, { __mode = "v" }) -- 'value'(Ragdoll) is weak reference (can be garbage collected)
--
---@param value any
---@param msg string
---@return boolean
local function ShowNotification(value, msg)
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

--[[
###############
#     NET     #
###############
]]

net.Receive("SCTOOLS_CleanResult", function(_, _)
  local json = u_Decompress(net.ReadData(net.ReadUInt(16)))
  ---@cast json string
  local result = u_JSONToTable(json)
  ---@cast result table
  local sound = false
  --
  if ShowNotification(result.ammo, "Ammo") then sound = true end
  if ShowNotification(result.debris, "Debris") then sound = true end
  if ShowNotification(result.gibs, "Gibs") then sound = true end
  if ShowNotification(result.powerups, "Powerups") then sound = true end
  if ShowNotification(result.ragdolls, "Ragdolls") then sound = true end
  if ShowNotification(result.small, "Small objects") then sound = true end
  if ShowNotification(result.weapons, "Weapons") then sound = true end
  if sound then ShowNotification(result.decals, "Decals") end
  if sound then s_PlaySound("garrysmod/ui_hover.wav") end
end)

net.Receive("SCTOOLS_CleanRagdolls", function(_, _)
  -- attempt to remove with effect
  for _, v in ipairs(ents.FindByClass("client_ragdoll")) do
    if IsValid(v) then
      if sctools ~= nil then
        sctools.RemoveEntity(v)
      else
        v:Remove()
      end
    end
  end
  for _, v in ipairs(ragdolls) do
    if IsValid(v) then
      if sctools ~= nil then
        sctools.RemoveEntity(v)
      else
        v:Remove()
      end
    end
  end
  ragdolls = {}
  -- fallback: just remove them
  game.RemoveRagdolls()
end)

--[[
################
#     HOOK     #
################
]]

hook.Add("CreateClientsideRagdoll", "SCTOOLS_RagdollClientCreation", function(_, ragdoll) t_insert(ragdolls, ragdoll) end)
