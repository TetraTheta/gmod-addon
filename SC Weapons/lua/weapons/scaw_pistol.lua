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
SWEP.ViewModel = "models/weapons/c_scaw_pistol.mdl"
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scaw_pistol") or ""
SWEP.WorldModel = "models/weapons/w_scaw_pistol.mdl"
SWEP.Config_HoldType = "pistol"
SWEP.Primary.CFG_Sound = "SCAW.Pistol.Primary"
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)
--
sound.Add({
  name = "SCAW.Pistol.Primary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = {95, 105},
  sound = ")weapons/m4a1/m4a1-1.wav"
})
