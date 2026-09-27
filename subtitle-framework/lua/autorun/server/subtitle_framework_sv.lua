if file.Exists("autorun/subtitles.lua", "LUA") then return end -- already have original

for _, f in ipairs(file.Find("subtitles/*.lua", "LUA") or {}) do
  AddCSLuaFile("subtitles/" .. f)
end

util.AddNetworkString("SIMPLEST_SUBTITLE_SOUND")

hook.Add("EntityEmitSound", "SIMPLEST_SUBTITLE_NETWORK", function(data)
  if not IsValid(data.Entity) then return end

  net.Start("SIMPLEST_SUBTITLE_SOUND")
  net.WriteString(data.OriginalSoundName)
  net.WriteString(data.SoundName)
  net.WriteEntity(data.Entity)
  net.SendPAS(data.Pos or data.Entity:GetPos())
end)
