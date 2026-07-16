local MenuLib = {}

local function RunServerSetter(setterCmd, convar, value)
  RunConsoleCommand(setterCmd, convar, tostring(value))
end

local function AddLabeledControl(panel, label, control)
  local controlLabel = vgui.Create("DLabel")
  controlLabel:SetText(label)
  controlLabel:SetDark(true)
  controlLabel:SizeToContents()
  panel:AddItem(controlLabel, control)
  return control
end

local function SyncServerConVar(control, convar, sync)
  ---@diagnostic disable-next-line: inject-field -- This is valid usage but LuaLS thinks it is wrong.
  function control:Think()
    local current = GetConVar(convar)
    if current == nil then return end
    sync(self, current)
  end

  return control
end

---@param panel DForm
---@param text string
function MenuLib.AddHelp(panel, text)
  local help = panel:ControlHelp(text)
  help:SetWrap(true)
  help:SetAutoStretchVertical(true)
  return help
end

---@param panel DForm
---@param label string
---@param convar string
---@param help string
function MenuLib.AddClientCheckBox(panel, label, convar, help)
  local checkbox = panel:CheckBox(label, convar)
  MenuLib.AddHelp(panel, help)
  return checkbox
end

---@param panel DForm
---@param label string
---@param convar string
---@param setterCmd string
---@param help string
function MenuLib.AddServerCheckBox(panel, label, convar, setterCmd, help)
  local checkbox = vgui.Create("DCheckBoxLabel")
  local syncing = false
  checkbox:SetText(label)
  checkbox:SetDark(true)
  checkbox:SetValue(false)
  checkbox:SizeToContents()

  ---@diagnostic disable-next-line: inject-field -- This is valid usage but LuaLS thinks it is wrong.
  function checkbox:OnChange(value)
    if syncing then return end
    RunServerSetter(setterCmd, convar, value and "1" or "0")
  end

  SyncServerConVar(checkbox, convar, function(self, current)
    local value = current:GetBool()
    if self:GetChecked() == value then return end
    syncing = true
    self:SetValue(value and 1 or 0)
    syncing = false
  end)

  panel:AddItem(checkbox)
  MenuLib.AddHelp(panel, help)
  return checkbox
end

---@param panel DForm
---@param label string
---@param convar string
---@param min number
---@param max number
---@param decimals number
---@param help string
function MenuLib.AddClientSlider(panel, label, convar, min, max, decimals, help)
  local slider = panel:NumSlider(label, convar, min, max, decimals)
  MenuLib.AddHelp(panel, help)
  return slider
end

---@param panel DForm
---@param label string
---@param convar string
---@param setterCmd string
---@param min number
---@param max number
---@param decimals number
---@param help string
function MenuLib.AddServerSlider(panel, label, convar, setterCmd, min, max, decimals, help)
  local slider = vgui.Create("DNumSlider")
  local syncing = false
  slider:SetText(label)
  slider:SetDark(true)
  slider:SetMinMax(min, max)
  slider:SetDecimals(decimals)
  slider:SetValue(min)

  ---@diagnostic disable-next-line: inject-field -- This is valid usage but LuaLS thinks it is wrong.
  function slider:OnValueChanged(value)
    if syncing then return end
    RunServerSetter(setterCmd, convar, math.Round(value, decimals))
  end

  SyncServerConVar(slider, convar, function(self, current)
    local value = math.Round(current:GetFloat(), decimals)
    if math.abs(self:GetValue() - value) <= (10 ^ -decimals) then return end
    syncing = true
    self:SetValue(value)
    syncing = false
  end)

  panel:AddItem(slider)
  MenuLib.AddHelp(panel, help)
  return slider
end

---@param panel DForm
---@param label string
---@param convar string
---@param help string
function MenuLib.AddClientTextEntry(panel, label, convar, help)
  local textEntry = panel:TextEntry(label, convar)
  MenuLib.AddHelp(panel, help)
  return textEntry
end

---@param panel DForm
---@param label string
---@param convar string
---@param setterCmd string
---@param help string
function MenuLib.AddServerTextEntry(panel, label, convar, setterCmd, help)
  local textEntry = vgui.Create("DTextEntry")
  local syncing = false
  textEntry:SetUpdateOnType(false)
  textEntry:SetValue("")
  textEntry:SetWide(200)

  local function Submit(self)
    if syncing then return end
    RunServerSetter(setterCmd, convar, self:GetValue())
  end

  ---@diagnostic disable-next-line: inject-field -- This is valid usage but LuaLS thinks it is wrong.
  function textEntry:OnEnter()
    Submit(self)
  end

  ---@diagnostic disable-next-line: inject-field -- This is valid usage but LuaLS thinks it is wrong.
  function textEntry:OnLoseFocus()
    Submit(self)
  end

  SyncServerConVar(textEntry, convar, function(self, current)
    if self:HasFocus() then return end
    local value = current:GetString()
    if self:GetValue() == value then return end
    syncing = true
    self:SetValue(value)
    syncing = false
  end)

  AddLabeledControl(panel, label, textEntry)
  MenuLib.AddHelp(panel, help)
  return textEntry
end

---@param panel DForm
---@param label string
---@param convar string
---@param help string
---@param choices table
function MenuLib.AddClientComboBox(panel, label, convar, help, choices)
  local combo = panel:ComboBox(label, convar)
  combo:SetSortItems(false)

  local current = GetConVar(convar)
  local currentValue = current and current:GetString() or nil
  for _, choice in ipairs(choices) do
    combo:AddChoice(choice.label, choice.value, choice.value == currentValue)
  end

  ---@diagnostic disable-next-line: inject-field -- This is valid usage but LuaLS thinks it is wrong.
  function combo:OnSelect(_, _, data)
    RunConsoleCommand(convar, tostring(data))
  end

  MenuLib.AddHelp(panel, help)
  return combo
end

---@param panel DForm
---@param label string
---@param convar string
---@param setterCmd string
---@param help string
---@param choices table
function MenuLib.AddServerComboBox(panel, label, convar, setterCmd, help, choices)
  local combo = vgui.Create("DComboBox")
  local choiceIds = {}
  local currentValue = nil
  local syncing = false
  combo:SetSortItems(false)
  combo:SetWide(200)

  for _, choice in ipairs(choices) do
    local id = combo:AddChoice(choice.label, choice.value, false)
    choiceIds[tostring(choice.value)] = id
  end

  ---@diagnostic disable-next-line: inject-field -- This is valid usage but LuaLS thinks it is wrong.
  function combo:OnSelect(_, _, data)
    if syncing then return end
    RunServerSetter(setterCmd, convar, data)
  end

  SyncServerConVar(combo, convar, function(self, current)
    local value = current:GetString()
    if currentValue == value then return end
    local id = choiceIds[value]
    if id == nil then return end
    syncing = true
    self:ChooseOptionID(id)
    currentValue = value
    syncing = false
  end)

  AddLabeledControl(panel, label, combo)
  MenuLib.AddHelp(panel, help)
  return combo
end

SC_MenuLib = MenuLib
return MenuLib
