local menu_lib = include("autorun/client/menu_lib_sctools.lua") or SC_MenuLib
local setter_cmd = "sc_setservercvar"
--
---@param panel DForm
local function AddClientMenu(panel)
  panel:Clear()
  menu_lib.AddClientCheckBox(panel, "Dynamic fire", "sc_dynamic_fire", "Enables local dynamic fire effects.")
  menu_lib.AddClientCheckBox(panel, "Enable prop climbing", "sc_prop_climbing", "Allows you to jump reliably from movable props.")
  menu_lib.AddClientCheckBox(panel, "Force GLua game_text rendering", "game_text_force_glua", "Forces game_text to use GLua HUD rendering instead of native rendering.")
  menu_lib.AddClientCheckBox(panel, "Re-enable env_hudhint", "env_hudhint_enable", "Shows local env_hudhint map messages.")
end

---@param panel DForm
local function AddGlowFilterMenu(panel)
  panel:Clear()
  menu_lib.AddServerTextEntry(panel, "Entity class", "sc_glow_class", setter_cmd, "Highlights entities with this class name.")
  menu_lib.AddServerTextEntry(panel, "Model path", "sc_glow_model", setter_cmd, "Highlights entities using this model path.")
  menu_lib.AddServerTextEntry(panel, "Target name", "sc_glow_name", setter_cmd, "Highlights entities with this targetname.")
end

---@param panel DForm
local function AddServerMenu(panel)
  panel:Clear()
  menu_lib.AddServerComboBox(panel, "Enable flashlight automatically", "sc_auto_flashlight", setter_cmd, "Automatically turns on flashlights when the configured player scope matches.", {
    { label = "Disabled",                    value = "0" },
    { label = "Super admins only",           value = "1" },
    { label = "All players",                 value = "3" },
    { label = "Super admins only (Verbose)", value = "5" },
    { label = "All players (Verbose)",       value = "7" }
  })
  menu_lib.AddServerCheckBox(panel, "Enable GodMode automatically (NPC)", "sc_auto_god_npc", setter_cmd, "Automatically protects NPCs on campaign maps.")
  menu_lib.AddServerComboBox(panel, "Enable GodMode automatically (SuperAdmin)", "sc_auto_god_sadmin", setter_cmd, "Automatically protects players in the superadmin user group.", {
    { label = "Disabled",          value = "0" },
    { label = "Enabled",           value = "1" },
    { label = "Enabled (Verbose)", value = "3" }
  })
  menu_lib.AddServerComboBox(panel, "GodMode type", "sc_auto_god_mode", setter_cmd, "Chooses the protection style used by automatic GodMode.", {
    { label = "Buddha", value = "0" },
    { label = "God",    value = "1" },
  })
  menu_lib.AddServerSlider(panel, "Boost speed multiplier", "sc_boost_speed_modifier", setter_cmd, 1, 10, 1, "Adjusts the speed multiplier used by the boost command.")
  menu_lib.AddServerCheckBox(panel, "Disable obstacle collision", "sc_disable_obstacle", setter_cmd, "Disables collision checks for obstacle objects.")
  menu_lib.AddServerCheckBox(panel, "Disable player collision", "sc_disable_player_collision", setter_cmd, "Disables collision between players.")
  menu_lib.AddServerCheckBox(panel, "Dynamic sound pitch", "sc_change_sound_pitch", setter_cmd, "Changes sound pitch to follow the current game speed.")
  menu_lib.AddServerCheckBox(panel, "Re-enable disconnect map command", "sc_disconnect_mode", setter_cmd, "Restores the map-provided disconnect console command.")
  menu_lib.AddServerCheckBox(panel, "Remove effect", "sc_remove_effect", setter_cmd, "Uses dissolve effects when supported entities are removed.")
end

---@param panel DForm
local function AddShotFeedbackMenu(panel)
  panel:Clear()
  menu_lib.AddClientComboBox(panel, "Bodyshot feedback mode", "sc_bshot_effect", "Chooses which local bodyshot feedback effects are enabled.", {
    { label = "Disabled",     value = "0" },
    { label = "Sound only",   value = "1" },
    { label = "UI only",      value = "2" },
    { label = "Sound and UI", value = "3" }
  })
  menu_lib.AddClientComboBox(panel, "Headshot feedback mode", "sc_hshot_effect", "Chooses which local headshot feedback effects are enabled.", {
    { label = "Disabled",     value = "0" },
    { label = "Sound only",   value = "1" },
    { label = "UI only",      value = "2" },
    { label = "Sound and UI", value = "3" }
  })
  menu_lib.AddClientSlider(panel, "Bodyshot feedback sound volume", "snd_bshotvolume", 0, 1, 2, "Adjusts the local bodyshot sound effect volume.")
  menu_lib.AddClientSlider(panel, "Headshot feedback sound volume", "snd_hshotvolume", 0, 1, 2, "Adjusts the local headshot sound effect volume.")
end

---Populates the SC Tools utility menus.
local function PopulateToolMenu()
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Tools", "sctools_client", "Client", nil, nil, AddClientMenu)
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Tools", "sctools_server", "Server", nil, nil, AddServerMenu)
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Tools", "sctools_glow_filter", "Glow Filter", nil, nil, AddGlowFilterMenu)
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Tools", "sctools_shot_feedback", "Shot Feedback", nil, nil, AddShotFeedbackMenu)
end

--[[
##############
#    MENU    #
##############
]]

hook.Add("PopulateToolMenu", "SCToolsSettingsMenu", PopulateToolMenu)
