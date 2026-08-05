-- GLua implementation of MapBase's ambient_generic for map I/O compatibility
if SERVER then AddCSLuaFile() end
---@class ENT : Entity
---@field CSpinCount integer
---@field CSpinUp integer
---@field FadeInSeconds number
---@field FadeOutSeconds number
---@field IsActive boolean
---@field IsLooping boolean
---@field IsPlaying boolean
---@field LfoModPitch number
---@field LfoModVol number
---@field LfoRate number
---@field LfoType integer
---@field MaxRadius number
---@field ParentName string
---@field Pitch integer
---@field PitchStart integer
---@field Radius number
---@field SoundFlags integer
---@field SoundLevel integer
---@field SoundName string
---@field SoundPatch CSoundPatch|nil
---@field SoundSource Entity|nil
---@field SourceEntityName string
---@field SpinDownSeconds number
---@field SpinUpSeconds number
---@field Volume integer
---@field VolumeStart integer
---@field _fade_stop_timer_name string
---@field _finished_timer_name string
DEFINE_BASECLASS("sc_point")
ENT.Base = "sc_point"
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true
ENT.Type = "point"

if CLIENT then return end
--
local REFERENCE_DB_DISTANCE = 36
local SF_AMBIENT_SOUND_EVERYWHERE = 1
local SF_AMBIENT_SOUND_START_SILENT = 16
local SF_AMBIENT_SOUND_NOT_LOOPING = 32
local SNDLVL_NONE = 0 -- 'SNDLVL_*' are not defined in GLua
local SNDLVL_NORM = 75 -- 'SNDLVL_*' are not defined in GLua
local SOUND_FLAGS_MASK = bit.bor(SND_SHOULDPAUSE, SND_IGNORE_PHONEMES, SND_DO_NOT_OVERWRITE_EXISTING_ON_CHANNEL)
local DYNAMIC_PRESETS = {
  { 255, 75, 95, 95, 10, 1, 50, 95, 0, 0, 0, 0, 0 },
  { 255, 85, 70, 88, 10, 1, 20, 88, 0, 0, 0, 0, 0 },
  { 255, 100, 50, 75, 10, 1, 10, 75, 0, 0, 0, 0, 0 },
  { 100, 100, 0, 0, 10, 1, 90, 90, 0, 0, 0, 0, 0 },
  { 100, 100, 0, 0, 10, 1, 80, 80, 0, 0, 0, 0, 0 },
  { 100, 100, 0, 0, 10, 1, 50, 70, 0, 0, 0, 0, 0 },
  { 100, 100, 0, 0, 5, 1, 40, 50, 1, 50, 0, 10, 0 },
  { 100, 100, 0, 0, 5, 1, 40, 50, 1, 150, 0, 10, 0 },
  { 100, 100, 0, 0, 5, 1, 40, 50, 1, 750, 0, 10, 0 },
  { 128, 100, 50, 75, 10, 1, 30, 40, 2, 8, 20, 0, 0 },
  { 128, 100, 50, 75, 10, 1, 30, 40, 2, 25, 20, 0, 0 },
  { 128, 100, 50, 75, 10, 1, 30, 40, 2, 70, 20, 0, 0 },
  { 50, 50, 0, 0, 10, 1, 20, 50, 0, 0, 0, 0, 0 },
  { 70, 70, 0, 0, 10, 1, 20, 50, 0, 0, 0, 0, 0 },
  { 90, 90, 0, 0, 10, 1, 20, 50, 0, 0, 0, 0, 0 },
  { 120, 120, 0, 0, 10, 1, 20, 50, 0, 0, 0, 0, 0 },
  { 180, 180, 0, 0, 10, 1, 20, 50, 0, 0, 0, 0, 0 },
  { 255, 255, 0, 0, 10, 1, 20, 50, 0, 0, 0, 0, 0 },
  { 200, 75, 90, 90, 10, 1, 50, 90, 2, 100, 20, 0, 0 },
  { 255, 75, 97, 90, 10, 1, 50, 90, 1, 40, 50, 0, 0 },
  { 100, 100, 0, 0, 10, 1, 30, 50, 3, 15, 20, 0, 0 },
  { 160, 160, 0, 0, 10, 1, 50, 50, 3, 500, 25, 0, 0 },
  { 255, 75, 88, 0, 10, 1, 40, 0, 0, 0, 0, 0, 5 },
  { 200, 20, 95, 70, 10, 1, 70, 70, 3, 20, 50, 0, 0 },
  { 180, 100, 50, 60, 10, 1, 40, 60, 2, 90, 100, 100, 0 },
  { 60, 60, 0, 0, 10, 1, 40, 70, 3, 80, 20, 50, 0 },
  { 128, 90, 10, 10, 10, 1, 20, 40, 1, 5, 10, 20, 0 }
}
--
---@param value number
---@param min_value number
---@param max_value number
---@return number
local function ClampNumber(value, min_value, max_value)
  return math.Clamp(value, min_value, max_value)
