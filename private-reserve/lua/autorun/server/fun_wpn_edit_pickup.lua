-- Replace picked up weapon
local cv = GetConVar("pr_edit_weapon_pickup")

---@param p Player Player
---@param wep Weapon Weapon for picking up
---@param target_class string Additional/Alternative weapon class
---@param is_replacement boolean true: alternative / false: additional
---@param ammo_count number|nil Additional ammo
---@param ammo_type string|nil Additional ammo type
local function EditPickupWeapon(p, wep, target_class, is_replacement, ammo_count, ammo_type)
  if not IsValid(wep) or wep["PR_IsBeingPickedUp"] then return false end
  wep["PR_IsBeingPickedUp"] = true
  if p:HasWeapon(target_class) then
    if ammo_count and ammo_type then
      p:GiveAmmo(ammo_count, ammo_type, false)
    end
    wep:Remove()
    return false
  end
  p:Give(target_class)
  if ammo_count and ammo_type then
    p:GiveAmmo(ammo_count, ammo_type, false)
  end
  return not is_replacement
end

--[[
################
#     HOOK     #
################
]]

hook.Add("PlayerCanPickupWeapon", "PR_AdditionalWeaponPickup", function(p, wep)
  if not cv then cv = GetConVar("pr_edit_weapon_pickup") end
  if not cv:GetBool() then return end
  local cls = wep:GetClass()

  if cls == "weapon_smg1" then
    -- 'weapon_smg1' -> 'scw_mm_smg1'
    return EditPickupWeapon(p, wep, "scw_mm_smg1", true, 256, "SMG1")
  elseif cls == "weapon_ar2" then
    -- 'weapon_ar2' -> 'scw_mm_ar2'
    return EditPickupWeapon(p, wep, "scw_mm_ar2", true, 256, "AR2")
  elseif cls == "weapon_shotgun" then
    -- 'weapon_shotgun' -> 'scw_mm_shotgun'
    return EditPickupWeapon(p, wep, "scw_mm_shotgun", true, 256, "Buckshot")
  end
end)
