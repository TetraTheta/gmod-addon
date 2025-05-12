---@param t EmitSoundInfo
hook.Add("EntityEmitSound", "SCTOOLS_SoundPitchClient", function(t)
  local cv_cheat = GetConVar("sv_cheats")
  local cv_timescale = GetConVar("host_timescale")
  local cv_sc_pitch = GetConVar("sc_change_sound_pitch")
  if cv_sc_pitch == nil then return end

  local p = t.Pitch
  if (game.GetTimeScale() ~= 1) then
    p = p * game.GetTimeScale()
  end
  if (cv_timescale:GetFloat() ~= 1 and cv_cheat:GetBool()) then
    p = p * cv_timescale:GetFloat()
  end

  if (p ~= t.Pitch and cv_sc_pitch:GetBool()) then
    t.Pitch = math.Clamp(p, 0, 255)
    return true
  end
end)
