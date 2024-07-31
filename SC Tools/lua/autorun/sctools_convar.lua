---@param convar string
---@param description string
---@param def string
---@param min number
---@param max number
local function _CreateClientConVar(convar, description, def, min, max)
  local flags = {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_USERINFO}
  if not ConVarExists(convar) then CreateConVar(convar, def, flags, description, min, max) end
end

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

sc_auto_flashlight <0|1|2> - Automatically enable flashlight to players. 0 = Disable, 1 = Super Admin Only, 2 = All Players.
sc_auto_god_npc <0|1> - Enable GodMode to NPC in campaign maps automatically.
sc_auto_god_sadmin <0|1> - Enable GodMode to player in 'superadmin' usergroup automatically.
sc_boost_speed_modifier <number> - Multiplier for boost speed.
sc_change_sound_pitch <0|1> - Adjust speed/pitch of sound based on game's speed.
sc_disable_obstacle <0|1> - Disable collision check for obstacle objects.
sc_disable_player_collision <0|1> - Disable player-to-player collision.
sc_disconnect_mode <0|1> - Re-enable 'disconnect' console command implemented in map.
sc_remove_effect <0|1> - Entity remove effect type. 0 = Remove, 1 = Dissolve.
]]
_CreateConVar("sc_auto_flashlight", "Automatically enable flashlight to players. 0 = Disable, 1 = Super Admin Only, 2 = All Players.", "0", 0, 2)
_CreateConVar("sc_auto_god_npc", "Enable GodMode to NPC in campaign maps automatically.", "0", 0, 1)
_CreateConVar("sc_auto_god_sadmin", "Enable GodMode to player in 'superadmin' usergroup automatically.", "0", 0, 1)
_CreateConVar("sc_boost_speed_modifier", "Multiplier for boost speed.", "1.0", 1, 10)
_CreateConVar("sc_change_sound_pitch", "Adjust speed/pitch of sound based on game's speed.", "0", 0, 1)
_CreateConVar("sc_disable_obstacle", "Disable collision check for obstacle objects.", "0", 0, 1)
_CreateConVar("sc_disable_player_collision", "Disable player-to-player collision.", "0", 0, 1)
_CreateConVar("sc_disconnect_mode", "Re-enable 'disconnect' console command implemented in map.", "0", 0, 1)
_CreateConVar("sc_remove_effect", "Entity remove effect type. 0 = Remove, 1 = Dissolve.", "0", 0, 1)
--[[
Client ConVar

sc_disable_red_death <0|1> - Remove red overlay from death screen.
]]
_CreateClientConVar("sc_disable_red_death", "Remove red overlay from death screen.", "0", 0, 1)
