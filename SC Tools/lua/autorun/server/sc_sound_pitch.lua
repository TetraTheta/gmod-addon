hook.Add("EntityEmitSound", "SCTimePitchSV", function(t)
  local cheats = GetConVar("sv_cheats"):GetBool()
  local timescale = GetConVar("host_timescale"):GetFloat()
  local p = t.Pitch
  if game.GetTimeScale() ~= 1 then p = p * game.GetTimeScale() end
  if timescale ~= 1 and cheats then p = p * timescale end
  if p ~= t.Pitch then
    t.Pitch = math.Clamp(p, 0, 255)
    return true
  end
end)
