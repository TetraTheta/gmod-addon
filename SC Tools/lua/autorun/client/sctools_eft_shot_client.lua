local msgBS = "SCTOOLS_BodyshotEffect"
local msgHS = "SCTOOLS_HeadshotEffect"
--
local EFF_SND = 1
local EFF_UI = 2
--
local CAT_ANIMAL = 0
local CAT_ANTLION = 1
local CAT_HUMANOID = 2
local CAT_ROBOT = 3
local CAT_SYNTH = 4
--
-- Soundscript won't work in here because CLIENT don't know its own cvar
local function _GetCategory(cat)
  if cat == CAT_ANIMAL then
    return "Animal"
  elseif cat == CAT_ANTLION then
    return "Antlion"
  elseif cat == CAT_HUMANOID then
    return "Humanoid"
  elseif cat == CAT_ROBOT then
    return "Robot"
  elseif cat == CAT_SYNTH then
    return "Synth"
  end
end

---@param snd string
---@param vol number
local function PlaySound(snd, vol)
  local r = math.random(90, 110)
  LocalPlayer():EmitSound(snd, SNDLVL_NORM, r, vol, CHAN_BODY)
  DevMsgN(Format("Playing '%s'", snd))
end

---@param cat integer
---@param armor boolean
---@param death boolean
---@param vol number
local function PlayBodySound(cat, armor, death, vol)
  if death then
    PlaySound(Format("sctools_shot_feedback/kill%d.mp3", math.random(1, 5)), vol)
  else
    if cat == CAT_ANIMAL then
      PlaySound(Format("sctools_shot_feedback/humanoid_body_noarmor_live%d.mp3", math.random(1, 8)), vol)
    elseif cat == CAT_ANTLION then
      PlaySound(Format("sctools_shot_feedback/antlion_body_live%d.mp3", math.random(1, 4)), vol)
    elseif cat == CAT_HUMANOID then
      if armor then
        PlaySound(Format("sctools_shot_feedback/humanoid_body_armor_live%d.mp3", math.random(1, 5)), vol)
      else
        PlaySound(Format("sctools_shot_feedback/humanoid_body_noarmor_live%d.mp3", math.random(1, 8)), vol)
      end
    elseif cat == CAT_ROBOT then
      PlaySound(Format("sctools_shot_feedback/robot_body_live%d.mp3", math.random(1, 6)), vol)
    elseif cat == CAT_SYNTH then
      PlaySound(Format("sctools_shot_feedback/synth_body_live%d.mp3", math.random(1, 6)), vol)
    end
  end
end

---@param armor boolean
---@param death boolean
---@param vol number
local function PlayHeadSound(armor, death, vol)
  -- Only available if cat is CAT_HUMANOID and
  if death then
    PlaySound(Format("sctools_shot_feedback/kill%d.mp3", math.random(1, 5)), vol)
    PlaySound("sctools_shot_feedback/humanoid_head_armor_dead1.mp3", vol)
  else
    if armor then
      PlaySound("sctools_shot_feedback/humanoid_head_armor_live1.mp3", vol)
    else
      PlaySound(Format("sctools_shot_feedback/humanoid_head_noarmor_live%d.mp3", math.random(1, 5)), vol)
    end
  end
end

--
net.Receive(msgBS, function(_, _)
  -- This is non-sense that CLIENT can't read its own cvar
  local cat, cv, armor, death, vol, class = net.ReadUInt(3), net.ReadUInt(3), net.ReadBool(), net.ReadBool(), net.ReadFloat(), net.ReadString()
  local eff_snd = bit.band(cv, EFF_SND) > 0
  local eff_ui = bit.band(cv, EFF_UI) > 0
  DevMsgN(Format("cat: %s (%s) | eff_snd: %s | eff_ui: %s | armor: %s | death: %s | vol: %f", _GetCategory(cat), class, tostring(eff_snd), tostring(eff_ui), tostring(armor), tostring(death), vol))
  --
  if eff_snd then PlayBodySound(cat, armor, death, vol) end
  if eff_ui then DevMsgN("Not implemented yet.") end
end)

net.Receive(msgHS, function(_, _)
  -- This is non-sense that CLIENT can't read its own cvar
  -- Headshot is only available in Humanoid, so checking NPC type isn't necessary.
  local cat, cv, armor, death, vol, class = net.ReadUInt(3), net.ReadUInt(3), net.ReadBool(), net.ReadBool(), net.ReadFloat(), net.ReadString()
  local eff_snd = bit.band(cv, EFF_SND) > 0
  local eff_ui = bit.band(cv, EFF_UI) > 0
  DevMsgN(Format("cat: %s (%s) | eff_snd: %s | eff_ui: %s | armor: %s | death: %s | vol: %f", _GetCategory(cat), class, tostring(eff_snd), tostring(eff_ui), tostring(armor), tostring(death), vol))
  --
  if eff_snd then PlayHeadSound(armor, death, vol) end
  if eff_ui then DevMsgN("Not implemented yet.") end
end)
