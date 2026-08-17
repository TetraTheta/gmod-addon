local menu_lib = include("autorun/client/menu_lib_sctools.lua") or SC_MenuLib
local setterCmd = "sc_setservercvar"

hook.Add("PopulateToolMenu", "SCToolsSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Tools", "sctools_settings", "Settings", "", "", function(panel)
    panel:Clear()

    panel:Help("Server")

    menu_lib.AddServerComboBox(panel, "Auto flashlight", "sc_auto_flashlight", setterCmd, "Automatically turns on flashlights when the configured player scope matches.", {
      { label = "Disabled",                    value = "0" },
      { label = "Super admins only",           value = "1" },
      { label = "All players",                 value = "3" },
      { label = "Super admins only (Verbose)", value = "5" },
      { label = "All players (Verbose)",       value = "7" }
    })
    menu_lib.AddServerComboBox(panel, "God mode type", "sc_auto_god_mode", setterCmd, "Chooses the protection style used by automatic god mode.", {
      { label = "Buddha", value = "0" },
      { label = "God",    value = "1" },
    })
    menu_lib.AddServerCheckBox(panel, "NPC god mode", "sc_auto_god_npc", setterCmd, "Automatically protects NPCs on campaign maps.")
    menu_lib.AddServerComboBox(panel, "Super admin god mode", "sc_auto_god_sadmin", setterCmd, "Automatically protects players in the superadmin user group.", {
      { label = "Disabled",          value = "0" },
      { label = "Enabled",           value = "1" },
      { label = "Enabled (Verbose)", value = "3" }
    })
    menu_lib.AddServerSlider(panel, "Boost speed multiplier", "sc_boost_speed_modifier", setterCmd, 1, 10, 1, "Adjusts the speed multiplier used by the boost command.")
    menu_lib.AddServerCheckBox(panel, "Dynamic sound pitch", "sc_change_sound_pitch", setterCmd, "Changes sound pitch to follow the current game speed.")
    menu_lib.AddServerCheckBox(panel, "Disable obstacle collision", "sc_disable_obstacle", setterCmd, "Disables collision checks for obstacle objects.")
    menu_lib.AddServerCheckBox(panel, "Disable player collision", "sc_disable_player_collision", setterCmd, "Disables collision between players.")
    menu_lib.AddServerCheckBox(panel, "Map disconnect command", "sc_disconnect_mode", setterCmd, "Restores the map-provided disconnect console command.")
    menu_lib.AddServerCheckBox(panel, "Dissolve removed entities", "sc_remove_effect", setterCmd, "Uses dissolve effects when supported entities are removed.")

    panel:Help("Glow Filter")

    menu_lib.AddServerTextEntry(panel, "Entity class", "sc_glow_class", setterCmd, "Highlights entities with this class name.")
    menu_lib.AddServerTextEntry(panel, "Model path", "sc_glow_model", setterCmd, "Highlights entities using this model path.")
    menu_lib.AddServerTextEntry(panel, "Target name", "sc_glow_name", setterCmd, "Highlights entities with this targetname.")

    panel:Help("Client")

    menu_lib.AddClientComboBox(panel, "Bodyshot feedback", "sc_bshot_effect", "Chooses which local bodyshot feedback effects are enabled.", {
      { label = "Disabled",     value = "0" },
      { label = "Sound only",   value = "1" },
      { label = "UI only",      value = "2" },
      { label = "Sound and UI", value = "3" }
    })
    menu_lib.AddClientCheckBox(panel, "Dynamic fire", "sc_dynamic_fire", "Enables local dynamic fire effects.")
    menu_lib.AddClientCheckBox(panel, "env_hudhint messages", "env_hudhint_enable", "Shows local env_hudhint map messages.")
    menu_lib.AddClientComboBox(panel, "Headshot feedback", "sc_hshot_effect", "Chooses which local headshot feedback effects are enabled.", {
      { label = "Disabled",     value = "0" },
      { label = "Sound only",   value = "1" },
      { label = "UI only",      value = "2" },
      { label = "Sound and UI", value = "3" }
    })
    menu_lib.AddClientSlider(panel, "Bodyshot sound volume", "snd_bshotvolume", 0, 1, 2, "Adjusts the local bodyshot sound effect volume.")
    menu_lib.AddClientSlider(panel, "Headshot sound volume", "snd_hshotvolume", 0, 1, 2, "Adjusts the local headshot sound effect volume.")
  end)
end)
