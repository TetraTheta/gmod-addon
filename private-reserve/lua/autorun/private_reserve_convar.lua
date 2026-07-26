---@param convar string
---@param description string
---@param def string
---@param min number
---@param max number
local function _CreateConVar(convar, description, def, min, max)
  local flags = { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY }
  if not ConVarExists(convar) then CreateConVar(convar, def, flags, description, min, max) end
end

---@param convar string
---@param description string
---@param def string
local function _CreateStringConVar(convar, description, def)
  local flags = { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY }
  if not ConVarExists(convar) then CreateConVar(convar, def, flags, description) end
end

--[[
Server ConVar

pr_autojump <0|1> - Auto Jump mode. 0 = Off, 1 = Jump Spam (Server Managed).
pr_autojump_delay <seconds> - Seconds IN_JUMP must be held before auto jump starts.
pr_disable_headcrab <0|1> - Disable headcrab detachment from dead zombies. 0 = Enable, 1 = Disable.
pr_edit_weapon_pickup <0|1> - Enable custom weapon pickup for certain weapons. 0 = Disable, 1 = Enable.
pr_enable_flying_drops <0|1> - Enable flying weapon drops. 0 = Disable, 1 = Enable.
pr_enable_kill_reload <0|1> - Reload current weapon when kill. 0 = Disable, 1 = Enable.
pr_enable_loadout <0|1> - Enable automatic loadout management. 0 = Disable, 1 = Enable.
pr_enable_shoot_open_crate <0|1> - Enable opening Ammo Crate by shooting it. 0 = Disable, 1 = Enable.
pr_enable_special_damage <0|1> - Modify damage when using certain weapons. 0 = Disable, 1 = Enable.
pr_shoot_button_use_enable <0|1> - Use buttons and doors hit by player bullets. 0 = Disable, 1 = Enable.
pr_shoot_button_use_excluded_weapons <weapon classes> - Space or comma separated weapon classes excluded from shoot-to-use.
pr_shoot_button_use_unlock <0|1> - Unlock target before shoot-to-use. 0 = Disable, 1 = Enable.
]]
_CreateConVar("pr_autojump", "Auto Jump mode. 0 = Off, 1 = Jump Spam (Server Managed).", "0", 0, 1)
_CreateConVar("pr_autojump_delay", "Seconds IN_JUMP must be held before auto jump starts.", "0.75", 0, 5)
_CreateConVar("pr_disable_headcrab", "Disable headcrab detachment from dead zombies. 0 = Enable, 1 = Disable.", "0", 0, 1)
_CreateConVar("pr_edit_weapon_pickup", "Enable custom weapon pickup for certain weapons. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_flying_drops", "Enable flying weapon drops. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_kill_reload", "Reload current weapon when kill. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_loadout", "Enable automatic loadout management. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_shoot_open_crate", "Enable opening Ammo Crate by shooting it. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_special_damage", "Modify damage when using certain weapons. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_shoot_button_use_enable", "Use buttons and doors hit by player bullets. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_shoot_button_use_unlock", "Unlock target before shoot-to-use. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateStringConVar("pr_shoot_button_use_excluded_weapons", "Space or comma separated weapon classes excluded from shoot-to-use.", "")
