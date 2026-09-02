-- Play pickup sound and show notification for some weapon (CLIENT)
net.Receive("PR_FixWeaponPickup_Notification", function()
  local class = net.ReadString()
  local show_notification = net.ReadBool()
  timer.Simple(0, function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then return end

    local wep = ply:GetWeapon(class)
    if not IsValid(wep) then return end

    if show_notification then GAMEMODE:HUDWeaponPickedUp(wep) end
    surface.PlaySound("items/ammo_pickup.wav")
  end)
end)
