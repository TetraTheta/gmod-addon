local menu_lib = include("autorun/client/menu_lib_private_reserve.lua") or SC_MenuLib
local setterCmd = "sc_setservercvar"

hook.Add("PopulateToolMenu", "PrivateReserveSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "Private Reserve", "private_reserve_settings", "Settings", nil, nil, function(panel)
    panel:Clear()
    panel:Help("Server")

    menu_lib.AddServerCheckBox(panel, "Auto jump", "pr_autojump", setterCmd, "Continuously jumps for players on the server-managed auto-jump mode.")
    menu_lib.AddServerSlider(panel, "Auto jump delay", "pr_autojump_delay", setterCmd, 0, 5, 2, "Seconds IN_JUMP must be held before auto jump starts.")
    menu_lib.AddServerCheckBox(panel, "Disable zombie headcrabs", "pr_disable_headcrab", setterCmd, "Prevents headcrabs from detaching when zombies die.")
    menu_lib.AddServerCheckBox(panel, "Additional weapon pickup", "pr_enable_additional_pickup", setterCmd, "Allows custom pickup behavior for supported weapons.")
    menu_lib.AddServerCheckBox(panel, "Flying weapon drops", "pr_enable_flying_drops", setterCmd, "Lets dropped weapons keep more momentum after they are thrown from players.")
    menu_lib.AddServerCheckBox(panel, "Reload on kill", "pr_enable_kill_reload", setterCmd, "Reloads the current weapon after a kill.")
    menu_lib.AddServerCheckBox(panel, "Automatic loadout", "pr_enable_loadout", setterCmd, "Enables Private Reserve's automatic loadout management.")
    menu_lib.AddServerCheckBox(panel, "Shoot ammo crates open", "pr_enable_shoot_open_crate", setterCmd, "Allows ammo crates to open when they are shot.")
    menu_lib.AddServerCheckBox(panel, "Special damage rules", "pr_enable_special_damage", setterCmd, "Applies custom damage rules for supported weapons and damage types.")
    menu_lib.AddServerCheckBox(panel, "Shoot buttons and doors", "pr_shoot_button_use_enable", setterCmd, "Allows player bullets that hit supported buttons and doors to activate them.")
    menu_lib.AddServerCheckBox(panel, "Unlock shoot-used targets", "pr_shoot_button_use_unlock", setterCmd, "Unlocks the hit button or door before activating it.")
    menu_lib.AddServerTextEntry(panel, "Excluded shoot-use weapons", "pr_shoot_button_use_excluded_weapons", setterCmd, "Space or comma separated weapon classes that cannot activate buttons or doors by shooting.")
  end)
end)
