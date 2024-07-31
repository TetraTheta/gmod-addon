---@param p Player
hook.Add("PlayerTick", "SCTOOLS_DisableP2PCollision", function(p, _)
  if GetConVar("sc_disable_player_collision"):GetBool() then
    p:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    p:SetAvoidPlayers(false)
  else
    p:SetCollisionGroup(COLLISION_GROUP_NONE)
    p:SetAvoidPlayers(true)
  end
end)
