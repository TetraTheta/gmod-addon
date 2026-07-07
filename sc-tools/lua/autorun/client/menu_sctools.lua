local menu_lib = include("autorun/client/menu_lib_sctools.lua") or SC_MenuLib

hook.Add("PopulateToolMenu", "SCToolsSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Tools", "sctools_settings", "Settings", "", "", function(panel)
    panel:Clear()

    panel:Help("Server")

    menu_lib.AddComboBox(panel, "Auto flashlight", "sc_auto_flashlight", "Automatically turns on flashlights when the configured player scope matches.", {
      { label = "Disabled",                    value = "0" },
      { label = "Super admins only",           value = "1" },
      { label = "All players",                 value = "3" },
      { label = "Super admins only (Verbose)", value = "5" },
      { label = "All players (Verbose)",       value = "7" }
    })
    menu_lib.AddComboBox(panel, "God mode type", "sc_auto_god_mode", "Chooses the protection style used by automatic god mode.", {
      { label = "Buddha", value = "0" },
      { label = "God",    value = "1" },
    })
    menu_lib.AddCheckBox(panel, "NPC god mode", "sc_auto_god_npc", "Automatically protects NPCs on campaign maps.")
    menu_lib.AddComboBox(panel, "Super admin god mode", "sc_auto_god_sadmin", "Automatically protects players in the superadmin user group.", {
      { label = "Disabled",          value = "0" },
      { label = "Enabled",           value = "1" },
      { label = "Enabled (Verbose)", value = "3" }
    })
    menu_lib.AddSlider(panel, "Boost speed multiplier", "sc_boost_speed_modifier", 1, 10, 1, "Adjusts the speed multiplier used by the boost command.")
    menu_lib.AddCheckBox(panel, "Dynamic sound pitch", "sc_change_sound_pitch", "Changes sound pitch to follow the current game speed.")
    menu_lib.AddCheckBox(panel, "Disable obstacle collision", "sc_disable_obstacle", "Disables collision checks for obstacle objects.")
    menu_lib.AddCheckBox(panel, "Disable player collision", "sc_disable_player_collision", "Disables collision between players.")
    menu_lib.AddCheckBox(panel, "Map disconnect command", "sc_disconnect_mode", "Restores the map-provided disconnect console command.")
    menu_lib.AddCheckBox(panel, "Dissolve removed entities", "sc_remove_effect", "Uses dissolve effects when supported entities are removed.")

    panel:Help("Glow Filter")

    menu_lib.AddTextEntry(panel, "Entity class", "sc_glow_class", "Highlights entities with this class name.")
    menu_lib.AddTextEntry(panel, "Model path", "sc_glow_model", "Highlights entities using this model path.")
    menu_lib.AddTextEntry(panel, "Target name", "sc_glow_name", "Highlights entities with this targetname.")

    panel:Help("Client")

    menu_lib.AddComboBox(panel, "Bodyshot feedback", "sc_bshot_effect", "Chooses which local bodyshot feedback effects are enabled.", {
      { label = "Disabled",     value = "0" },
      { label = "Sound only",   value = "1" },
      { label = "UI only",      value = "2" },
      { label = "Sound and UI", value = "3" }
    })
    menu_lib.AddCheckBox(panel, "Dynamic fire", "sc_dynamic_fire", "Enables local dynamic fire effects.")
    menu_lib.AddComboBox(panel, "Headshot feedback", "sc_hshot_effect", "Chooses which local headshot feedback effects are enabled.", {
      { label = "Disabled",     value = "0" },
      { label = "Sound only",   value = "1" },
      { label = "UI only",      value = "2" },
      { label = "Sound and UI", value = "3" }
    })
    menu_lib.AddSlider(panel, "Bodyshot sound volume", "snd_bshotvolume", 0, 1, 2, "Adjusts the local bodyshot sound effect volume.")
    menu_lib.AddSlider(panel, "Headshot sound volume", "snd_hshotvolume", 0, 1, 2, "Adjusts the local headshot sound effect volume.")
  end)
end)