end

---@param lfo_type integer
---@param lfo_rate number
---@return number
local function LfoMultiplier(lfo_type, lfo_rate)
  local phase = CurTime() * math.max(lfo_rate, 1) * 0.01
  if lfo_type == 1 then return math.floor(phase) % 2 == 0 and 255 or 0 end
  if lfo_type == 3 then return math.random(0, 255) end
  return 255 - math.abs((phase % 2) - 1) * 255
end

---@param value string|nil
---@param fallback number
---@return number
local function NumberFromString(value, fallback)
  if not isstring(value) then return fallback end
  ---@cast value string
  return tonumber(value) or fallback
end

---@param radius number
---@param play_everywhere boolean
---@return integer
local function SoundLevelFromRadius(radius, play_everywhere)
  if radius <= 0 or play_everywhere then return SNDLVL_NONE end
  return math.floor(40 + 20 * math.log10(radius / REFERENCE_DB_DISTANCE))
end

---@return nil
function ENT:Initialize()
  self:SetSolid(SOLID_NONE)
  self:SetMoveType(MOVETYPE_NONE)
  self.SpawnFlags = self.SpawnFlags or self:GetSpawnFlags()
  self.IsLooping = bit.band(self.SpawnFlags, SF_AMBIENT_SOUND_NOT_LOOPING) == 0
  self.IsActive = false
  self.IsPlaying = false
  self.Radius = self.Radius or 1250
  self.SoundLevel = SoundLevelFromRadius(self.Radius, bit.band(self.SpawnFlags, SF_AMBIENT_SOUND_EVERYWHERE) ~= 0)
  self:SCInitSoundState()
  self:SCApplyParent()
  if self.SoundName == nil or self.SoundName == "" then
    ErrorNoHalt("[ERROR] [ambient_generic] Empty ambient_generic at ", tostring(self:GetPos()), "\n")
    self:Remove()
    return
  end
  util.PrecacheSound(self.SoundName)
  if bit.band(self.SpawnFlags, SF_AMBIENT_SOUND_START_SILENT) == 0 then
    self:SCPlaySound(self, self)
  end
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputFadeIn(activator, caller, data)
  self.FadeInSeconds = ClampNumber(NumberFromString(data, 0), 0, 100)
  self:SCCancelFadeStop()
  if self.SoundPatch ~= nil then
    self.SoundPatch:ChangeVolume(self.Volume * 0.1, self.FadeInSeconds)
  end
end

---@param activator Entity
---@param caller Entity
---@param data string
---@return nil
function ENT:InputFadeOut(activator, caller, data)
  self.FadeOutSeconds = ClampNumber(NumberFromString(data, 0), 0, 100)
  if self.SoundPatch ~= nil then
    self.SoundPatch:FadeOut(self.FadeOutSeconds)
    self:SCCancelSoundFinished()
    self:SCScheduleFadeStop()
  end
end

---@param activator Entity
---@param caller Entity
---@return nil
function ENT:InputPlaySound(activator, caller)
  if self.IsActive then return end
  self:SCStopSound()
  self:SCPlaySound(activator, caller)
end

---@param _activator Entity
---@param _caller Entity
---@param data string
---@return nil
function ENT:InputPitch(_activator, _caller, data)
  self.Pitch = ClampNumber(NumberFromString(data, self.Pitch), 1, 255)
  if self.SoundPatch ~= nil then
    self.SoundPatch:ChangePitch(self.Pitch, 0)
  end
end

