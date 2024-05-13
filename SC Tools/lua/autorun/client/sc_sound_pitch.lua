hook.Add("EntityEmitSound", "SCTimePitchCL", function(t)
  if engine.GetDemoPlaybackTimeScale() ~= 1 then
    t.Pitch = math.Clamp(t.Pitch * engine.GetDemoPlaybackTimeScale(), 0, 255)
    return true
  end
end)
