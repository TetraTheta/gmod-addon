local cv = GetConVar("pr_enable_flying_drops")

--[[
################
#     HOOK     #
################
]]
--
hook.Add("OnNPCKilled", "PR_FlyingDrops", function(npc, attacker, _)
  if not cv then cv = GetConVar("pr_enable_flying_drops") end
  if not cv:GetBool() then return end
  -- Antlion Grub isn't NPC!
  if npc:IsValid() and npc:IsNPC() and attacker:IsValid() then
    -- Some custom NPC does not carry weapon
    if npc:GetActiveWeapon():IsValid() then
      npc:DropWeapon(nil, attacker:GetPos())
    end
  end
end)
