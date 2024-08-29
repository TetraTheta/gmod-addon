-- Send required files to client
AddCSLuaFile()
--
SWEP.Base = "scw_base"
SWEP.Category = "SC Weapon"
SWEP.IconOverride = "materials/entities/scw_mp5sd.png"
SWEP.Instructions = "Click to shoot, Right-click to fire SMG Grenade."
SWEP.PrintName = "MP5SD"
SWEP.Purpose = "Yet Another MP5SD"
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_scaw_mp5sd.mdl"
SWEP.WepSelectIcon = CLIENT and surface.GetTextureID("weapons/scaw_mp5sd") or ""
SWEP.WorldModel = "models/weapons/w_scaw_mp5sd.mdl"
SWEP.Config_HoldType = "ar2"
SWEP.Primary.CFG_Sound = "SCW.MP5SD.Primary"

--
util.PrecacheModel(SWEP.ViewModel)
util.PrecacheModel(SWEP.WorldModel)
--
sound.Add({
  name = "SCW.MP5SD.Primary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = {95, 105},
  sound = ")weapons/scaw_mp5sd/fire.mp3"
})
