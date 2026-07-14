util.AddNetworkString("PR_FixWeaponPickup_Notification")

local target_weapon = {
  weapon_crowbar = true,
  weapon_physcannon = true,
}

---@param wep Entity
local function _EnablePickupSound(wep)
  if not IsValid(wep) then return end
  if not target_weapon[wep:GetClass()] then return end
  wep:SetShouldPlayPickupSound(true)
end

hook.Add("InitPostEntity", "PR_FixWeaponPickup_WorldInit", function()
  for class in pairs(target_weapon) do
    for _, wep in ipairs(ents.FindByClass(class)) do
      _EnablePickupSound(wep)
    end
  end
end)

hook.Add("OnEntityCreated", "PR_FixWeaponPickup_EntityCreation", function(e)
  timer.Simple(0, function()
    _EnablePickupSound(e)
  end)
end)

hook.Add("PlayerCanPickupWeapon", "PR_FixWeaponPickup_Notification", function(ply, wep)
  if not IsValid(ply) or not IsValid(wep) then return end

  local class = wep:GetClass()
  if target_weapon[class] ~= true then return end

  _EnablePickupSound(wep)

  timer.Simple(0, function()
    if not IsValid(ply) or IsValid(wep) or not ply:HasWeapon(class) then return end
    net.Start("PR_FixWeaponPickup_Notification")
    net.WriteString(class)
    net.Send(ply)
  end)
end)
