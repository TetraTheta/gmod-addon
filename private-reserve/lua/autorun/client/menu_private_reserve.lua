---@param panel DForm
---@param text string
local function _AddHelp(panel, text)
  local help = panel:ControlHelp(text)
  help:SetWrap(true)
  help:SetAutoStretchVertical(true)
end

---@param panel DForm
---@param label string
---@param convar string
---@param help string
local function _AddCheckBox(panel, label, convar, help)
  panel:CheckBox(label, convar)
  _AddHelp(panel, help)
end

---@param panel DForm
---@param label string
---@param convar string
---@param help string
---@param choices table
local function _AddComboBox(panel, label, convar, help, choices)
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

  _AddHelp(panel, help)
end

hook.Add("PopulateToolMenu", "PrivateReserveSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "Private Reserve", "private_reserve_settings", "Settings", nil, nil, function(panel)
    panel:Clear()
    panel:Help("Server")

    _AddCheckBox(panel, "Auto jump", "pr_autojump", "Continuously jumps for players on the server-managed auto-jump mode.")
    _AddCheckBox(panel, "Disable zombie headcrabs", "pr_disable_headcrab", "Prevents headcrabs from detaching when zombies die.")
    _AddCheckBox(panel, "Additional weapon pickup", "pr_enable_additional_pickup", "Allows custom pickup behavior for supported weapons.")
    _AddCheckBox(panel, "Flying weapon drops", "pr_enable_flying_drops", "Lets dropped weapons keep more momentum after they are thrown from players.")
    _AddCheckBox(panel, "Reload on kill", "pr_enable_kill_reload", "Reloads the current weapon after a kill.")
    _AddCheckBox(panel, "Automatic loadout", "pr_enable_loadout", "Enables Private Reserve's automatic loadout management.")
    _AddCheckBox(panel, "Shoot ammo crates open", "pr_enable_shoot_open_crate", "Allows ammo crates to open when they are shot.")
    _AddCheckBox(panel, "Special damage rules", "pr_enable_special_damage", "Applies custom damage rules for supported weapons and damage types.")
    _AddComboBox(panel, "Shoot buttons", "pr_shoot_button_use", "Controls whether buttons can be used by shooting them.", {
      { label = "Disabled",       value = "0" },
      { label = "Use only",       value = "1" },
      { label = "Unlock and use", value = "2" }
    })
  end)
end)
