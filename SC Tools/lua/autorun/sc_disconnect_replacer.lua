if SERVER then
  util.AddNetworkString("DisconnectMessage")
  hook.Add("AcceptInput", "KillserverInsteadofDisconnect", function(ent, input, _, _, value)
    local cv = GetConVar("sc_reenable_disconnect"):GetBool()
    if not cv then return end
    if (ent:GetClass() == "point_servercommand" or ent:GetClass() == "point_clientcommand") and input:lower() == "command" and string.find(value:lower(), "disconnect") then
      if game.SinglePlayer() then
        -- Singleplayer environment
        RunConsoleCommand("disconnect")
      elseif not game.IsDedicated() then
        -- Multiplayer environment
        for _, p in ipairs(player:GetHumans()) do
          ---@cast p Player
          net.Start("DisconnectMessage")
          net.WriteString("The map ended.")
          net.Send(p)
        end
      else
        -- Dedicated environment
        for _, p in ipairs(player:GetHumans()) do
          ---@cast p Player
          net.Start("DisconnectMessage")
          net.WriteString("The map ended.")
          net.Send(p)
        end
      end
    end
  end)
elseif CLIENT then
  net.Receive("DisconnectMessage", function(_, _)
    local str = net.ReadString()
    notification.AddLegacy(str, NOTIFY_HINT, 5)
  end)
end
