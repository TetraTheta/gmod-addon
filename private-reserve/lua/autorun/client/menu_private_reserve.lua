local menu_lib = include("autorun/client/menu_lib.lua") or SC_MenuLib

hook.Add("PopulateToolMenu", "PrivateReserveSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "Private Reserve", "private_reserve_settings", "Settings", nil, nil, function(panel)
    panel:Clear()
    panel:Help("Server")

    menu_lib.AddCheckBox(panel, "Auto jump", "pr_autojump", "Continuously jumps for players on the server-managed auto-jump mode.")
    menu_lib.AddSlider(panel, "Auto jump delay", "pr_autojump_delay", 0, 5, 2, "Seconds IN_JUMP must be held before auto jump starts.")
    menu_lib.AddCheckBox(panel, "Disable zombie headcrabs", "pr_disable_headcrab", "Prevents headcrabs from detaching when zombies die.")
    menu_lib.AddCheckBox(panel, "Additional weapon pickup", "pr_enable_additional_pickup", "Allows custom pickup behavior for supported weapons.")
    menu_lib.AddCheckBox(panel, "Flying weapon drops", "pr_enable_flying_drops", "Lets dropped weapons keep more momentum after they are thrown from players.")
    menu_lib.AddCheckBox(panel, "Reload on kill", "pr_enable_kill_reload", "Reloads the current weapon after a kill.")
    menu_lib.AddCheckBox(panel, "Automatic loadout", "pr_enable_loadout", "Enables Private Reserve's automatic loadout management.")
    menu_lib.AddCheckBox(panel, "Shoot ammo crates open", "pr_enable_shoot_open_crate", "Allows ammo crates to open when they are shot.")
    menu_lib.AddCheckBox(panel, "Special damage rules", "pr_enable_special_damage", "Applies custom damage rules for supported weapons and damage types.")
    menu_lib.AddCheckBox(panel, "Shoot buttons and doors", "pr_shoot_button_use_enable", "Allows player bullets that hit supported buttons and doors to activate them.")
    menu_lib.AddCheckBox(panel, "Unlock shoot-used targets", "pr_shoot_button_use_unlock", "Unlocks the hit button or door before activating it.")
    menu_lib.AddTextEntry(panel, "Excluded shoot-use weapons", "pr_shoot_button_use_excluded_weapons", "Space or comma separated weapon classes that cannot activate buttons or doors by shooting.")
  end)
end)
