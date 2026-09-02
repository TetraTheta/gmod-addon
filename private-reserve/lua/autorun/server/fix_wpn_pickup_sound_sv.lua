-- Play pickup sound and show notification for some weapon (SERVER)
util.AddNetworkString("PR_FixWeaponPickup_Notification")

local target_weapon = {
  weapon_crowbar = true,
  weapon_physcannon = true,
}

--[[
################
#     HOOK     #
################
]]

---@param ply Player
---@param wep Weapon
hook.Add("PlayerCanPickupWeapon", "PR_FixWeaponPickup_PlayerCanPickupWeapon", function(ply, wep)
  if not IsValid(ply) or not IsValid(wep) then return end
  local cls = wep:GetClass()
  if target_weapon[cls] ~= true then return end
  if wep:GetOwner() == ply then return end
  if wep["PR_FixWeaponPickup_IsNotifying"] then return end
  local show_notification = ply:HasWeapon(cls)
  wep["PR_FixWeaponPickup_IsNotifying"] = true
  timer.Simple(0, function()
    if not IsValid(ply) or not ply:HasWeapon(cls) then
      if IsValid(wep) then wep["PR_FixWeaponPickup_IsNotifying"] = nil end
      return
    end
    if IsValid(wep) and wep:GetOwner() ~= ply then
      wep["PR_FixWeaponPickup_IsNotifying"] = nil
      return
    end
    net.Start("PR_FixWeaponPickup_Notification")
    net.WriteString(cls)
    net.WriteBool(show_notification)
    net.Send(ply)
    if IsValid(wep) then wep["PR_FixWeaponPickup_IsNotifying"] = nil end
  end)
end)
