hook.Add("PostEntityFireBullets", "OpenAmmoCrate", function(_, fb)
  if not GetConVar("pr_enable_shoot_open_crate"):GetBool() then return end
  -- Sanitize attacker and entity
  if not fb.Trace.Hit then return end
  local target = fb.Trace.Entity
  local attacker = fb.Attacker
  if not (target:IsValid() and attacker:IsValid()) then return end
  if attacker:GetClass() ~= "player" or target:GetClass() ~= "item_ammo_crate" then return end
  target:Use(attacker)
end)
