--[[
################################
#     SC ADMIN WEAPON BASE     #
################################
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
  sound = { ")weapons/airboat/airboat_gun_lastshot1.wav", ")weapons/airboat/airboat_gun_lastshot2.wav" }
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
##################
#     SC MP5     #
##################
]]
sound.Add({
  name = "SCW.MP5.Primary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = { 95, 105 },
  sound = ")weapons/scw_mp5/fire.mp3"
})
sound.Add({
  name = "SCW.MP5.FirstRaise",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = 100,
  sound = ")weapons/scw_mp5/firstraise.mp3"
})
sound.Add({
  name = "SCW.MP5.BoltGrab",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = 100,
  sound = ")weapons/scw_mp5/boltgrab.mp3"
})
sound.Add({
  name = "SCW.MP5.BoltBack",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = 100,
  sound = ")weapons/scw_mp5/boltback.mp3"
})
sound.Add({
  name = "SCW.MP5.MagOut",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = 100,
  sound = ")weapons/scw_mp5/magout.mp3"
})
sound.Add({
  name = "SCW.MP5.MagIn",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = 100,
  sound = ")weapons/scw_mp5/magin.mp3"
})
sound.Add({
  name = "SCW.MP5.BoltRelease",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = 100,
  sound = ")weapons/scw_mp5/boltrelease.mp3"
})
--[[
####################
#     SC MP5SD     #
####################
]]
sound.Add({
  name = "SCW.MP5SD.Primary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = { 95, 105 },
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
  pitch = { 95, 105 },
  sound = ")weapons/scw_mp5sd/reload.mp3"
})
--[[
#####################
#     SC Pistol     #
#####################
]]
sound.Add({
  name = "SCW.Pistol.Primary",
  channel = CHAN_WEAPON,
  volume = 0.4,
  level = SNDLVL_70dB,
  pitch = { 95, 105 },
  sound = ")weapons/m4a1/m4a1-1.wav"
})
--[[
#####################
#     SC SCAR20     #
#####################
]]
sound.Add({
  name = "SCW.SCAR20.Primary",
  channel = CHAN_WEAPON, -- CHAN_STATIC
  volume = 1.0,
  level = SNDLVL_95dB,   -- 93
  pitch = 100,
  sound = { ")weapons/scw_scar20/scar20_01.mp3", ")weapons/scw_scar20/scar20_02.mp3", ")weapons/scw_scar20/scar20_03.mp3" }
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
--[[
###########################
#     SC MMod GENERIC     #
###########################
]]
sound.Add({
  name = "SCW.MM.Generic.Movement1",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_NONE, -- 0, Everywhere
  pitch = 100,
  sound = "weapons/scw_mm_movement/movement1.mp3"
})
sound.Add({
  name = "SCW.MM.Generic.Movement2",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_NONE, -- 0, Everywhere
  pitch = 100,
  sound = "weapons/scw_mm_movement/movement2.mp3"
})
sound.Add({
  name = "SCW.MM.Generic.Movement3",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_NONE, -- 0, Everywhere
  pitch = 100,
  sound = "weapons/scw_mm_movement/movement3.mp3"
})
sound.Add({
  name = "SCW.MM.Generic.Movement4",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_NONE, -- 0, Everywhere
  pitch = 100,
  sound = "weapons/scw_mm_movement/movement4.mp3"
})
sound.Add({
  name = "SCW.MM.Generic.Movement5",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_NONE, -- 0, Everywhere
  pitch = 100,
  sound = "weapons/scw_mm_movement/movement5.mp3"
})
sound.Add({
  name = "SCW.MM.Generic.Movement6",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_NONE, -- 0, Everywhere
  pitch = 100,
  sound = "weapons/scw_mm_movement/movement6.mp3"
})
sound.Add({
  name = "SCW.MM.Generic.Sprint1",
  channel = CHAN_AUTO,
  volume = 0.3,
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = {
    "weapons/scw_mm_movement/sprint1.mp3",
    "weapons/scw_mm_movement/sprint2.mp3",
    "weapons/scw_mm_movement/sprint3.mp3",
    "weapons/scw_mm_movement/sprint4.mp3",
    "weapons/scw_mm_movement/sprint5.mp3",
    "weapons/scw_mm_movement/sprint6.mp3",
    "weapons/scw_mm_movement/sprint7.mp3",
    "weapons/scw_mm_movement/sprint8.mp3",
    "weapons/scw_mm_movement/sprint9.mp3"
  }
})
sound.Add({
  name = "SCW.MM.Generic.Sprint2",
  channel = CHAN_AUTO,
  volume = 0.3,
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = {
    "weapons/scw_mm_movement/sprint9.mp3",
    "weapons/scw_mm_movement/sprint8.mp3",
    "weapons/scw_mm_movement/sprint7.mp3",
    "weapons/scw_mm_movement/sprint6.mp3",
    "weapons/scw_mm_movement/sprint5.mp3",
    "weapons/scw_mm_movement/sprint4.mp3",
    "weapons/scw_mm_movement/sprint3.mp3",
    "weapons/scw_mm_movement/sprint2.mp3",
    "weapons/scw_mm_movement/sprint1.mp3"
  }
})
sound.Add({
  name = "SCW.MM.Generic.Walk1",
  channel = CHAN_AUTO,
  volume = 0.2,
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = {
    "weapons/scw_mm_movement/walk1.mp3",
    "weapons/scw_mm_movement/walk2.mp3",
    "weapons/scw_mm_movement/walk3.mp3",
    "weapons/scw_mm_movement/walk4.mp3",
    "weapons/scw_mm_movement/walk5.mp3",
    "weapons/scw_mm_movement/walk6.mp3",
    "weapons/scw_mm_movement/walk7.mp3",
    "weapons/scw_mm_movement/walk8.mp3"
  }
})
sound.Add({
  name = "SCW.MM.Generic.Walk2",
  channel = CHAN_AUTO,
  volume = 0.2,
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = {
    "weapons/scw_mm_movement/walk8.mp3",
    "weapons/scw_mm_movement/walk7.mp3",
    "weapons/scw_mm_movement/walk6.mp3",
    "weapons/scw_mm_movement/walk5.mp3",
    "weapons/scw_mm_movement/walk4.mp3",
    "weapons/scw_mm_movement/walk3.mp3",
    "weapons/scw_mm_movement/walk2.mp3",
    "weapons/scw_mm_movement/walk1.mp3"
  }
})
--[[
#######################
#     SC MMod AR2     #
#######################
]]
sound.Add({
  name = "SCW.MM.AR2.BoltPull",
  channel = CHAN_WEAPON,
  volume = 0.4, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/bolt_pull.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.Charge",
  channel = CHAN_WEAPON,
  volume = 0.28, -- 0.7
  level = SNDLVL_NORM, -- SNDLVL_75dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/charge.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.Draw",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/draw.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.FidgetPush",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/fidget_push.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.FidgetRotate",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/fidget_rotate.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.MagIn",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/mag_in.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.MagOut",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/mag_out.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.ReloadPush",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/reload_push.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.ReloadRotate",
  channel = CHAN_AUTO,
  volume = 0.4, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/reload_rotate.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.Reload_NPC",
  channel = CHAN_AUTO,
  volume = 1.0,
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/npc_reload.mp3"
})
sound.Add({
  name = "SCW.MM.AR2.Single",
  channel = CHAN_WEAPON,
  volume = 0.3, -- 1.0
  level = SNDLVL_GUNFIRE, -- SNDLVL_140dB
  pitch = { 85, 95 },
  sound = {
    "<weapons/scw_mm_ar2/fire1.mp3",
    "<weapons/scw_mm_ar2/fire2.mp3",
    "<weapons/scw_mm_ar2/fire3.mp3"
  }
})
sound.Add({
  name = "SCW.MM.AR2.Single_NPC",
  channel = CHAN_WEAPON,
  volume = 0.85,
  level = SNDLVL_GUNFIRE, -- SNDLVL_140dB
  pitch = { 95, 105 },
  sound = {
    "<weapons/scw_mm_ar2/dist1.mp3",
    "<weapons/scw_mm_ar2/dist2.mp3",
    "<weapons/scw_mm_ar2/dist3.mp3"
  }
})
sound.Add({
  name = "SCW.MM.AR2.Secondary",
  channel = CHAN_WEAPON,
  volume = 0.4, -- 1.0
  level = SNDLVL_GUNFIRE, -- SNDLVL_140dB
  pitch = 100,
  sound = "<weapons/scw_mm_ar2/secondary_fire.mp3"
})
--[[
########################
#     SC MMod SMG1     #
########################
]]
sound.Add({
  name = "SCW.MM.SMG1.BoltBack",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/bolt_back.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.BoltForward",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/bolt_forward.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.BoltRelease",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/bolt_release.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.ClipHit",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/clip_hit.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.ClipIn",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/clip_in.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.ClipOut",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/clip_out.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.Draw",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/draw.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.GLBack",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/cock_back.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.GLForward",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/cock_forward.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.GripFold",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/grip_fold.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.GripUnfold",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/grip_unfold.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.Reload",
  channel = CHAN_AUTO,
  volume = 0.6, -- 1.0
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/reload.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.Reload_NPC",
  channel = CHAN_AUTO,
  volume = 1.0,
  level = SNDLVL_IDLE, -- SNDLVL_60dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/npc_reload.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.Single",
  channel = CHAN_WEAPON,
  volume = 0.44, -- 0.55
  level = SNDLVL_GUNFIRE, -- SNDLVL_140dB
  pitch = { 95, 105 },
  sound = {
    "<weapons/scw_mm_smg1/fire1.mp3",
    "<weapons/scw_mm_smg1/fire2.mp3",
    "<weapons/scw_mm_smg1/fire3.mp3"
  }
})
sound.Add({
  name = "SCW.MM.SMG1.Single_NPC",
  channel = CHAN_WEAPON,
  volume = 1.0,
  level = SNDLVL_GUNFIRE, -- SNDLVL_140dB
  pitch = { 98, 102 },
  sound = {
    "<weapons/scw_mm_smg1/npc_fire1.mp3",
    "<weapons/scw_mm_smg1/npc_fire2.mp3",
    "<weapons/scw_mm_smg1/npc_fire3.mp3"
  }
})
sound.Add({
  name = "SCW.MM.SMG1.Burst_NPC",
  channel = CHAN_AUTO,
  volume = 1.0,
  level = SNDLVL_GUNFIRE, -- SNDLVL_140dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/fire_burst.mp3"
})
sound.Add({
  name = "SCW.MM.SMG1.Secondary",
  channel = CHAN_WEAPON,
  volume = 0.6, -- 1.0
  level = SNDLVL_GUNFIRE, -- SNDLVL_140dB
  pitch = 100,
  sound = "<weapons/scw_mm_smg1/glauncher.mp3"
})
