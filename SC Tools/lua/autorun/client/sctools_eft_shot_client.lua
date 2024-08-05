local msgBS = "SCTOOLS_BodyshotEffect"
local msgHS = "SCTOOLS_HeadshotEffect"
--
-- Soundscript won't work in here because CLIENT don't know its own cvar
local function PlaySound(snd, vol)
  local r = math.random(90, 110)
  LocalPlayer():EmitSound(snd, SNDLVL_NORM, r, vol, CHAN_BODY)
end
--
net.Receive(msgHS, function(_, _)
  -- This is non-sense that CLIENT can't read its own cvar
  local effectSnd, effectUI, isArmor, isDead, vol = net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadFloat()
  DevMsgN(Format("effectSnd: %s | effectUI: %s | isArmor: %s | isDead: %s | vol: %F", tostring(effectSnd), tostring(effectUI), tostring(isArmor), tostring(isDead), vol))
  if isArmor then
    if isDead then
      if effectSnd then
        PlaySound("sctools_shot/hs_helmet_dead1.mp3", vol)
      end
      if effectUI then
        DevMsgN("Not implemented yet.")
      end
    else
      if effectSnd then
        PlaySound("sctools_shot/hs_helmet_live1.mp3", vol)
      end
      if effectUI then
        DevMsgN("Not implemented yet.")
      end
    end
  else
    if isDead then
      if effectSnd then
        PlaySound("sctools_shot/hs_helmet_dead1.mp3", vol)
      end
      if effectUI then
        DevMsgN("Not implemented yet.")
      end
    else
      if effectSnd then
        PlaySound("sctools_shot/hs_nohelmet_live" .. math.random(1, 5) .. ".mp3", vol)
      end
      if effectUI then
        DevMsgN("Not implemented yet.")
      end
    end
  end
end)

net.Receive(msgBS, function(_, _)
  -- This is non-sense that CLIENT can't read its own cvar
  local effectSnd, effectUI, isArmor, isDead, vol = net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadFloat()
  DevMsgN(Format("effectSnd: %s | effectUI: %s | isArmor: %s | isDead: %s | vol: %F", tostring(effectSnd), tostring(effectUI), tostring(isArmor), tostring(isDead), vol))
  if isArmor then
    if isDead then
      if effectSnd then
        PlaySound("sctools_shot/hs_helmet_dead1.mp3", vol)
      end
      if effectUI then
        DevMsgN("Not implemented yet.")
      end
    else
      if effectSnd then
        PlaySound("sctools_shot/bs_armor_live" .. math.random(1, 5) .. ".mp3", vol)
      end
      if effectUI then
        DevMsgN("Not implemented yet.")
      end
    end
  else
    if isDead then
      if effectSnd then
        PlaySound("sctools_shot/hs_helmet_dead1.mp3", vol)
      end
      if effectUI then
        DevMsgN("Not implemented yet.")
      end
    else
      if effectSnd then
        PlaySound("sctools_shot/bs_noarmor_live" .. math.random(1, 8) .. ".mp3", vol)
      end
      if effectUI then
        DevMsgN("Not implemented yet.")
      end
    end
  end
end)
