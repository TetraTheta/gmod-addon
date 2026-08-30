-- Play pickup sound and show notification for some weapon (CLIENT)
net.Receive("PR_FixWeaponPickup_Notification", function()
  local class = net.ReadString()
  timer.Simple(0, function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then return end

    local wep = ply:GetWeapon(class)
    if not IsValid(wep) then return end

    GAMEMODE:HUDWeaponPickedUp(wep)
    surface.PlaySound("items/ammo_pickup.wav")
  end)
end)
