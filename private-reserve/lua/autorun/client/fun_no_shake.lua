--[[
#################
#     TIMER     #
#################
]]
--
timer.Create("PR_NoShake", 0.01, 0, function()
  RunConsoleCommand("shake_stop")
end)
