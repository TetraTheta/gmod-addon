-- Send required files to client
AddCSLuaFile()
--
SWEP.Base = "scaw_mp5sd"
SWEP.Category = "SC Admin Weapon"
SWEP.IconOverride = "materials/entities/scaw_mp5sd_clean.png"
SWEP.Instructions = "Click to shoot, Reload to change secondary fire mode. This weapon won't create bullet hole."
SWEP.PrintName = "Admin MP5SD (Clean)"
SWEP.Purpose = "Yet Another Admin MP5SD"
SWEP.Slot = 2
SWEP.SlotPos = 3
SWEP.Spawnable = true
--
function SWEP:DoImpactEffect(_, _)
  return true
end
