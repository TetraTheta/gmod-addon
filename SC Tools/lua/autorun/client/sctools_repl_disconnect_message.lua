local n_AddLegacy = notification.AddLegacy
local s_PlaySound = surface.PlaySound
--
net.Receive("SCTOOLS_DisconnectMessage", function(_, _)
  s_PlaySound("garrysmod/content_downloaded.wav")
  n_AddLegacy("MAP ENDED", NOTIFY_HINT, 5)
end)
