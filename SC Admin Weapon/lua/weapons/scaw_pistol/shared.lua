--DEFINE_BASECLASS("scaw_base")
SWEP.Base = "scaw_base"
--
SWEP.Instructions = "Click to shoot, Reload to change secondary fire mode."
SWEP.PrintName = "Admin Pistol"
SWEP.Purpose = "Yet Another Admin Pistol"
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_scaw_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_scaw_pistol.mdl"
SWEP.Config_HoldType = "pistol"
--
SWEP.Primary.CFG_Sound = "SCAW.Pistol.Primary"
--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)
--
sound.Add({
  name = "SCAW.Pistol.Primary",
  channel = CHAN_WEAPON,
  volumn = 1.0,
  level = SNDLVL_70dB,
  pitch = {95, 105},
  sound = ")weapons/m4a1/m4a1-1.wav"
})
