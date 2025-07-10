hook.Add("OnNPCKilled", "FlyingDrops", function(npc, attacker, _)
  if not GetConVar("pr_enable_flying_drops"):GetBool() then return end
  if npc:IsValid() and attacker:IsValid() then
    npc:DropWeapon(nil, attacker:GetPos())
  end
end)
