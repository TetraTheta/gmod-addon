local cv = GetConVar("sc_disable_red_death")
--[[
################
#     HOOK     #
################
]]
--
---@param name string HUD element name
hook.Add("HUDShouldDraw", "RemoveThatShit", function(name) if name == "CHudDamageIndicator" and cv:GetBool() and LocalPlayer():Health() <= 0 then return false end end)
