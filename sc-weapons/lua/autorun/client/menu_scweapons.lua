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
---@param help string
local function _AddWeaponMode(panel, label, convar, help)
  local combo = panel:ComboBox(label, convar)
  combo:SetSortItems(false)

  local current = GetConVar(convar)
  local currentValue = current and current:GetString() or nil
  combo:AddChoice("Explosion Mode", "1", currentValue == "1")
  combo:AddChoice("Airboat Gun Mode", "2", currentValue == "2")
  combo:AddChoice("Combine Ball Mode", "3", currentValue == "3")
  combo:AddChoice("Grenade Mode", "4", currentValue == "4")

  ---@diagnostic disable-next-line: inject-field -- This is valid usage but LuaLS thinks it is wrong.
  function combo:OnSelect(_, _, data)
    RunConsoleCommand(convar, tostring(data))
  end

  _AddHelp(panel, help)
end

hook.Add("PopulateToolMenu", "SCWeaponsSettingsMenu", function()
  ---@param panel DForm
  ---@diagnostic disable-next-line: deprecated -- Deprecation is for 6th argument(config).
  spawnmenu.AddToolMenuOption("Utilities", "SC Weapons", "scw_settings", "Settings", "", "", function(panel)
    panel:Clear()
    panel:Help("Server")

    _AddWeaponMode(panel, "MP5 default secondary fire", "scaw_mp5_default", "Selects the default secondary fire mode for the SC Admin MP5.")
    _AddWeaponMode(panel, "MP5SD default secondary fire", "scaw_mp5sd_default", "Selects the default secondary fire mode for the SC Admin MP5SD.")
    _AddCheckBox(panel, "Owner explosion immunity", "scaw_owner_immune_explosion", "Prevents the weapon owner from taking damage from Explosion Mode.")
    _AddWeaponMode(panel, "Pistol default secondary fire", "scaw_pistol_default", "Selects the default secondary fire mode for the SC Admin Pistol.")
  end)
end)
