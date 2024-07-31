local nw = "SCTOOLS_DisconnectMessage"
local g_SinglePlayer = game.SinglePlayer
local g_IsDedicated = game.IsDedicated
local p_GetHumans = player.GetHumans
local s_find = string.find
--
util.AddNetworkString(nw)
--
---@param ent Entity
---@param input string
---@param value string
hook.Add("AcceptInput", "SCTOOLS_DisconnectInput", function(ent, input, _, _, value)
  local class = ent:GetClass()
  local cv = GetConVar("sc_disconnect_mode"):GetBool()
  if (class == "point_clientcommand" or class == "point_servercommand") and input:lower() == "command" and (s_find(value:lower(), "disconnect") or s_find(value:lower(), "startupmenu")) then
    if g_SinglePlayer() then
      -- Singleplayer environment
      if cv then
        RunConsoleCommand("disconnect")
      else
        net.Start(nw)
        net.Send(Entity(1)) ---@diagnostic disable-line: param-type-mismatch
      end
    elseif not g_IsDedicated() then
      -- Multiplayer environment
      for _, p in ipairs(p_GetHumans()) do ---@cast p Player
        net.Start(nw)
        net.Send(p)
      end
    else
      -- Dedicated environment
      -- (Same with above, but reserved for later use)
      for _, p in ipairs(p_GetHumans()) do ---@cast p Player
        net.Start(nw)
        net.Send(p)
      end
    end
  end
end)
