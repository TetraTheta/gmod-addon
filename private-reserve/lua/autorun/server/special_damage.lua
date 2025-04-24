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

---@param e Entity
local function _CheckWeapon(e)
  ---@cast e NPC
  if e:IsValid() and (e:IsNPC() or e:IsPlayer()) and e:GetActiveWeapon():IsValid() then
    return e:GetActiveWeapon()
  else
    return NULL
  end
end

local headcrabs = {
  npc_headcrab = true,
  npc_headcrab_black = true,
  npc_headcrab_fast = true,
  npc_headcrab_poison = true,
}

---@param e NPC
---@param dmg CTakeDamageInfo
hook.Add("EntityTakeDamage", "SpecialDamage", function(e, dmg)
  -- Sanitize attacker and weapon
  if not e:IsValid() then return end
  local attacker = _CheckPlayer(dmg)
  local weapon = _CheckWeapon(attacker)
  -- Process damage
  if weapon:IsValid() and (weapon:GetClass() == "scw_mp5sd" or weapon:GetClass() == "scw_scar20") then
    -- MP5SD
    local cls = e:GetClass()
    if cls == "npc_manhack" or headcrabs[cls] then
      -- I hate manhack and headcrabs
      dmg:SetDamage(1000)
    elseif cls == "item_item_crate" then
      -- Insta-break item crate
      dmg:SetDamage(1000)
    elseif cls == "npc_turret_floor" then
      -- Fling away combine turrets
      local v = attacker:GetAimVector() * 10000000
      local pos = dmg:GetDamagePosition()
      e:GetPhysicsObject():ApplyForceOffset(v, pos)
    else
      -- Increase damage by 2
      dmg:SetDamage(dmg:GetDamage() * 2)
    end
  else
    return
  end
end)
