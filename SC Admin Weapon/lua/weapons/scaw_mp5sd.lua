-- Send required files to client
AddCSLuaFile()
--
SWEP.Base = "scaw_base"
SWEP.Category = "SC Admin Weapon"
SWEP.IconOverride = "materials/entities/scaw_mp5sd.png"
SWEP.Instructions = "Click to shoot, Reload to change secondary fire mode."
SWEP.PrintName = "Admin MP5SD"
SWEP.Purpose = "Yet Another Admin MP5SD"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_scaw_mp5sd.mdl"
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scaw_mp5sd") or ""
SWEP.WorldModel = "models/weapons/w_scaw_mp5sd.mdl"
SWEP.Config_HoldType = "ar2"
SWEP.Primary.CFG_Sound = "SCAW.MP5SD.Primary"
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)
--
sound.Add({
  name = "SCAW.MP5SD.Primary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = {95, 105},
  sound = ")weapons/scaw_mp5sd/fire.mp3"
})
