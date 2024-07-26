--[[
  Commands:
  * sc_reload - Reload configurations
]]
--
include("autorun/sc_tools_config.lua")
local function Reload(_, _, _, _)
  ReadConfigFiles(true)
end

concommand.Add("sc_reload", Reload, nil, "Reload configurations.", FCVAR_NONE)
