local menu_lib = include("autorun/client/menu_lib_scweapons.lua") or SC_MenuLib

hook.Add("PopulateToolMenu", "SCWeaponsSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Weapons", "scw_settings", "Settings", "", "", function(panel)
    panel:Clear()
    panel:Help("Server")

    menu_lib.AddWeaponMode(panel, "MP5 default secondary fire", "scaw_mp5_default", "Selects the default secondary fire mode for the SC Admin MP5.")
    menu_lib.AddWeaponMode(panel, "MP5SD default secondary fire", "scaw_mp5sd_default", "Selects the default secondary fire mode for the SC Admin MP5SD.")
    menu_lib.AddCheckBox(panel, "Owner explosion immunity", "scaw_owner_immune_explosion", "Prevents the weapon owner from taking damage from Explosion Mode.")
    menu_lib.AddWeaponMode(panel, "Pistol default secondary fire", "scaw_pistol_default", "Selects the default secondary fire mode for the SC Admin Pistol.")
  end)
end)
