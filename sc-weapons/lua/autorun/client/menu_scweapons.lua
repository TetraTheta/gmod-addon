local menu_lib = include("autorun/client/menu_lib_scweapons.lua") or SC_MenuLib
local setter_cmd = "sc_setservercvar"
--
---@param panel DForm
local function AddSettingsMenu(panel)
  panel:Clear()
  panel:Help("Server")
  menu_lib.AddServerComboBox(panel, "MP5 default secondary fire mode", "scaw_mp5_default", setter_cmd, "Selects the default secondary fire mode for the SC Admin MP5.", {
    { label = "Explosion Mode",     value = "1" },
    { label = "Airboat Gun Mode",   value = "2" },
    { label = "Combine Ball Mode",  value = "3" },
    { label = "Crossbow Bolt Mode", value = "4" },
    { label = "Grenade Mode",       value = "5" }
  })
  menu_lib.AddServerComboBox(panel, "MP5SD default secondary fire mode", "scaw_mp5sd_default", setter_cmd, "Selects the default secondary fire mode for the SC Admin MP5SD.", {
    { label = "Explosion Mode",     value = "1" },
    { label = "Airboat Gun Mode",   value = "2" },
    { label = "Combine Ball Mode",  value = "3" },
    { label = "Crossbow Bolt Mode", value = "4" },
    { label = "Grenade Mode",       value = "5" }
  })
  menu_lib.AddServerComboBox(panel, "Pistol default secondary fire mode", "scaw_pistol_default", setter_cmd, "Selects the default secondary fire mode for the SC Admin Pistol.", {
    { label = "Explosion Mode",     value = "1" },
    { label = "Airboat Gun Mode",   value = "2" },
    { label = "Combine Ball Mode",  value = "3" },
    { label = "Crossbow Bolt Mode", value = "4" },
    { label = "Grenade Mode",       value = "5" }
  })
  menu_lib.AddServerCheckBox(panel, "Owner explosion immunity", "scaw_owner_immune_explosion", setter_cmd, "Prevents the weapon owner from taking damage from Explosion Mode.")
end

---Populates the SC Weapons utility menu.
local function PopulateToolMenu()
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Weapons", "scw_settings", "Settings", nil, nil, AddSettingsMenu)
end

--[[
##############
#    MENU    #
##############
]]

hook.Add("PopulateToolMenu", "SCWeaponsSettingsMenu", PopulateToolMenu)
