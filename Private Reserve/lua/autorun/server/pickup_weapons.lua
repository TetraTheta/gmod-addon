---@param p Player
---@param wep Weapon
hook.Add("PlayerCanPickupWeapon", "CustomPickup", function(p, wep)
  if (wep:GetClass() == "weapon_smg1") then
    -- if (p:HasWeapon("weapon_smg1")) then
    --   p:Give("scw_mp5sd")
    -- end
    if (not p:HasWeapon("scw_mp5sd")) then
      p:Give("scw_mp5sd")
      p:GiveAmmo(256, "SMG1", true)
      return false
    end
  elseif (wep:GetClass() == "weapon_crowbar") then
    if (not p:HasWeapon("scw_fastcrowbar")) then
      p:Give("scw_fastcrowbar")
      return false
    end
  end
  return true
end)
