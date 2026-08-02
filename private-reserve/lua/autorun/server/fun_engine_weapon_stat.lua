local weapon_spread = {
  weapon_pistol = Vector(0.005, 0.005, 0),
  weapon_ar2 = Vector(0.005, 0.005, 0),
  weapon_shotgun = Vector(0.04, 0.04, 0)
}

local sg_plts = {}
local BASE_SHOTGUN_PELLETS = 12

--[[
################
#     HOOK     #
################
]]

---@param ent Entity
---@param data Bullet
hook.Add("EntityFireBullets", "PR_EngineWeaponStat", function(ent, data)
  if not ent:IsPlayer() then return end
  ---@cast ent Player
  local wep = ent:GetActiveWeapon()
  if not IsValid(wep) then return end
  local cls = wep:GetClass()
  -- Modify shotgun pellets
  if cls == "weapon_shotgun" then
    local ct = CurTime()
    if not sg_plts[ent] or sg_plts[ent].last_shot ~= ct then
      local target_pellets = BASE_SHOTGUN_PELLETS
      if ent:KeyDown(IN_ATTACK2) and wep:GetNextSecondaryFire() > ct then
        target_pellets = BASE_SHOTGUN_PELLETS * 2
      end
      sg_plts[ent] = { fired = true, last_shot = ct }
      data.Num = target_pellets
    else
      return false
    end
  end

  if weapon_spread[cls] then
    data.Spread = weapon_spread[cls]
    return true
  end
end)
