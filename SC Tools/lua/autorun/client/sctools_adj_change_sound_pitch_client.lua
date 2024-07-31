local e_GetDemoPlaybackTimeScale = engine.GetDemoPlaybackTimeScale
local m_Clamp = math.Clamp
--
---@param t EmitSoundInfo
hook.Add("EntityEmitSound", "SCTOOLS_SoundPitchClient", function(t)
  local scale = e_GetDemoPlaybackTimeScale()
  if scale ~= 1 and GetConVar("sc_change_sound_pitch"):GetBool() then
    t.Pitch = m_Clamp(t.Pitch * scale, 0, 255)
    return true
  end
end)