---@param _activator Entity
---@param _caller Entity
---@param data string
---@return nil
function ENT:InputSetSound(_activator, _caller, data)
  self:SCStopSound()
  self.SoundName = data or ""
  if self.SoundName ~= "" then util.PrecacheSound(self.SoundName) end
end

---@return nil
function ENT:InputStopSound()
  self:SCFadeOrStopSound()
end

---@param activator Entity
---@param caller Entity
---@return nil
function ENT:InputToggleSound(activator, caller)
  self:SCResolveSoundSource(activator, caller)
  if self.IsActive then
    if self.CSpinUp > 0 and self.CSpinCount < self.CSpinUp then
      self.CSpinCount = self.CSpinCount + 1
      self.Pitch = math.min(self.Pitch + math.floor((255 - self.PitchStart) / self.CSpinUp), 255)
      if self.SoundPatch ~= nil then self.SoundPatch:ChangePitch(self.Pitch, self.SpinUpSeconds) end
    else
      self:SCFadeOrStopSound()
    end
  else
    self:SCPlaySound(activator, caller)
  end
end

---@param _activator Entity
---@param _caller Entity
---@param data string
---@return nil
function ENT:InputVolume(_activator, _caller, data)
  self.Volume = ClampNumber(NumberFromString(data, self.Volume), 0, 10)
  if self.SoundPatch ~= nil then
    self.SoundPatch:ChangeVolume(self.Volume * 0.1, 0)
  end
end

---@param key string
---@param value string
---@return nil
function ENT:SCApplyKeyValue(key, value)
  local lkey = key:lower()
  if lkey == "cspinup" then
    self.CSpinUp = ClampNumber(NumberFromString(value, 0), 0, 100)
  elseif lkey == "fadein" or lkey == "fadeinsecs" then
    self.FadeInSeconds = ClampNumber(NumberFromString(value, 0), 0, 100)
  elseif lkey == "fadeout" or lkey == "fadeoutsecs" then
    self.FadeOutSeconds = ClampNumber(NumberFromString(value, 0), 0, 100)
  elseif lkey == "health" then
    self.Volume = ClampNumber(NumberFromString(value, 10), 0, 10)
  elseif lkey == "lfomodpitch" then
    self.LfoModPitch = ClampNumber(NumberFromString(value, 0), 0, 100)
  elseif lkey == "lfomodvol" then
    self.LfoModVol = ClampNumber(NumberFromString(value, 0), 0, 100)
  elseif lkey == "lforate" then
    self.LfoRate = ClampNumber(NumberFromString(value, 0), 0, 1000)
  elseif lkey == "lfotype" then
    self.LfoType = math.floor(ClampNumber(NumberFromString(value, 0), 0, 4))
  elseif lkey == "message" then
    self.SoundName = value
  elseif lkey == "parentname" then
    self.ParentName = value
  elseif lkey == "pitch" then
    self.Pitch = math.floor(ClampNumber(NumberFromString(value, 100), 1, 255))
  elseif lkey == "pitchstart" then
    self.PitchStart = math.floor(ClampNumber(NumberFromString(value, 100), 0, 255))
  elseif lkey == "preset" then
    self.Preset = math.floor(ClampNumber(NumberFromString(value, 0), 0, 27))
  elseif lkey == "radius" then
    self.Radius = math.max(NumberFromString(value, 1250), 0)
  elseif lkey == "soundflags" then
    self.SoundFlags = bit.band(math.floor(NumberFromString(value, 0)), SOUND_FLAGS_MASK)
  elseif lkey == "sourceentityname" then
    self.SourceEntityName = value
  elseif lkey == "spindown" then
    self.SpinDownSeconds = ClampNumber(NumberFromString(value, 0), 0, 100)
  elseif lkey == "spinup" then
    self.SpinUpSeconds = ClampNumber(NumberFromString(value, 0), 0, 100)
  elseif lkey == "spawnflags" then
    self.SpawnFlags = math.floor(NumberFromString(value, 0))
  elseif lkey == "targetname" then
    self:SetName(value)
  elseif lkey == "volstart" then
    self.VolumeStart = ClampNumber(NumberFromString(value, 0), 0, 10)
  else
    self[key] = value
  end
end

