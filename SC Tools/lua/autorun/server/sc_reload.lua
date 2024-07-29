--[[
  Commands:
  * sc_reload - Reload configurations
]]
--
local function Reload(_, _, _, _)
  sctools.ReloadConfig(true)
end

concommand.Add("sc_reload", Reload, nil, "Reload configurations.", FCVAR_NONE)
hook.Add("InitPostEntity", "SCTools_LoadConfig", function() sctools.ReloadConfig(true) end)
