hook.Add("EntityTakeDamage", "SpecialDamage", function(e, dmg)
  if not e:IsValid() then return end
  local attacker = NULL
  if dmg:GetAttacker():IsValid() and dmg:GetAttacker():GetClass() == "player" then
    attacker = dmg:GetAttacker()
  else
    return
  end
  if attacker:IsValid() and attacker:GetActiveWeapon():IsValid() and attacker:GetActiveWeapon():GetClass() == "scw_mp5sd" then
    local cls = e:GetClass()
    if cls == "npc_manhack" then
      dmg:SetDamage(1000)
    elseif cls == "item_item_crate" then
      dmg:SetDamage(1000)
    end
  else
    return
  end
end)
