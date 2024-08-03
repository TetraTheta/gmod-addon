local WeaponModes = {
  [1] = "Explosion Mode",
  [2] = "Airboat Gun Mode",
  [3] = "Combine Ball Mode",
  [4] = "Grenade Mode"
}
local function _NetMessage(className)
  net.Receive(className .. "_ChangeMode", function()
    local new = net.ReadUInt(3)
    if new > 4 or new < 1 then return end
    notification.AddLegacy(WeaponModes[new], NOTIFY_UNDO, 2)
    surface.PlaySound("buttons/button15.wav")
  end)
end
--
killicon.AddFont("env_explosion", "HL2MPTypeDeath", "7", Color(255, 80, 0, 255), 0.35)
killicon.AddFont("npc_grenade_frag", "HL2MPTypeDeath", "4", Color(255, 80, 0, 255), 0.56)
--
killicon.AddFont("scaw_pistol", "HL2MPTypeDeath", "-", Color(255, 80, 0, 255), 0.52)
_NetMessage("scaw_pistol")

