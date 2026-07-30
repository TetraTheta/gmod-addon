local menu_lib = include("autorun/client/menu_lib_scweapons.lua") or SC_MenuLib
local setterCmd = "sc_setservercvar"

hook.Add("PopulateToolMenu", "SCWeaponsSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Weapons", "scw_settings", "Settings", "", "", function(panel)
    panel:Clear()
    panel:Help("Server")

    menu_lib.AddServerComboBox(panel, "MP5 default secondary fire", "scaw_mp5_default", setterCmd, "Selects the default secondary fire mode for the SC Admin MP5.", {
      { label = "Explosion Mode",     value = "1" },
      { label = "Airboat Gun Mode",   value = "2" },
      { label = "Combine Ball Mode",  value = "3" },
      { label = "Crossbow Bolt Mode", value = "4" },
      { label = "Grenade Mode",       value = "5" }
    })
    menu_lib.AddServerComboBox(panel, "MP5SD default secondary fire", "scaw_mp5sd_default", setterCmd, "Selects the default secondary fire mode for the SC Admin MP5SD.", {
      { label = "Explosion Mode",     value = "1" },
      { label = "Airboat Gun Mode",   value = "2" },
      { label = "Combine Ball Mode",  value = "3" },
      { label = "Crossbow Bolt Mode", value = "4" },
      { label = "Grenade Mode",       value = "5" }
    })
    menu_lib.AddServerCheckBox(panel, "Owner explosion immunity", "scaw_owner_immune_explosion", setterCmd, "Prevents the weapon owner from taking damage from Explosion Mode.")
    menu_lib.AddServerComboBox(panel, "Pistol default secondary fire", "scaw_pistol_default", setterCmd, "Selects the default secondary fire mode for the SC Admin Pistol.", {
      { label = "Explosion Mode",     value = "1" },
      { label = "Airboat Gun Mode",   value = "2" },
      { label = "Combine Ball Mode",  value = "3" },
      { label = "Crossbow Bolt Mode", value = "4" },
      { label = "Grenade Mode",       value = "5" }
    })
  end)
end)
