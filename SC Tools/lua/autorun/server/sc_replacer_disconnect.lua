util.AddNetworkString("SCReplacerDisconnectMessage")
hook.Add("AcceptInput", "SCReplacerDisconnect", function(ent, input, _, _, value)
  local msg = "MAP ENDED"
  if (ent:GetClass() == "point_servercommand" or ent:GetClass() == "point_clientcommand") and input:lower() == "command" and (string.find(value:lower(), "disconnect") or string.find(value:lower(), "startupmenu")) then
    if game.SinglePlayer() then
      -- Singleplayer environment
      local cv = GetConVar("sc_reenable_disconnect"):GetBool()
      if cv then
        RunConsoleCommand("disconnect")
      else
        net.Start("SCReplacerDisconnectMessage")
        net.WriteString(msg)
        -- In Singleplayer, 'Entity(1)' is always player
        ---@diagnostic disable-next-line: param-type-mismatch
        net.Send(Entity(1))
      end
    elseif not game.IsDedicated() then
      -- Multiplayer environment
      for _, p in ipairs(player:GetHumans()) do
        ---@cast p Player
        net.Start("SCReplacerDisconnectMessage")
        net.WriteString(msg)
        net.Send(p)
      end
    else
      -- Dedicated environment
      for _, p in ipairs(player:GetHumans()) do
        ---@cast p Player
        net.Start("SCReplacerDisconnectMessage")
        net.WriteString(msg)
        net.Send(p)
      end
    end
  end
end)
