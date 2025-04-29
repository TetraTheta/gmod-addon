---@param ent Entity
---@param dmg CTakeDamageInfo
hook.Add("EntityTakeDamage", "SCAW_ExplosionBehavior_ETD", function(ent, dmg)
  if dmg:GetInflictor():GetClass() ~= "env_explosion" then return end

  if GetConVar("scaw_owner_immune_explosion"):GetBool() then
    local attacker = dmg:GetInflictor()
    if IsValid(attacker) then
      local owner = IsValid(attacker:GetCreator()) and attacker:GetCreator() or attacker:GetOwner()
      if owner == ent then return true end
    end
  end
end)
