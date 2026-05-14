---@param convar string
---@param description string
---@param def string
---@param min number
---@param max number
local function _CreateConVar(convar, description, def, min, max)
  local flags = {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY}
  if not ConVarExists(convar) then CreateConVar(convar, def, flags, description, min, max) end
end

--[[
Server ConVar

pr_autojump <0|1> - Auto Jump mode. 0 = Off, 1 = Jump Spam (Server Managed).
pr_disable_headcrab <0|1> - Disable headcrab detachment from dead zombies. 0 = Enable, 1 = Disable.
pr_enable_additional_pickup <0|1> - Enable custom weapon pickup for certain weapons. 0 = Disable, 1 = Enable.
pr_enable_flying_drops <0|1> - Enable flying weapon drops. 0 = Disable, 1 = Enable.
pr_enable_kill_reload <0|1> - Reload current weapon when kill. 0 = Disable, 1 = Enable.
pr_enable_loadout <0|1> - Enable automatic loadout management. 0 = Disable, 1 = Enable.
pr_enable_shoot_open_crate <0|1> - Enable opening Ammo Crate by shooting it. 0 = Disable, 1 = Enable.
pr_enable_special_damage <0|1> - Modify damage when using certain weapons. 0 = Disable, 1 = Enable.
pr_shoot_button_use <0|1|2> - Use button remotely when shooting the button. 0 = Disable, 1 = Enable, 2 = Unlock & Use
]]
_CreateConVar("pr_autojump", "Auto Jump mode. 0 = Off, 1 = Jump Spam (Server Managed).", "0", 0, 1)
_CreateConVar("pr_disable_headcrab", "Disable headcrab detachment from dead zombies. 0 = Enable, 1 = Disable.", "0", 0, 1)
_CreateConVar("pr_enable_additional_pickup", "Enable custom weapon pickup for certain weapons. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_flying_drops", "Enable flying weapon drops. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_kill_reload", "Reload current weapon when kill. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_loadout", "Enable automatic loadout management. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_shoot_open_crate", "Enable opening Ammo Crate by shooting it. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_enable_special_damage", "Modify damage when using certain weapons. 0 = Disable, 1 = Enable.", "0", 0, 1)
_CreateConVar("pr_shoot_button_use", "Use button remotely when shooting the button. 0 = Disable, 1 = Enable, 2 = Unlock & Use", "0", 0, 2)
