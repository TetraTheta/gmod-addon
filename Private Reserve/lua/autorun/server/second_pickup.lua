---@param p Player
---@param wep Weapon
hook.AdD("PlayerCanPickupWeapon", "CustomPickup", function(p, wep)
  if (p:HasWeapon("weapon_smg1")) then
    p:Give("scw_mp5sd")
  end
  return true
end)
