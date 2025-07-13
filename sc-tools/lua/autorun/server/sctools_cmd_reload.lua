require("sctools")
--[[
###########################
#     COMMAND EXECUTE     #
###########################
]]
--[[
#################################
#     COMMAND AUTO COMPLETE     #
#################################
]]
--[[
############################
#     COMMAND REGISTER     #
############################
]]
--
concommand.Add("sc_reload", function(_, _, _, _) sctools.ReloadConfig() end, nil, "Reload SC Tools configurations.", {FCVAR_NONE})
