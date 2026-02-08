local nw = "SCTOOLS_DisconnectMessage"
local msg = "MAP ENDED"
local g_SinglePlayer = game.SinglePlayer
local g_IsDedicated = game.IsDedicated
local p_GetHumans = player.GetHumans
local s_find = string.find
--
local cv = GetConVar("sc_disconnect_mode")
--
util.AddNetworkString(nw)
--[[
################
#     HOOK     #
################
]]
--
hook.Add("AcceptInput", "SCTOOLS_DisconnectInput", function(ent, input, _, _, value)
  local class = ent:GetClass()
  local cvv = cv:GetBool()
  if (class == "point_clientcommand" or class == "point_servercommand") and input:lower() == "command" and (s_find(value:lower(), "disconnect") or s_find(value:lower(), "startupmenu")) then
    if g_SinglePlayer() then
      -- Singleplayer environment
      if cvv then
        RunConsoleCommand("disconnect")
      else
        net.Start(nw)
        net.WriteString(msg)
        net.Send(Entity(1)) ---@diagnostic disable-line: param-type-mismatch
      end
    elseif not g_IsDedicated() then
      -- Multiplayer environment
      for _, p in ipairs(p_GetHumans()) do ---@cast p Player
        if cvv and not p:IsListenServerHost() then
          p:Kick(msg)
        else
          net.Start(nw)
          net.WriteString(msg)
          net.Send(p)
        end
      end
    else
      -- Dedicated environment
      for _, p in ipairs(p_GetHumans()) do ---@cast p Player
        if cvv then
          p:Kick(msg)
        else
          net.Start(nw)
          net.WriteString(msg)
          net.Send(p)
        end
      end
    end
  end
end)
