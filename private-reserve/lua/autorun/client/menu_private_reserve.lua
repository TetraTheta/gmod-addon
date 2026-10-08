local menu_lib = include("autorun/client/menu_lib_private_reserve.lua") or SC_MenuLib
local setter_cmd = "sc_setservercvar"
--
---@param panel DForm
local function AddAutoJumpMenu(panel)
  panel:Clear()
  menu_lib.AddServerCheckBox(panel, "Auto jump", "pr_autojump", setter_cmd, "Continuously jumps for players on the server-managed auto-jump mode.")
  menu_lib.AddServerSlider(panel, "Auto jump delay", "pr_autojump_delay", setter_cmd, 0, 5, 2, "Seconds IN_JUMP must be held before auto jump starts.")
end

---@param panel DForm
local function AddEntityMenu(panel)
  panel:Clear()
  menu_lib.AddServerCheckBox(panel, "Disable zombie headcrabs", "pr_disable_headcrab", setter_cmd, "Prevents headcrabs from detaching when zombies die.")
  menu_lib.AddServerCheckBox(panel, "Shoot ammo crates open", "pr_enable_shoot_open_crate", setter_cmd, "Allows ammo crates to open when they are shot.")
  menu_lib.AddServerCheckBox(panel, "Shoot buttons and doors", "pr_shoot_button_use_enable", setter_cmd, "Allows player bullets that hit supported buttons and doors to activate them.")
  menu_lib.AddServerCheckBox(panel, "Shoot buttons and doors: Also unlock", "pr_shoot_button_use_unlock", setter_cmd, "Unlocks the hit button or door before activating it.")
  menu_lib.AddServerTextEntry(panel, "Shoot buttons and doors: Excluded weapons", "pr_shoot_button_use_excluded_weapons", setter_cmd, "Space or comma separated weapon classes that cannot activate buttons or doors by shooting.")
end

---@param panel DForm
local function AddLoadoutMenu(panel)
  panel:Clear()
  menu_lib.AddServerComboBox(panel, "Automatic loadout mode", "pr_enable_loadout", setter_cmd, "Controls how Private Reserve handles the player's starting loadout.", {
    { label = "Preserve",      value = "0" },
    { label = "Fill if empty", value = "1" },
    { label = "Replace",       value = "2" }
  })
end

---@param panel DForm
local function AddWeaponMenu(panel)
  panel:Clear()
  menu_lib.AddServerCheckBox(panel, "Flying weapon drops", "pr_enable_flying_drops", setter_cmd, "Lets dropped weapons keep more momentum after they are thrown from players.")
  menu_lib.AddServerCheckBox(panel, "Modify weapon pickup", "pr_edit_weapon_pickup", setter_cmd, "Allows custom pickup behavior for supported weapons.")
  menu_lib.AddServerCheckBox(panel, "Reload on kill", "pr_enable_kill_reload", setter_cmd, "Reloads the current weapon after a kill.")
  menu_lib.AddServerCheckBox(panel, "Special damage rules", "pr_enable_special_damage", setter_cmd, "Applies custom damage rules for supported weapons and damage types.")
end

---Populates the Private Reserve utility menus.
local function PopulateToolMenu()
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "Private Reserve", "private_reserve_auto_jump", "Auto Jump", nil, nil, AddAutoJumpMenu)
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "Private Reserve", "private_reserve_entity", "Entity", nil, nil, AddEntityMenu)
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "Private Reserve", "private_reserve_loadout", "Loadout", nil, nil, AddLoadoutMenu)
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "Private Reserve", "private_reserve_weapon", "Weapon", nil, nil, AddWeaponMenu)
end

--[[
##############
#    MENU    #
##############
]]

hook.Add("PopulateToolMenu", "PrivateReserveSettingsMenu", PopulateToolMenu)
