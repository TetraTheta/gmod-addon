local cv_sc_pitch = GetConVar("sc_change_sound_pitch")
--[[
################
#     HOOK     #
################
]]
--
---@param t EmitSoundInfo
hook.Add("EntityEmitSound", "SCTOOLS_SoundPitchClient", function(t)
  if cv_sc_pitch == nil then return end
  if engine.GetDemoPlaybackTimeScale() ~= 1 and cv_sc_pitch:GetBool() then
    t.Pitch = math.Clamp(t.Pitch * engine.GetDemoPlaybackTimeScale(), 0, 255)
    return true
  end
end)
