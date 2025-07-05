---@param dmg CTakeDamageInfo
---@return Player
local function _CheckPlayer(dmg)
  if dmg:GetAttacker():IsValid() and dmg:GetAttacker():GetClass() == "player" then
    ---@diagnostic disable-next-line: return-type-mismatch
    return dmg:GetAttacker()
  else
    return NULL
  end
end

hook.Add("EntityTakeDamage", "OpenAmmoCrate", function(e, dmg)
  if not GetConVar("pr_enable_shoot_open_crate"):GetBool() then return end
  -- Sanitize attacker
  if not e:IsValid() or e:GetClass() != "item_ammo_crate" then return end
  local attacker = _CheckPlayer(dmg)
  attacker:Use(attacker, e)
end)
