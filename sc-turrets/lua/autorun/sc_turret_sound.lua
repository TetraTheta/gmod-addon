sound.Add({
  name = "SCTurret.Retire",
  sound = "npc/sc_turret/retract.mp3",
  channel = CHAN_ITEM,
  level = SNDLVL_70dB,
  volume = 1.0,
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Deploy",
  sound = "npc/sc_turret/deploy.mp3",
  channel = CHAN_BODY,
  level = SNDLVL_70dB,
  volume = 1.0,
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Move",
  sound = "npc/turret_wall/turret_loop1.wav",
  channel = CHAN_ITEM,
  level = SNDLVL_70dB,
  volume = 0.1,
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Activate",
  sound = "npc/sc_turret/active.mp3",
  channel = CHAN_VOICE,
  level = SNDLVL_IDLE,
  volume = 1.0,
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Alert",
  sound = "npc/sc_turret/alert.mp3",
  channel = CHAN_VOICE,
  level = SNDLVL_80dB,
  volume = 0.75, -- 1.0
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Shoot",
  sound = "^npc/sc_turret/shoot1.mp3",
  channel = CHAN_WEAPON,
  level = SNDLVL_GUNFIRE,
  volume = 1.0,
  pitch = 100,
})
sound.Add({
  name = "SCTurret.ShotSounds",
  sound = {
    "^npc/sc_turret/shoot1.mp3",
    "^npc/sc_turret/shoot2.mp3",
    "^npc/sc_turret/shoot3.mp3",
  },
  channel = CHAN_WEAPON,
  level = SNDLVL_GUNFIRE,
  volume = 1.0,
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Die",
  sound = "npc/sc_turret/die.mp3",
  channel = CHAN_VOICE,
  level = SNDLVL_70dB,
  volume = 0.75,
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Retract",
  sound = "npc/sc_turret/retract.mp3",
  channel = CHAN_ITEM,
  level = SNDLVL_70dB,
  volume = 1.0,
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Alarm",
  sound = "npc/sc_turret/alarm.mp3",
  channel = CHAN_VOICE,
  level = SNDLVL_80dB,
  volume = 0.75, -- 1.0
  pitch = 100,
})
sound.Add({
  name = "SCTurret.Ping",
  sound = "npc/sc_turret/ping.mp3",
  channel = CHAN_VOICE,
  level = SNDLVL_IDLE,
  volume = 0.35, -- 0.75
  pitch = 100,
})
sound.Add({
  name = "SCTurret.DryFire",
  sound = "^weapons/shotgun/shotgun_empty.wav",
  channel = CHAN_WEAPON,
  level = SNDLVL_70dB,
  volume = 0.7,
  pitch = { 95, 100 },
})
sound.Add({
  name = "SCTurret.AlarmPing",
  sound = "npc/roller/code2.wav",
  channel = CHAN_VOICE,
  level = SNDLVL_85dB,
  volume = 1.0,
  pitch = 180,
})
sound.Add({
  name = "SCTurret.Destruct",
  sound = "npc/turret_floor/detonate.wav",
  channel = CHAN_BODY,
  level = SNDLVL_95dB,
  volume = 1.0,
  pitch = 100,
})
