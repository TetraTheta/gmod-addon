local headcrabs = {
  npc_headcrab = true,
  npc_headcrab_black = true,
  npc_headcrab_fast = true,
  npc_headcrab_poison = true,
}
local zombies = {
  npc_fastzombie = true,
  npc_fastzombie_torso = true,
  npc_poisonzombie = true,
  npc_zombie = true,
  npc_zombie_torso = true,
  npc_zombine = true,
}

---@param ent Entity
hook.Add("OnEntityCreated", "No_Headcrab", function(ent)
  if not GetConVar("pr_disable_headcrab"):GetBool() then return end
  if IsValid(ent) and ent:IsNPC() and headcrabs[ent:GetClass()] then
    timer.Simple(0, function()
      if not IsValid(ent) then return end
      local parent = ent:GetOwner()
      if IsValid(parent) and zombies[parent:GetClass()] then ent:Remove() end
    end)
  end
end)
