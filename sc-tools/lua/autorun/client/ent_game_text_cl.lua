local nw = "SCTOOLS_game_text_message"
local default_font = "SCTOOLS_game_text_CenterPrintText"
--
local active = {}
local MessageAlpha
surface.CreateFont(default_font, {
  font = "Trebuchet MS",
  size = ScreenScale(14),
  weight = 900,
  antialias = true,
  additive = true
})
--
---@param text string
---@return table
local function MessageLines(text)
  return string.Explode("/n", text, false)
end

---@param text string
---@return number
local function MessageScanLength(text)
  local _, breaks = text:gsub("/n", "")
  return #text - breaks
end

---@param text string
---@param font string
---@param x number
---@param y number
---@param col Color
---@param align integer
---@return nil
local function DrawMessage(text, font, x, y, col, align)
  surface.SetFont(font)
  local _, line_h = surface.GetTextSize("W")
  for i, line in ipairs(MessageLines(text)) do
    draw.SimpleText(line, font, x, y + (i - 1) * line_h, col, align, TEXT_ALIGN_TOP)
  end
end

---@param msg table
---@param char_time number
---@return Color
local function ScanColor(msg, char_time)
  local age = CurTime() - msg.start
  local alpha = math.Clamp(MessageAlpha(msg), 0, 1)
  if msg.fxtime <= 0 then return Color(msg.color1.r, msg.color1.g, msg.color1.b, msg.color1.a * alpha) end
  local frac = math.Clamp((age - char_time) / msg.fxtime, 0, 1)
  return Color(
    Lerp(frac, msg.color2.r, msg.color1.r),
    Lerp(frac, msg.color2.g, msg.color1.g),
    Lerp(frac, msg.color2.b, msg.color1.b),
    Lerp(frac, msg.color2.a, msg.color1.a) * alpha
  )
end

---@param text string
---@param font string
---@param x number
---@param y number
---@param msg table
---@param align integer
---@return nil
local function DrawScanMessage(text, font, x, y, msg, align)
  surface.SetFont(font)
  local _, line_h = surface.GetTextSize("W")
  local char_i = 0
  for line_i, line in ipairs(MessageLines(text)) do
    local line_w = surface.GetTextSize(line)
    local sx = align == TEXT_ALIGN_CENTER and x - line_w * 0.5 or x
    for i = 1, #line do
      local ch = line:sub(i, i)
      char_i = char_i + 1
      local char_time = char_i * msg.fadein
      if CurTime() - msg.start >= char_time then
        draw.SimpleText(ch, font, sx, y + (line_i - 1) * line_h, ScanColor(msg, char_time), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
      end
      sx = sx + surface.GetTextSize(ch)
    end
  end
end

---@param msg table
---@return number
function MessageAlpha(msg)
  local age = CurTime() - msg.start
  if msg.effect == 2 then
    local fade_time = (MessageScanLength(msg.text) * msg.fadein) + msg.holdtime
    if msg.fadeout > 0 and age > fade_time then return 1 - (age - fade_time) / msg.fadeout end
    return 1
  end
  if msg.fadein > 0 and age < msg.fadein then return age / msg.fadein end
  if msg.fadeout > 0 and age > msg.fadein + msg.holdtime then return 1 - (age - msg.fadein - msg.holdtime) / msg.fadeout end
  return 1
end

---@param msg table
---@return Color
local function MessageColor(msg)
  local age = CurTime() - msg.start
  local alpha = math.Clamp(MessageAlpha(msg), 0, 1)
  local col = msg.color1
  if msg.effect == 1 and msg.fxtime > 0 then
    local frac = math.abs(math.sin(age / msg.fxtime * math.pi))
    col = Color(
      Lerp(frac, msg.color1.r, msg.color2.r),
      Lerp(frac, msg.color1.g, msg.color2.g),
      Lerp(frac, msg.color1.b, msg.color2.b),
      Lerp(frac, msg.color1.a, msg.color2.a)
    )
  end
  return Color(col.r, col.g, col.b, col.a * alpha)
end

---@param msg table
---@return number
local function MessageEndTime(msg)
  if msg.effect == 2 then return (MessageScanLength(msg.text) * msg.fadein) + msg.holdtime + msg.fadeout end
  return msg.fadein + msg.holdtime + msg.fadeout
end

---@param value number
---@return number
local function ScreenCoord(value)
  if value == -1 then return -1 end
  return math.Clamp(value, 0, 1)
end

---@param text string
---@param font string
---@param max_width number
---@return string
local function WrapText(text, font, max_width)
  surface.SetFont(font)
  local wrapped = {}
  for _, raw_line in ipairs(MessageLines(text)) do
    local line = ""
    for _, word in ipairs(string.Explode(" ", raw_line, false)) do
      local test = line == "" and word or line .. " " .. word
      if surface.GetTextSize(test) > max_width and line ~= "" then
        wrapped[#wrapped + 1] = line
        line = word
      else
        line = test
      end
    end
    wrapped[#wrapped + 1] = line
  end
  return table.concat(wrapped, "/n")
end

--[[
#############
#    NET    #
#############
]]

net.Receive(nw, function(_, _)
  local msg = {
    autobreak = net.ReadBool(),
    channel = net.ReadInt(16),
    color1 = net.ReadColor(),
    color2 = net.ReadColor(),
    effect = net.ReadUInt(3),
    fadein = net.ReadFloat(),
    fadeout = net.ReadFloat(),
    font = net.ReadString(),
    fxtime = net.ReadFloat(),
    holdtime = net.ReadFloat(),
    start = CurTime(),
    text = net.ReadString(),
    x = net.ReadFloat(),
    y = net.ReadFloat()
  }
  active[msg.channel] = msg
end)

--[[
##############
#    HOOK    #
##############
]]

hook.Add("HUDPaint", "SCTOOLS_game_text_HUDPaint", function()
  for channel, msg in pairs(active) do
    local age = CurTime() - msg.start
    if age > MessageEndTime(msg) then
      active[channel] = nil
    else
      local font = msg.font ~= "" and msg.font or default_font
      local text = msg.text
      if msg.autobreak then text = WrapText(text, font, ScrW() * 0.8) end
      local x = ScreenCoord(msg.x)
      local y = ScreenCoord(msg.y)
      local sx = x == -1 and ScrW() * 0.5 or ScrW() * x
      local sy = y == -1 and ScrH() * 0.5 or ScrH() * y
      local align = x == -1 and TEXT_ALIGN_CENTER or TEXT_ALIGN_LEFT
      if msg.effect == 2 and msg.fadein > 0 then
        DrawScanMessage(text, font, sx, sy, msg, align)
      else
        DrawMessage(text, font, sx, sy, MessageColor(msg), align)
      end
    end
  end
end)
