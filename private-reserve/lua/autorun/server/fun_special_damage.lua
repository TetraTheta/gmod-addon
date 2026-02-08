local band = bit.band
--
local cv = GetConVar("pr_enable_special_damage")
--
local headcrabs = {
  npc_headcrab = true,
  npc_headcrab_black = true,
  npc_headcrab_fast = true,
  npc_headcrab_poison = true,
}

local myWeapons = {
  scw_mp5sd = true,
  scw_scar20 = true,
}

---@param dmg CTakeDamageInfo
---@return Player
local function _CheckPlayer(dmg)
  local attacker = dmg:GetAttacker()
  if attacker:IsValid() and attacker:GetClass() == "player" then
    ---@cast attacker Player
    return attacker
  else
    return NULL
  end
end

---@param e Entity
---@return Weapon
local function _CheckWeapon(e)
  if not (e:IsValid() and (e:IsNPC() or e:IsPlayer())) then return NULL end
  ---@cast e NPC
  local weapon = e:GetActiveWeapon()
  if weapon:IsValid() then
    ---@cast weapon Weapon
    return weapon
  else
    return NULL
  end
end

--
--[[
################
#     HOOK     #
################
]]
--
---@param e NPC
---@param dmg CTakeDamageInfo
hook.Add("EntityTakeDamage", "PR_SpecialDamage", function(e, dmg)
  if not cv then cv = GetConVar("pr_enable_special_damage") end
  if not cv:GetBool() or not e:IsValid() then return end
  local attacker = _CheckPlayer(dmg)
  local weapon = _CheckWeapon(attacker)
  if e:IsPlayer() then
    -- Process damage applied to the player
    -- I don't like being insta-killed by flying objects
    if band(dmg:GetDamageType(), DMG_CRUSH) then
      dmg:SetDamage(1)
      dmg:SetMaxDamage(1)
      dmg:SetDamageForce(dmg:GetDamageForce():GetNormalized())
      -- Setting Damage Force isn't enough
      local vel = e:GetVelocity()
      e:AddEFlags(EFL_NO_DAMAGE_FORCES)
      e:SetMoveType(MOVETYPE_NONE)
      timer.Simple(0.01, function()
        e:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
        e:SetMoveType(e["bNoClip"] and MOVETYPE_NOCLIP or MOVETYPE_WALK)
        e:SetVelocity(vel - e:GetVelocity())
      end)
    end
  else
    -- Special damage is for SC Weapons (Non-admin)
    if not myWeapons[weapon] then return end
    local cls = e:GetClass()
    if cls == "npc_manhack" or headcrabs[cls] then
      -- Insta-kill Manhacks and headcrabs
      dmg:SetDamage(1000)
    elseif cls == "item_item_crate" then
      -- Insta-break Item Crates
      dmg:SetDamage(1000)
    elseif cls == "npc_turret_floor" then
      -- Fling away combine turrets
      local v = attacker:GetAimVector() * 10000000
      local pos = dmg:GetDamagePosition()
      e:GetPhysicsObject():ApplyForceOffset(v, pos)
    end
  end
end)

--
hook.Add("PlayerNoClip", "PR_SpecialDamage_NoClip_Detect", function(p, nc) p["bNoClip"] = nc end)
