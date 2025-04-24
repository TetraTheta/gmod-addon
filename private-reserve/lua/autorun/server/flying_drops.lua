hook.Add("OnNPCKilled", "FlyingDrops", function(npc, attacker, _)
  if npc:IsValid() and attacker:IsValid() then
    npc:DropWeapon(nil, attacker:GetPos())
  end
end)
