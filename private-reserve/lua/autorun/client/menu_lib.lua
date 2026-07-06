local MenuLib = {}

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
function MenuLib.AddCheckBox(panel, label, convar, help)
  panel:CheckBox(label, convar)
  MenuLib.AddHelp(panel, help)
end

---@param panel DForm
---@param label string
---@param convar string
---@param min number
---@param max number
---@param decimals number
---@param help string
function MenuLib.AddSlider(panel, label, convar, min, max, decimals, help)
  panel:NumSlider(label, convar, min, max, decimals)
  MenuLib.AddHelp(panel, help)
end

---@param panel DForm
---@param label string
---@param convar string
---@param help string
function MenuLib.AddTextEntry(panel, label, convar, help)
  panel:TextEntry(label, convar)
  MenuLib.AddHelp(panel, help)
end

---@param panel DForm
---@param label string
---@param convar string
---@param help string
---@param choices table
function MenuLib.AddComboBox(panel, label, convar, help, choices)
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
---@param help string
function MenuLib.AddWeaponMode(panel, label, convar, help)
  return MenuLib.AddComboBox(panel, label, convar, help, {
    { label = "Explosion Mode",    value = "1" },
    { label = "Airboat Gun Mode",  value = "2" },
    { label = "Combine Ball Mode", value = "3" },
    { label = "Grenade Mode",      value = "4" }
  })
end

SC_MenuLib = MenuLib
return MenuLib
