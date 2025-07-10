-- TODO: Remove 'redundant-return-value' when unneeded
---@diagnostic disable: redundant-return-value
---@param p Player
hook.Add("PlayerLoadout", "PR_CustomLoadout", function(p)
  if not GetConVar("pr_enable_loadout"):GetBool() then return end
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
    --p:Give("scw_empty")
    --p:SelectWeapon("scw_empty")
    return true
  end
end)

---@param p Player
concommand.Add("pr_loadout", function(p, _, _, _)
  -- Strip
  p:StripWeapons()
  -- GMod Weapons
  p:Give("weapon_physgun")
  p:Give("gmod_tool")
  -- HL2 Weapons
  p:Give("weapon_crowbar")
  p:Give("weapon_physcannon")
  -- SC Weapons
  p:Give("scw_mp5sd")
  p:Give("scw_scar20")
  -- Ammo
  p:GiveAmmo(9999, "SMG1", true)
  p:GiveAmmo(9999, "SMG1_Grenade", true)
  p:GiveAmmo(9999, "XBowBolt", true)
end, nil, "My Loadout", { FCVAR_NONE })
