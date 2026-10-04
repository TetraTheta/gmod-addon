if file.Exists("autorun/subtitles.lua", "LUA") then return end -- already have original

for _, file_name in ipairs(file.Find("subtitles/*.lua", "LUA")) do
  AddCSLuaFile("subtitles/" .. file_name)
end

util.AddNetworkString("SIMPLEST_SUBTITLE_SOUND")

---Relays a server-only sound event to clients that can hear it.
---@param data EmitSoundInfo
local function NetworkSubtitle(data)
  if not IsValid(data.Entity) then return end

  net.Start("SIMPLEST_SUBTITLE_SOUND")
  net.WriteString(data.OriginalSoundName)
  net.WriteString(data.SoundName)
  net.WriteEntity(data.Entity)
  net.SendPAS(data.Pos or data.Entity:GetPos())
end

hook.Add("EntityEmitSound", "SIMPLEST_SUBTITLE_NETWORK", NetworkSubtitle)
