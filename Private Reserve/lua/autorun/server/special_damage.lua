---@param dmg CTakeDamageInfo
local function _CheckPlayer(dmg)
  if dmg:GetAttacker():IsValid() and dmg:GetAttacker():GetClass() == "player" then
    return dmg:GetAttacker()
  else
    return NULL
  end
end

---@param e Entity
local function _CheckWeapon(e)
  ---@cast e NPC
  if e:IsValid() and (e:IsNPC() or e:IsPlayer()) and e:GetActiveWeapon():IsValid() then
    return e:GetActiveWeapon()
  else
    return NULL
  end
end

---@param e Entity
---@param dmg CTakeDamageInfo
hook.Add("EntityTakeDamage", "SpecialDamage", function(e, dmg)
  -- Sanitize attacker and weapon
  if not e:IsValid() then return end
  local attacker = _CheckPlayer(dmg)
  local weapon = _CheckWeapon(attacker)
  -- Process damage
  if weapon:IsValid() and weapon:GetClass() == "scw_mp5sd" then
    -- MP5SD
    local cls = e:GetClass()
    if cls == "npc_manhack" then
      dmg:SetDamage(1000)
    elseif cls == "item_item_crate" then
      dmg:SetDamage(1000)
    else
      dmg:SetDamage(dmg:GetDamage() * 2)
    end
  else
    return
  end
end)
