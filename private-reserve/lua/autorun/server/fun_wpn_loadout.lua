-- Weapon loadout
local cv_enable = GetConVar("pr_enable_loadout")
local cv_sbox_weapons = GetConVar("sbox_weapons")

--[[
################
#     HOOK     #
################
]]

---@diagnostic disable: redundant-return-value -- TODO: Remove 'redundant-return-value' when unneeded
---@param p Player
hook.Add("PlayerLoadout", "PR_CustomLoadout", function(p)
  if not cv_enable then cv_enable = GetConVar("pr_enable_loadout") end
  if not cv_sbox_weapons then cv_sbox_weapons = GetConVar("sbox_weapons") end
  if not cv_enable:GetBool() then return end
  if cv_sbox_weapons:GetBool() then
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
    --
    return true
  else
    -- Ammo
    --p:RemoveAllAmmo()
    -- Weapon
    p:Give("gmod_tool")
    p:Give("weapon_physgun")
    --
    return true
  end
end)

--[[
#################
#    COMMAND    #
#################
]]

---@param p Player
local function GivePrivateReserveLoadout(p)
  -- Strip
  p:StripWeapons()
  -- Basic Weapons
  p:EquipSuit()
  p:Give("weapon_physgun")
  p:Give("gmod_tool")
  -- HL2 Weapons
  p:Give("weapon_crowbar")
  p:Give("weapon_physcannon")
  -- SC Admin Weapons
  p:Give("scaw_mp5_clean")
  -- SC Weapons
  p:Give("scw_colt_saa")
  p:Give("scw_mm_smg1")
  p:Give("scw_mm_ar2")
  p:Give("scw_mm_shotgun")
  -- Ammo
  p:GiveAmmo(9999, "357", true)
  p:GiveAmmo(9999, "SMG1", true)
  p:GiveAmmo(9999, "SMG1_Grenade", true)
  p:GiveAmmo(9999, "AR2", true)
  p:GiveAmmo(9999, "AR2AltFire", true)
  p:GiveAmmo(9999, "XBowBolt", true)
  p:GiveAmmo(9999, "Buckshot", true)
  -- Tweak current and previous weapon (No need to worry about prediction, because this works)
  p:SelectWeapon("scw_mm_ar2")
  p:SelectWeapon("scw_mm_shotgun")
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("pr_loadout", function(p, _, _, _) GivePrivateReserveLoadout(p) end, nil, "My Loadout", { FCVAR_NONE })
