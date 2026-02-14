-- Send required files to client
AddCSLuaFile()
--
SWEP.Base = "scaw_mp5"
SWEP.Category = "SC Admin Weapon"
SWEP.IconOverride = "materials/entities/scaw_mp5_clean.png"
SWEP.Instructions = "Click to shoot, Reload to change secondary fire mode. This weapon won't create bullet hole."
SWEP.PrintName = "Admin MP5 (Clean)"
SWEP.Purpose = "Yet Another Admin MP5"
SWEP.Slot = 2
SWEP.SlotPos = 3
SWEP.Spawnable = true
--
function SWEP:DoImpactEffect(_, _)
  return true
end
