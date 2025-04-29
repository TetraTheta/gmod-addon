---@param convar string
---@param description string
---@param def string
---@param min number
---@param max number
local function _CreateConVar(convar, description, def, min, max)
  local flags = { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY }
  if not ConVarExists(convar) then CreateConVar(convar, def, flags, description, min, max) end
end
--
_CreateConVar("scaw_mp5sd_default", "Default secondary fire mode of SC Admin MP5SD", "1", 1, 4)
_CreateConVar("scaw_owner_immune_explosion", "Mark owner of the SC Admin Weapon immune to the explosion from Explosion Mode", "0", 0, 1)
_CreateConVar("scaw_pistol_default", "Default secondary fire mode of SC Admin Pistol", "1", 1, 4)
