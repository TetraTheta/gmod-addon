local base_col = Color(255, 170, 0, 220)
local bg_col = Color(0, 0, 0, 76)
local flash_col = Color(255, 220, 0, 255)
local large_font = "SCTOOLS_env_hudhint_HudHintTextLarge"
local small_font = "SCTOOLS_env_hudhint_HudHintTextSmall"
---@class SCHudHintLabel
---@field font string
---@field label DLabel|nil
---@field text string
---@class SCHudHintPanel : DPanel
---@field Labels SCHudHintLabel[]
---@field StartTime number
---@type SCHudHintPanel|nil
local hint_pnl
surface.CreateFont(large_font, {
  font = "Verdana",
  size = ScreenScale(12),
  weight = 1000,
  antialias = true,
  additive = true
})
surface.CreateFont(small_font, {
  font = "Verdana",
  size = ScreenScale(9),
  weight = 0,
  antialias = true,
  additive = true
})
--
---@param _ table
---@param pnl Panel
---@return nil
local function RemoveHintPanel(_, pnl)
  if IsValid(pnl) then pnl:Remove() end
end

---@param bind string
---@return string
local function BindingText(bind)
  local key = input.LookupBinding(bind, true)
  if key == nil then return "< NOT BOUND >" end
  local s = language.GetPhrase("#" .. key:upper()):gsub("^#", "")
  return s
end

---@param pnl Panel|nil
---@return nil
local function HideHintPanel(pnl)
  if not IsValid(pnl) then return end
  ---@cast pnl Panel
  pnl:AlphaTo(0, 0.5, 0, RemoveHintPanel)
end

---@param text string
---@return SCHudHintLabel[]
local function HintLabels(text)
  ---@type SCHudHintLabel[]
  local labels = {}
  local pos = 1
  while pos <= #text do
    local start_pos, end_pos = text:find("%%.-%%", pos)
    if start_pos == nil then
      labels[#labels + 1] = { font = small_font, text = text:sub(pos) }
      break
    end
    if start_pos > pos then
      labels[#labels + 1] = { font = small_font, text = text:sub(pos, start_pos - 1) }
    end
    labels[#labels + 1] = {
      font = large_font,
      text = BindingText(text:sub(start_pos + 1, end_pos - 1))
    }
    pos = end_pos + 1
  end
  return labels
end

---@param pnl SCHudHintPanel
---@return Color
local function HintTextColor(pnl)
  local age = CurTime() - pnl.StartTime
  local flash = (age >= 0.5 and age <= 0.7) or (age >= 1.5 and age <= 1.7)
  return flash and flash_col or base_col
end

---@param pnl SCHudHintPanel
---@param _w number
---@param _h number
---@return nil
local function PaintHintPanel(pnl, _w, _h)
  draw.RoundedBox(2, 0, 0, _w, _h, bg_col)
  local col = HintTextColor(pnl)
  for _, info in ipairs(pnl.Labels) do
    local label = info.label
    if label ~= nil then label:SetTextColor(col) end
  end
end

---@param text string
---@return nil
local function ShowHintPanel(text)
  if IsValid(hint_pnl) then
    ---@cast hint_pnl SCHudHintPanel
    hint_pnl:Remove()
  end
  local labels = HintLabels(language.GetPhrase(text))
  if #labels == 0 then return end

  local pnl = vgui.Create("DPanel")
  ---@cast pnl SCHudHintPanel
  hint_pnl = pnl
  pnl.Labels = labels
  pnl.StartTime = CurTime()
  pnl:SetAlpha(0)
  pnl:AlphaTo(255, 0.5, 0)
  pnl:AlphaTo(0, 1, 12, RemoveHintPanel)

  local widest_1 = 0
  local widest_2 = 0
  local row_h = 0
  for i, info in ipairs(labels) do
    local label = vgui.Create("DLabel", pnl)
    ---@cast label DLabel
    label:SetFont(info.font)
    label:SetText(info.text)
    label:SetTextColor(base_col)
    label:SizeToContents()
    info.label = label
    row_h = math.max(row_h, label:GetTall())
    if i % 2 == 1 then
      widest_1 = math.max(widest_1, label:GetWide())
    else
      widest_2 = math.max(widest_2, label:GetWide())
    end
  end

  local pad = 8
  local gap = 8
  local col_2 = pad + widest_1 + gap
  local y = pad
  for i = 1, #labels, 2 do
    local label = labels[i].label
    if label ~= nil then label:SetPos(pad, y + (row_h - label:GetTall()) * 0.5) end
    local next_label = labels[i + 1] ~= nil and labels[i + 1].label or nil
    if next_label ~= nil then
      next_label:SetPos(col_2, y + (row_h - next_label:GetTall()) * 0.5)
    end
    y = y + row_h + gap
  end

  pnl:SetSize(pad + col_2 + widest_2, y)
  pnl:SetPos(ScrW() - 20 - pnl:GetWide(), ScrH() - 340)
  ---@diagnostic disable-next-line: inject-field
  pnl.Paint = PaintHintPanel
end

---@return nil
local function ReceiveHudHint()
  local hudhint_enable = GetConVar("env_hudhint_enable")
  if hudhint_enable ~= nil and not hudhint_enable:GetBool() then return end

  local msg = net.ReadString()
  if msg == "" then
    HideHintPanel(hint_pnl)
  else
    ShowHintPanel(msg)
  end
end

--[[
###############
#     NET     #
###############
]]

net.Receive("SCTOOLS_env_hudhint_message", ReceiveHudHint)
