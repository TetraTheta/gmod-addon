--[[
  Admin Weapon
]]
sound.Add({
  name = "SCAW.Base.Explosion",
  channel = CHAN_WEAPON,
  volume = 0.15,
  level = SNDLVL_GUNFIRE,
  pitch = 100,
  sound = ")weapons/awp/awp1.wav"
})

sound.Add({
  name = "SCAW.Base.Airboat",
  channel = CHAN_WEAPON,
  volume = 0.35,
  level = SNDLVL_GUNFIRE,
  pitch = 100,
  sound = {")weapons/airboat/airboat_gun_lastshot1.wav", ")weapons/airboat/airboat_gun_lastshot2.wav"}
})

sound.Add({
  name = "SCAW.Base.CombineBall1",
  channel = CHAN_WEAPON,
  volume = 0.35,
  level = SNDLVL_GUNFIRE,
  pitch = 100,
  sound = ")weapons/ar2/ar2_altfire.wav"
})

sound.Add({
  name = "SCAW.Base.CombineBall2",
  channel = CHAN_WEAPON,
  volume = 0.35,
  level = SNDLVL_GUNFIRE,
  pitch = 100,
  sound = ")weapons/physcannon/energy_bounce1.wav"
})

sound.Add({
  name = "SCAW.Base.Grenade",
  channel = CHAN_WEAPON,
  volume = 0.15,
  level = SNDLVL_GUNFIRE,
  pitch = 100,
  sound = ")weapons/grenade/tick1.wav"
})

--[[
  Pistol
]]
sound.Add({
  name = "SCW.Pistol.Primary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = {95, 105},
  sound = ")weapons/m4a1/m4a1-1.wav"
})

--[[
  MP5SD
]]
sound.Add({
  name = "SCW.MP5SD.Primary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = {95, 105},
  sound = ")weapons/scw_mp5sd/fire.mp3"
})

sound.Add({
  name = "SCW.MP5SD.Secondary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = 100,
  sound = "weapons/grenade_launcher1.wav"
})

sound.Add({
  name = "SCW.MP5SD.Reload",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = {95, 105},
  sound = ")weapons/scw_mp5sd/reload.mp3"
})

--[[
  SCAR20
]]
sound.Add({
  name = "SCW.SCAR20.Primary",
  channel = CHAN_WEAPON, -- CHAN_STATIC
  volume = 1.0,
  level = SNDLVL_95dB, -- 93
  pitch = 100,
  sound = {")weapons/scw_scar20/scar20_01.mp3", ")weapons/scw_scar20/scar20_02.mp3", ")weapons/scw_scar20/scar20_03.mp3"}
})

sound.Add({
  name = "SCW.SCAR20.BoltBack",
  channel = CHAN_ITEM,
  volume = 1.0,
  level = SNDLVL_65dB,
  pitch = 100,
  sound = "weapons/scw_scar20/scar20_boltback.mp3"
})

sound.Add({
  name = "SCW.SCAR20.BoltForward",
  channel = CHAN_ITEM,
  volume = 1.0,
  level = SNDLVL_65dB,
  pitch = 100,
  sound = "weapons/scw_scar20/scar20_boltforward.mp3"
})

sound.Add({
  name = "SCW.SCAR20.ClipIn",
  channel = CHAN_ITEM,
  volume = 1.0,
  level = SNDLVL_65dB,
  pitch = 100,
  sound = "weapons/scw_scar20/scar20_clipin.mp3"
})

sound.Add({
  name = "SCW.SCAR20.ClipOut",
  channel = CHAN_ITEM,
  volume = 1.0,
  level = SNDLVL_65dB,
  pitch = 100,
  sound = "weapons/scw_scar20/scar20_clipout.mp3"
})

sound.Add({
  name = "SCW.SCAR20.ClipTouch",
  channel = CHAN_ITEM,
  volume = 1.0,
  level = SNDLVL_65dB,
  pitch = 100,
  sound = "weapons/scw_scar20/scar20_cliptouch.mp3"
})

sound.Add({
  name = "SCW.SCAR20.Draw",
  channel = CHAN_ITEM,
  volume = 0.5,
  level = SNDLVL_65dB,
  pitch = 100,
  sound = "weapons/scw_scar20/scar20_draw.mp3"
})

sound.Add({
  name = "SCW.SCAR20.Zoom",
  channel = CHAN_ITEM,
  volume = 1.0,
  level = SNDLVL_75dB,
  pitch = 100,
  sound = "weapons/scw_scar20/zoom.mp3"
})
