local MODULE_NAME = "SC Loadout Manager"
local MODULE_ICON = "icon16/gun.png"

---@return table?
local function FindModule()
  if not xgui.modules or not xgui.modules.tab then return nil end

  for _, module in ipairs(xgui.modules.tab) do
    if module.name == MODULE_NAME then return module end
  end
end

local existing_module = FindModule()
local sclm_tab = existing_module and existing_module.panel or xlib.makepanel({ parent = xgui.null, x = -5, y = 6, w = 600, h = 368 })

if not existing_module then
  xgui.addModule(MODULE_NAME, sclm_tab, MODULE_ICON)
else
  existing_module.access = nil
  existing_module.icon = MODULE_ICON
  existing_module.panel = sclm_tab
end

-- Late-loaded XGUI modules must also be listed in moduleOrder; addModule alone
-- only stores the module and processModules iterates the saved order table.
if xgui.settings and xgui.settings.moduleOrder and not table.HasValue(xgui.settings.moduleOrder, MODULE_NAME) then
  table.insert(xgui.settings.moduleOrder, MODULE_NAME)
end

---@return nil
local function AttachPanel()
  if not SCLM or not SCLM.AttachAdminPanel then return end

  SCLM.AttachAdminPanel(sclm_tab)
  RunConsoleCommand("sclm_refresh")
end

---@param old_set_active_tab fun(...): any
---@return fun(...): any
local function WrapSetActiveTab(old_set_active_tab)
  return function(...)
    local args = { ... }

    pcall(function()
      if args[2] and args[2].GetValue and args[2]:GetValue() == MODULE_NAME then
        AttachPanel()
      end
    end)

    return old_set_active_tab(unpack(args))
  end
end

-- XGUI modules are real tabs, so embed the editor panel here instead of
-- launching a second frame. Some older loadout managers also hook tab changes
-- to refresh their embedded GUI when XGUI activates the module.
if xgui.base and not xgui.SCLMSetActiveTabWrapped then
  xgui.base.SetActiveTab = WrapSetActiveTab(xgui.base.SetActiveTab)
  xgui.SCLMSetActiveTabWrapped = true
end

AttachPanel()
