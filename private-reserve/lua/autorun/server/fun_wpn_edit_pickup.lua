-- Replace picked up weapon
local cv = GetConVar("pr_edit_weapon_pickup")

---@class PickupWeaponReplacement
---@field ammo_count integer
---@field ammo_type string
---@field target_class string
local weapon_replacements = {
  weapon_ar2 = {
    ammo_count = 256,
    ammo_type = "AR2",
    target_class = "scw_mm_ar2"
  },
  weapon_shotgun = {
    ammo_count = 256,
    ammo_type = "Buckshot",
    target_class = "scw_mm_shotgun"
  },
  weapon_smg1 = {
    ammo_count = 256,
    ammo_type = "SMG1",
    target_class = "scw_mm_smg1"
  }
}
local spawn_menu_gives = {}

--

---@param ply Player
---@param wep_cls string
local function ClearSpawnMenuGive(ply, wep_cls)
  if spawn_menu_gives[ply] == wep_cls then spawn_menu_gives[ply] = nil end
end

---@param ply Player
---@param src_cls string
---@param replacement PickupWeaponReplacement
local function EditPickupWeapon(ply, src_cls, replacement)
  if not IsValid(ply) then return end
  ply:SetSuppressPickupNotices(false)
  if not ply:Alive() or not ply:HasWeapon(src_cls) then return end
  if not ply:HasWeapon(replacement.target_class) then
    local target_wep = ply:Give(replacement.target_class)
    if not IsValid(target_wep) then return end
  end
  local active_wep = ply:GetActiveWeapon()
  if IsValid(active_wep) and active_wep:GetClass() == src_cls then ply:SelectWeapon(replacement.target_class) end
  ply:StripWeapon(src_cls)
  ply:GiveAmmo(replacement.ammo_count, replacement.ammo_type, false)
end

---@param ply Player
---@param wep_cls string
---@param spawn_info table
local function OnPlayerGiveSWEP(ply, wep_cls, spawn_info)
  local spawn_cls = spawn_info.ClassName or wep_cls
  if not weapon_replacements[spawn_cls] then return end
  spawn_menu_gives[ply] = spawn_cls
  timer.Simple(0, function() ClearSpawnMenuGive(ply, spawn_cls) end)
end

---@param wep Weapon
---@param ply Player
local function OnWeaponEquip(wep, ply)
  if not cv then cv = GetConVar("pr_edit_weapon_pickup") end
  if not cv:GetBool() then return end
  local src_cls = wep:GetClass()
  local replacement = weapon_replacements[src_cls]
  if not replacement then return end
  if spawn_menu_gives[ply] == src_cls then
    spawn_menu_gives[ply] = nil
    return
  end
  ply:SetSuppressPickupNotices(true)
  timer.Simple(0, function() EditPickupWeapon(ply, src_cls, replacement) end)
end

--[[
################
#     HOOK     #
################
]]

hook.Add("PlayerGiveSWEP", "PR_EditWeaponPickup_PlayerGiveSWEP", OnPlayerGiveSWEP)
hook.Add("WeaponEquip", "PR_EditWeaponPickup_WeaponEquip", OnWeaponEquip)
