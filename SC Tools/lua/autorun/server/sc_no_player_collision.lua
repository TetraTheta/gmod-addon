--[[
  ConVars:
  * sc_no_player_collision <0|1> - Disable player-to-player collision.
--]]
hook.Add("PlayerTick", "NoPlayerCollision", function(ply, _)
  ---@cast ply Player
  if GetConVar("sc_no_player_collision"):GetInt() == 1 then
    ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    ply:SetAvoidPlayers(false)
  else
    ply:SetCollisionGroup(COLLISION_GROUP_NONE)
    ply:SetAvoidPlayers(true)
  end
end)
