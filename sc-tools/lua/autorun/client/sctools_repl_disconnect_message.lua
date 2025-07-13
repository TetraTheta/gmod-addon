local n_AddLegacy = notification.AddLegacy
local s_PlaySound = surface.PlaySound
--
--[[
###############
#     NET     #
###############
]]
--
net.Receive("SCTOOLS_DisconnectMessage", function(_, _)
  local msg = net.ReadString()
  s_PlaySound("garrysmod/content_downloaded.wav")
  n_AddLegacy(msg, NOTIFY_HINT, 5)
end)
