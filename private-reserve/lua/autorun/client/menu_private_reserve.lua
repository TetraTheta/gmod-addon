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
    _AddCheckBox(panel, "Shoot buttons and doors", "pr_shoot_button_use_enable", "Allows player bullets that hit supported buttons and doors to activate them.")
    _AddCheckBox(panel, "Unlock shoot-used targets", "pr_shoot_button_use_unlock", "Unlocks the hit button or door before activating it.")
    panel:TextEntry("Excluded shoot-use weapons", "pr_shoot_button_use_excluded_weapons")
    _AddHelp(panel, "Space or comma separated weapon classes that cannot activate buttons or doors by shooting.")
  end)
end)
