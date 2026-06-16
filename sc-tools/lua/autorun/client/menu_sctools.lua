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
---@param min number
---@param max number
---@param decimals number
---@param help string
local function _AddSlider(panel, label, convar, min, max, decimals, help)
  panel:NumSlider(label, convar, min, max, decimals)
  _AddHelp(panel, help)
end

---@param panel DForm
---@param label string
---@param convar string
---@param help string
local function _AddTextEntry(panel, label, convar, help)
  panel:TextEntry(label, convar)
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

hook.Add("PopulateToolMenu", "SCToolsSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Tools", "sctools_settings", "Settings", "", "", function(panel)
    panel:Clear()
    panel:Help("Server")

    _AddComboBox(panel, "Auto flashlight", "sc_auto_flashlight", "Automatically turns on flashlights when the configured player scope matches.", {
      { label = "Disabled",                    value = "0" },
      { label = "Super admins only",           value = "1" },
      { label = "All players",                 value = "3" },
      { label = "Super admins only (Verbose)", value = "5" },
      { label = "All players (Verbose)",       value = "7" }
    })
    _AddComboBox(panel, "God mode type", "sc_auto_god_mode", "Chooses the protection style used by automatic god mode.", {
      { label = "Buddha", value = "0" },
      { label = "God",    value = "1" },
    })
    _AddCheckBox(panel, "NPC god mode", "sc_auto_god_npc", "Automatically protects NPCs on campaign maps.")
    _AddComboBox(panel, "Super admin god mode", "sc_auto_god_sadmin", "Automatically protects players in the superadmin user group.", {
      { label = "Disabled",          value = "0" },
      { label = "Enabled",           value = "1" },
      { label = "Enabled (Verbose)", value = "3" }
    })
    _AddSlider(panel, "Boost speed multiplier", "sc_boost_speed_modifier", 1, 10, 1, "Adjusts the speed multiplier used by the boost command.")
    _AddCheckBox(panel, "Dynamic sound pitch", "sc_change_sound_pitch", "Changes sound pitch to follow the current game speed.")
    _AddCheckBox(panel, "Disable obstacle collision", "sc_disable_obstacle", "Disables collision checks for obstacle objects.")
    _AddCheckBox(panel, "Disable player collision", "sc_disable_player_collision", "Disables collision between players.")
    _AddCheckBox(panel, "Map disconnect command", "sc_disconnect_mode", "Restores the map-provided disconnect console command.")
    _AddCheckBox(panel, "Dissolve removed entities", "sc_remove_effect", "Uses dissolve effects when supported entities are removed.")

    panel:Help("Glow Filter")
    _AddTextEntry(panel, "Entity class", "sc_glow_class", "Highlights entities with this class name.")
    _AddTextEntry(panel, "Model path", "sc_glow_model", "Highlights entities using this model path.")
    _AddTextEntry(panel, "Target name", "sc_glow_name", "Highlights entities with this targetname.")

    panel:Help("Client")
    _AddComboBox(panel, "Bodyshot feedback", "sc_bshot_effect", "Chooses which local bodyshot feedback effects are enabled.", {
      { label = "Disabled",     value = "0" },
      { label = "Sound only",   value = "1" },
      { label = "UI only",      value = "2" },
      { label = "Sound and UI", value = "3" }
    })
    _AddCheckBox(panel, "Dynamic fire", "sc_dynamic_fire", "Enables local dynamic fire effects.")
    _AddComboBox(panel, "Headshot feedback", "sc_hshot_effect", "Chooses which local headshot feedback effects are enabled.", {
      { label = "Disabled",     value = "0" },
      { label = "Sound only",   value = "1" },
      { label = "UI only",      value = "2" },
      { label = "Sound and UI", value = "3" }
    })
    _AddSlider(panel, "Bodyshot sound volume", "snd_bshotvolume", 0, 1, 2, "Adjusts the local bodyshot sound effect volume.")
    _AddSlider(panel, "Headshot sound volume", "snd_hshotvolume", 0, 1, 2, "Adjusts the local headshot sound effect volume.")
  end)
end)
