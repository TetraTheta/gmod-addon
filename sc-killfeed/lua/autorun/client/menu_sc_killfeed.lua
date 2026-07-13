local menu_lib = include("autorun/client/menu_lib_sc_killfeed.lua") or SC_MenuLib

hook.Add("PopulateToolMenu", "SCKillfeedSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Killfeed", "sc_killfeed_settings", "Settings", nil, nil, function(panel)
    panel:Clear()
    panel:Help("SC Killfeed Settings")
    menu_lib.AddCheckBox(panel, "Enable Custom Killfeed", "sc_killfeed_enabled", "Enable or disable the customized killfeed system.")
    menu_lib.AddCheckBox(panel, "Show Headshot Icons", "sc_killfeed_show_headshot", "Show headshot icons next to weapon icons on headshot kills.")
    panel:Help("NOTE:\n- Only humanoid enemies (e.g., Combine Soldiers, Rebels) have a 'head'.\n- Stalker don't have 'head'. Every body part is considered as 'body'.\n- Hunter's 'head' is actually 'body'. Its legs don't have hitboxes.")
  end)
end)
