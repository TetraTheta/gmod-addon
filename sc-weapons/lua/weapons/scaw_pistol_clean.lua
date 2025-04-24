-- Send required files to client
AddCSLuaFile()
--
SWEP.Base = "scaw_pistol"
SWEP.Category = "SC Admin Weapon"
SWEP.IconOverride = "materials/entities/scaw_pistol_clean.png"
SWEP.Instructions = "Click to shoot, Reload to change secondary fire mode. This weapon won't create bullet hole."
SWEP.PrintName = "Admin Pistol (Clean)"
SWEP.Purpose = "Yet Another Admin Pistol"
SWEP.Slot = 1
SWEP.SlotPos = 3
SWEP.Spawnable = true
--
function SWEP:DoImpactEffect(_, _)
  return true
end
