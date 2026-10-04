if file.Exists("autorun/subtitles.lua", "LUA") then return end -- already have original

---@class SimplestSubtitle
---@field chain string?
---@field duration number?
---@field range number?
---@field text string

--

local DUPLICATE_WINDOW = 0.25 -- Merges one sound reported through multiple emit paths.
---@type table<SimplestSubtitle, number>
local last_sub_time = {}
---@type table<string, SimplestSubtitle>
local snd_to_sub = {}

Subtitles_Table = Subtitles_Table or {}

---Displays the subtitle registered for a sound.
---@param script string?
---@param path string?
---@param ent Entity?
---@return boolean displayed
function CallSimplestSubtitle(script, path, ent)
  local sub = GetSimplestSubtitle(script or "", path or "")
  if not sub then return false end

  if sub.range and ent and IsValid(ent) and LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > sub.range * sub.range then
    return false
  end

  local now = SysTime()
  local last_time = last_sub_time[sub]
  if last_time and now - last_time < DUPLICATE_WINDOW then return false end
  last_sub_time[sub] = now

  gui.AddCaption(sub.text, sub.duration or 5, IsValid(ent) and ent == LocalPlayer())

  if sub.chain and sub.chain ~= "" and sub.duration then
    local next_sub = sub.chain

    ---Displays a chained subtitle after the current one finishes.
    timer.Simple(sub.duration, function()
      CallSimplestSubtitle(next_sub, "", ent)
    end)
  end

  return true
end

---Formats a localized phrase for the caption renderer.
---@param text string
---@param col Color
---@param prefix string?
---@param suffix string?
---@return string
local function FormatPhrase(text, col, prefix, suffix)
  local phrase = language.GetPhrase(text):gsub("\r", ""):gsub("\n", "<cr>")
  return string.format("<clr:%d,%d,%d>%s%s%s", col.r, col.g, col.b, prefix or "", phrase, suffix or "")
end

---Returns the subtitle registered for a sound script or file path.
---@param script string?
---@param path string?
---@return SimplestSubtitle?
function GetSimplestSubtitle(script, path)
  return snd_to_sub[script or ""] or snd_to_sub[path or ""]
end

---Reloads every legacy subtitle definition.
local function LoadSubtitles()
  table.Empty(last_sub_time)
  table.Empty(Subtitles_Table)
  table.Empty(snd_to_sub)

  hook.Run("SimplestSubtitles_PreRegister", snd_to_sub)

  for _, file_name in ipairs(file.Find("subtitles/*.lua", "LUA")) do
    local chunk = CompileFile("subtitles/" .. file_name)
    if chunk then ProtectedCall(chunk) end
  end

  for _, sub_group in pairs(Subtitles_Table) do
    for _, sub_data in pairs(sub_group) do
      if sub_data.snd and sub_data.text then
        local caption = sub_data.closedcaption and "<sfx>" or ""

        if sub_data.subject and sub_data.subject ~= "" then
          caption = caption .. FormatPhrase(sub_data.subject, sub_data.subjectcol or color_white, "[", "]") .. " "
        end

        caption = caption .. FormatPhrase(sub_data.text, sub_data.textcol or color_white)
        RegisterSimplestSubtitle(sub_data.snd, caption, sub_data.duration, sub_data.range, sub_data.chain)
      end
    end
  end

  hook.Run("SimplestSubtitles_PostRegister", snd_to_sub)
  table.Empty(Subtitles_Table) -- do not pollute memory after parsing legacy table
  SIMPLEST_SUBTITLES_INITIALIZED = true
end

---Registers a subtitle for a sound script and its resolved file paths.
---@param snd string
---@param text string
---@param duration number?
---@param range number?
---@param chain string?
function RegisterSimplestSubtitle(snd, text, duration, range, chain)
  local sub = { chain = chain, duration = duration, range = range, text = text }
  snd_to_sub[snd] = sub

  local props = sound.GetProperties(snd)
  if not props then return end

  local snd_paths = props.sound
  if type(snd_paths) == "table" then
    for _, path in ipairs(snd_paths) do
      snd_to_sub[path] = sub
    end
  elseif type(snd_paths) == "string" then
    snd_to_sub[snd_paths] = sub
  end
end

---@param data EmitSoundInfo
hook.Add("EntityEmitSound", "SIMPLEST_SUBTITLE_EMIT", function(data)
  CallSimplestSubtitle(data.OriginalSoundName, data.SoundName, data.Entity)
end)

hook.Add("InitPostEntity", "SIMPLEST_SUBTITLES_REGISTER", LoadSubtitles)

---Receives sounds that only emitted on the server.
net.Receive("SIMPLEST_SUBTITLE_SOUND", function()
  CallSimplestSubtitle(net.ReadString(), net.ReadString(), net.ReadEntity())
end)

---Displays the built-in subtitle samples and exercises duplicate suppression.
local function TestSubtitles()
  table.Empty(last_sub_time)
  assert(CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_1"), "Subtitle test data was not loaded")

  ---Verifies that the same subtitle is suppressed across adjacent ticks.
  timer.Simple(DUPLICATE_WINDOW / 2, function()
    assert(not CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_1", "", LocalPlayer():GetActiveWeapon()), "Duplicate subtitle was displayed")
  end)

  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_2")
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_3")
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_4")
  CallSimplestSubtitle("SIMPLEST_SUBTITLE_TEST_5")
end

concommand.Add("subtitles_reload", LoadSubtitles)
concommand.Add("subtitles_test", TestSubtitles)

if SIMPLEST_SUBTITLES_INITIALIZED then LoadSubtitles() end
