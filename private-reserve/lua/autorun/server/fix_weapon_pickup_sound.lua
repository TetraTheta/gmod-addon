util.AddNetworkString("PR_FixWeaponPickup_Notification")

local target_weapon = {
  weapon_crowbar = true,
  weapon_physcannon = true,
}

---@param wep Entity
local function EnableWeaponPickupSound(wep)
  if not IsValid(wep) then return end
  if not target_weapon[wep:GetClass()] then return end
  wep:SetShouldPlayPickupSound(true)
end

--[[
################
#     HOOK     #
################
]]

hook.Add("InitPostEntity", "PR_FixWeaponPickup_InitPostEntity", function()
  for class in pairs(target_weapon) do
    for _, wep in ipairs(ents.FindByClass(class)) do
      EnableWeaponPickupSound(wep)
    end
  end
end)

hook.Add("OnEntityCreated", "PR_FixWeaponPickup_OnEntityCreated", function(e)
  timer.Simple(0, function() EnableWeaponPickupSound(e) end)
end)

hook.Add("PlayerCanPickupWeapon", "PR_FixWeaponPickup_PlayerCanPickupWeapon", function(ply, wep)
  if not IsValid(ply) or not IsValid(wep) then return end
  local cls = wep:GetClass()
  if target_weapon[cls] ~= true then return end
  EnableWeaponPickupSound(wep)
  timer.Simple(0, function()
    if not IsValid(ply) or not ply:HasWeapon(cls) then return end
    net.Start("PR_FixWeaponPickup_Notification")
    net.WriteString(cls)
    net.Send(ply)
  end)
end)
