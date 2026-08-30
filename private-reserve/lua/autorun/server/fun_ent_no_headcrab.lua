-- Prevent headcrab creation after the death of its host
local cv = GetConVar("pr_disable_headcrab")

local remove_chance = 0.35 -- 35% chance of headcrab removal

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

--[[
################
#     HOOK     #
################
]]

---@param ent Entity
hook.Add("OnEntityCreated", "PR_No_Headcrab", function(ent)
  if not cv then cv = GetConVar("pr_disable_headcrab") end
  if not cv:GetBool() then return end
  local rand = math.random()
  if IsValid(ent) and ent:IsNPC() and headcrabs[ent:GetClass()] and rand <= remove_chance then
    timer.Simple(0, function()
      if not IsValid(ent) then return end
      local parent = ent:GetOwner()
      if IsValid(parent) and zombies[parent:GetClass()] then ent:Remove() end
    end)
  end
end)