---@return nil
function ENT:OnRemove()
  self:SCStopSound()
end

---@return boolean|nil
function ENT:Think()
  if not self.IsPlaying or self.SoundPatch == nil then return nil end
  if self.LfoType == 0 or self.LfoRate <= 0 then return nil end
  self:SCUpdateLfo()
  self:NextThink(CurTime() + 0.2)
  return true
end

---@return integer
function ENT:UpdateTransmitState()
  return TRANSMIT_ALWAYS
end

---@return nil
function ENT:SCApplyPreset()
  local preset = DYNAMIC_PRESETS[self.Preset or 0]
  if preset == nil then return end
  self.Pitch = preset[1]
  self.PitchStart = preset[2]
  self.SpinUpSeconds = preset[3]
  self.SpinDownSeconds = preset[4]
  self.Volume = preset[5]
  self.VolumeStart = preset[6]
  self.FadeInSeconds = preset[7]
  self.FadeOutSeconds = preset[8]
  self.LfoType = preset[9]
  self.LfoRate = preset[10]
  self.LfoModPitch = preset[11]
  self.LfoModVol = preset[12]
  self.CSpinUp = preset[13]
end

---@return nil
function ENT:SCCancelSoundFinished()
  if self._finished_timer_name ~= nil then
    timer.Remove(self._finished_timer_name)
    self._finished_timer_name = nil
  end
end

---@return nil
function ENT:SCCancelFadeStop()
  if self._fade_stop_timer_name ~= nil then
    timer.Remove(self._fade_stop_timer_name)
    self._fade_stop_timer_name = nil
  end
end

---@return nil
function ENT:SCApplyParent()
  if self.ParentName == nil or self.ParentName == "" then return end
  local parent = ents.FindByName(self.ParentName)[1]
  if IsValid(parent) then self:SetParent(parent) end
end

---@return CSoundPatch|nil
function ENT:SCCreateSoundPatch()
  if self.SoundName == nil or self.SoundName == "" then return nil end
  local source = self.SoundSource
  if not IsValid(source) then source = self end
  ---@cast source Entity
  local patch = CreateSound(source, self.SoundName)
  if patch ~= nil then patch:SetSoundLevel(self.SoundLevel or SNDLVL_NORM) end
  return patch
end

---@return nil
function ENT:SCFireSoundFinished()
  self.IsActive = false
  self.IsPlaying = false
  self._finished_timer_name = nil
  self:TriggerOutput("OnSoundFinished", self)
end

---@param sound_name string
---@return number
function ENT:SCGetSoundDuration(sound_name)
  if string.StartsWith(sound_name, "!") then return SentenceDuration(sound_name) end
  return SoundDuration(sound_name)
end

---@return nil
function ENT:SCInitSoundState()
  self.CSpinUp = self.CSpinUp or 0
  self.CSpinCount = self.CSpinCount or 0
  self.FadeInSeconds = self.FadeInSeconds or 0
  self.FadeOutSeconds = self.FadeOutSeconds or 0
  self.LfoModPitch = self.LfoModPitch or 0
  self.LfoModVol = self.LfoModVol or 0
  self.LfoRate = self.LfoRate or 0
  self.LfoType = self.LfoType or 0
  self.Pitch = self.Pitch or 100
  self.PitchStart = self.PitchStart or 100
  self.Preset = self.Preset or 0
  self.SoundFlags = self.SoundFlags or 0
  self.SourceEntityName = self.SourceEntityName or ""
  self.SpinDownSeconds = self.SpinDownSeconds or 0
  self.SpinUpSeconds = self.SpinUpSeconds or 0
  self.Volume = self.Volume or 10
  self.VolumeStart = self.VolumeStart or 0
  self:SCApplyPreset()
end

