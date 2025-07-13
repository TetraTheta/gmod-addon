local s_PlaySound = surface.PlaySound
--
--[[
###############
#     NET     #
###############
]]
--
net.Receive("SCTOOLS_GiveCurrentAmmoSound", function(_, _) if net.ReadBool() then s_PlaySound("/items/ammo_pickup.wav") end end)
