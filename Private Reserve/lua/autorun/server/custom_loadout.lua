---@param p Player
hook.Add("PlayerLoadout", "CustomLoadout", function(p)
  local c = GetConVar("sbox_weapons"):GetBool()
  if c then
    p:RemoveAllAmmo()
    -- Ammo
    p:GiveAmmo(256, "Pistol", true)
    p:GiveAmmo(256, "SMG1", true)
    p:GiveAmmo(5, "Grenade", true)
    p:GiveAmmo(64, "Buckshot", true)
    p:GiveAmmo(32, "357", true)
    p:GiveAmmo(32, "XBowBolt", true)
    p:GiveAmmo(6, "AR2AltFire", true)
    p:GiveAmmo(100, "AR2", true)
    -- Weapon
    p:Give("weapon_crowbar")
    p:Give("weapon_pistol")
    p:Give("weapon_smg1")
    p:Give("weapon_frag")
    p:Give("weapon_physcannon")
    p:Give("weapon_crossbow")
    p:Give("weapon_shotgun")
    p:Give("weapon_357")
    p:Give("weapon_rpg")
    p:Give("weapon_ar2")
    return true
  else
    p:RemoveAllAmmo()
    -- Weapon
    p:Give("gmod_tool")
    p:Give("weapon_physgun")
    p:Give("weapon_emptyhands")
    p:SetActiveWeapon(NULL)
    return true
  end
end)