---@param activator Entity
---@param caller Entity
---@return nil
function ENT:SCPlaySound(activator, caller)
  if self.SoundName == nil or self.SoundName == "" then return end
  self:SCResolveSoundSource(activator, caller)
  self:SCInitSoundState()
  self:SCCancelFadeStop()
  self:SCCancelSoundFinished()
  if self.SoundPatch ~= nil then
    self.SoundPatch:Stop()
    self.SoundPatch = nil
  end
  self.SoundPatch = self:SCCreateSoundPatch()
  if self.SoundPatch == nil then return end
  local start_volume = self.FadeInSeconds > 0 and self.VolumeStart or self.Volume
  local start_pitch = self.SpinUpSeconds > 0 and self.PitchStart or self.Pitch
  self.SoundPatch:PlayEx(start_volume * 0.1, start_pitch)
  if self.FadeInSeconds > 0 then
    self.SoundPatch:ChangeVolume(self.Volume * 0.1, self.FadeInSeconds)
  end
  if self.SpinUpSeconds > 0 then
    self.SoundPatch:ChangePitch(self.Pitch, self.SpinUpSeconds)
  end
  self.CSpinCount = 1
  self.IsActive = self.IsLooping
  self.IsPlaying = true
  if self.LfoType ~= 0 and self.LfoRate > 0 then self:NextThink(CurTime() + 0.2) end
  self:SCScheduleSoundFinished()
end

---@param activator Entity
---@param caller Entity
---@return Entity
function ENT:SCResolveSoundSource(activator, caller)
  local source_name = self.SourceEntityName
  if source_name == "!activator" and IsValid(activator) then
    self.SoundSource = activator
  elseif source_name == "!caller" and IsValid(caller) then
    self.SoundSource = caller
  elseif source_name == "!self" then
    self.SoundSource = self
  elseif isstring(source_name) and source_name ~= "" and not string.StartsWith(source_name, "!") then
    self.SoundSource = ents.FindByName(source_name)[1] or self
  else
    self.SoundSource = self
  end
  return self.SoundSource
end

---@return nil
function ENT:SCScheduleSoundFinished()
  if self.SoundName == nil or self.SoundName == "" then return end
  local duration = self:SCGetSoundDuration(self.SoundName)
  if duration <= 0 then return end
  local timer_name = Format("SCTOOLS_AmbientGenericFinished_%d", self:EntIndex())
  self._finished_timer_name = timer_name
  timer.Create(timer_name, duration, 1, function()
    if IsValid(self) then self:SCFireSoundFinished() end
  end)
end

---@param delay number|nil
---@return nil
function ENT:SCScheduleFadeStop(delay)
  local timer_name = Format("SCTOOLS_AmbientGenericFadeStop_%d", self:EntIndex())
  self:SCCancelFadeStop()
  self._fade_stop_timer_name = timer_name
  timer.Create(timer_name, delay or self.FadeOutSeconds, 1, function()
    if IsValid(self) then self:SCStopSound() end
  end)
end

---@return nil
function ENT:SCFadeOrStopSound()
  if self.SoundPatch == nil then
    self:SCStopSound()
    return
  end
  local stop_delay = math.max(self.FadeOutSeconds or 0, self.SpinDownSeconds or 0)
  if stop_delay <= 0 then
    self:SCStopSound()
    return
  end
  self.IsActive = false
  self:SCCancelSoundFinished()
  if self.FadeOutSeconds > 0 then
    self.SoundPatch:FadeOut(self.FadeOutSeconds)
  end
  if self.SpinDownSeconds > 0 then
    self.SoundPatch:ChangePitch(self.PitchStart, self.SpinDownSeconds)
  end
  self:SCScheduleFadeStop(stop_delay)
end

---@return nil
function ENT:SCStopSound()
  self:SCCancelFadeStop()
  self:SCCancelSoundFinished()
  if self.SoundPatch ~= nil then
    self.SoundPatch:Stop()
    self.SoundPatch = nil
  end
  self.IsActive = false
  self.IsPlaying = false
end

---@return nil
function ENT:SCUpdateLfo()
  if self.SoundPatch == nil then return end
  local lfo_mult = LfoMultiplier(self.LfoType, self.LfoRate)
  if self.LfoModPitch > 0 then
    local pitch = self.Pitch + ((lfo_mult - 128) * self.LfoModPitch) / 100
    self.SoundPatch:ChangePitch(ClampNumber(pitch, 1, 255), 0)
  end
  if self.LfoModVol > 0 then
    local volume = self.Volume * 10 + ((lfo_mult - 128) * self.LfoModVol) / 100
    self.SoundPatch:ChangeVolume(ClampNumber(volume, 0, 100) * 0.01, 0)
  end
end
