-- Send required files to client
AddCSLuaFile()
--
SWEP.Base = "scaw_base"
SWEP.Category = "SC Admin Weapon"
SWEP.IconOverride = "materials/entities/scaw_pistol.png"
SWEP.Instructions = "Click to shoot, Reload to change secondary fire mode."
SWEP.PrintName = "Admin Pistol"
SWEP.Purpose = "Yet Another Admin Pistol"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_scw_pistol.mdl"
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scw_pistol") or ""
SWEP.WorldModel = "models/weapons/w_scw_pistol.mdl"
SWEP.CFG_HoldType = "pistol"
SWEP.Primary.CFG_Sound = "SCW.Pistol.Primary"
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)
--
