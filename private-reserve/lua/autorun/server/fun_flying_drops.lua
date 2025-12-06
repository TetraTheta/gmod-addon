--[[
################
#     HOOK     #
################
]]
--
hook.Add("OnNPCKilled", "PR_FlyingDrops", function(npc, attacker, _)
  if not GetConVar("pr_enable_flying_drops"):GetBool() then return end
  -- Antlion Grub isn't NPC!
  if npc:IsValid() and npc:IsNPC() and attacker:IsValid() then npc:DropWeapon(nil, attacker:GetPos()) end
end)
