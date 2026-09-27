if file.Exists("autorun/subtitles.lua", "LUA") then return end -- already have original

Subtitles_Table = Subtitles_Table or {}
local last_sub_tick = {}
local SoundToSubtitle = {}

local function GetSimplestSubtitle(script, path)
  return SoundToSubtitle[script] or SoundToSubtitle[path]
end
_G.GetSimplestSubtitle = GetSimplestSubtitle

---@param snd string
---@param text string
---@param duration number?
---@param range number?
---@param chain string?
local function RegisterSimplestSubtitle(snd, text, duration, range, chain)
  local sub = { text = text, duration = duration, range = range, chain = chain }
  SoundToSubtitle[snd] = sub

  local props = sound.GetProperties(snd)
  if not props then return end

  if istable(props.sound) then
    for _, path in ipairs(props.sound) do
      SoundToSubtitle[path] = sub
    end
  elseif isstring(props.sound) then
    SoundToSubtitle[props.sound] = sub
  end
end
_G.RegisterSimplestSubtitle = RegisterSimplestSubtitle

local function CallSimplestSubtitle(script, path, ent)
  local sub = GetSimplestSubtitle(script or "", path or "")
  if not sub then return end

  if sub.range and IsValid(ent) and LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > sub.range * sub.range then
    return
  end

  local tick = engine.TickCount()
  if last_sub_tick[sub] == tick then return end
  last_sub_tick[sub] = tick

  gui.AddCaption(sub.text, sub.duration or 5, IsValid(ent) and ent == LocalPlayer())

  if sub.chain and sub.chain ~= "" and sub.duration then
    local nextsub = sub.chain

    timer.Simple(sub.duration, function()
      CallSimplestSubtitle(nextsub, "", ent)
    end)
  end
end
_G.CallSimplestSubtitle = CallSimplestSubtitle

hook.Add("EntityEmitSound", "SIMPLEST_SUBTITLE_EMIT", function(data)
  CallSimplestSubtitle(data.OriginalSoundName, data.SoundName, data.Entity)
end)
net.Receive("SIMPLEST_SUBTITLE_SOUND", function()
  CallSimplestSubtitle(net.ReadString(), net.ReadString(), net.ReadEntity())
end)

local function LoadSubtitles()
  table.Empty(last_sub_tick)
  table.Empty(Subtitles_Table)
  table.Empty(SoundToSubtitle)

  hook.Run("SimplestSubtitles_PreRegister", SoundToSubtitle)

  for _, f in ipairs(file.Find("subtitles/*.lua", "LUA") or {}) do
    ProtectedCall(CompileFile("subtitles/" .. f))
  end

  for _, v in pairs(Subtitles_Table) do
    for _, v2 in pairs(v) do
      if not v2.snd or not v2.text then continue end

      local str = ""
      if v2.closedcaption then
        str = str .. "<sfx>"
      end
      if v2.subject then
        local col = v2.subjectcol or color_white

        str = str .. string.format("<clr:%d,%d,%d>%s ", col.r, col.g, col.b, language.GetPhrase(v2.subject):gsub("\r", ""):gsub("\n", "<cr>"))
      end

      local col = v2.textcol or color_white
      str = str .. string.format("<clr:%d,%d,%d>%s", col.r, col.g, col.b, language.GetPhrase(v2.text):gsub("\r", ""):gsub("\n", "<cr>"))

      RegisterSimplestSubtitle(v2.snd, str, v2.duration, v2.range, v2.chain)
    end
  end

  hook.Run("SimplestSubtitles_PostRegister", SoundToSubtitle)

  table.Empty(Subtitles_Table) -- do not pollute memory after parsing legacy table

  SIMPLEST_SUBTITLES_INITIALIZED = true
end
concommand.Add("subtitles_reload", LoadSubtitles)
hook.Add("InitPostEntity", "SIMPLEST_SUBTITLES_REGISTER", LoadSubtitles)
if SIMPLEST_SUBTITLES_INITIALIZED then LoadSubtitles() end

concommand.Add("subtitles_test", function()
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_1")
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_1", "", LocalPlayer():GetActiveWeapon())
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_2")
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_3")
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_4")
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_5")
end)
