local cv = GetConVar("pr_enable_shoot_open_crate")

--[[
################
#     HOOK     #
################
]]
--
hook.Add("PostEntityFireBullets", "PR_Shoot_Open_AmmoCrate", function(_, fb)
  if not cv then cv = GetConVar("pr_enable_shoot_open_crate") end
  -- Sanitize attacker and entity
  if not cv:GetBool() or not fb.Trace.Hit then return end
  local target = fb.Trace.Entity
  local attacker = fb.Attacker
  if not (IsValid(target) and IsValid(attacker)) then return end
  ---@cast target Entity
  ---@cast attacker Entity
  if attacker:GetClass() ~= "player" or target:GetClass() ~= "item_ammo_crate" then return end
  target:Use(attacker)
end)
