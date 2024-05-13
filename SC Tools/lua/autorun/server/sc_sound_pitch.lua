local cheats = GetConVar("sv_cheats")
local timeScale = GetConVar("host_timescale")
hook.Add("EntityEmitSound", "SCTimePitchSV", function(t)
  local p = t.Pitch
  if game.GetTimeScale() ~= 1 then p = p * game.GetTimeScale() end
  if timeScale:GetFloat() ~= 1 and cheats:GetBool() then p = p * timeScale:GetFloat() end
  if p ~= t.Pitch then
    t.Pitch = math.Clamp(p, 0, 255)
    return true
  end
end)
