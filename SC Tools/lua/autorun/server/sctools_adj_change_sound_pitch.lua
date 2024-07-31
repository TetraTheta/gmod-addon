local g_GetTimeScale = game.GetTimeScale
local m_Clamp = math.Clamp
--
---@param t EmitSoundInfo
hook.Add("EntityEmitSound", "SCTOOLS_SoundPitchServer", function(t)
  if not GetConVar("sc_change_sound_pitch"):GetBool() then return false end
  local cheats = GetConVar("sv_cheats"):GetBool()
  local host_timescale = GetConVar("host_timescale"):GetFloat()
  local game_timescale = g_GetTimeScale()
  local p = t.Pitch
  if game_timescale ~= 1 then p = p * game_timescale end
  if host_timescale ~= 1 and cheats then p = p * host_timescale end
  if p ~= t.Pitch then
    t.Pitch = m_Clamp(p, 0, 255)
    return true
  end
end)
