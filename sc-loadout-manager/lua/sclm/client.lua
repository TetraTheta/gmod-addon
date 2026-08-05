SCLM = SCLM or {}
SCLM.StateData = SCLM.StateData or {
  groups = {},
  users = {},
  usergroups = {},
  weapons = {}
}

local frame
local selected_tab = "Personal"
local xgui_panel
local xgui_loaded = false

---@return string
local function LocalSteamID()
  local ply = LocalPlayer()
  return IsValid(ply) and ply:SteamID() or ""
end

---@param parent Panel
---@param label string
---@return Panel
local function Label(parent, label)
  local panel = parent:Add("DLabel")
  panel:Dock(TOP)
  panel:DockMargin(0, 8, 0, 2)
  panel:SetText(label)
  panel:SetTextColor(color_black)

  return panel
end

---@param parent Panel
---@param values string[]
---@return Panel
local function Combo(parent, values)
  local combo = parent:Add("DComboBox")
  combo:Dock(TOP)

  for _, value in ipairs(values or {}) do
    combo:AddChoice(value)
  end

  return combo
end

---@param parent Panel
---@param placeholder string
---@return Panel
local function Entry(parent, placeholder)
  local entry = parent:Add("DTextEntry")
  entry:Dock(TOP)
  entry:SetPlaceholderText(placeholder)

  return entry
end

---@param combo Panel
---@return string
local function ComboWeaponClass(combo)
  local _, class = combo:GetSelected()
  return class or combo:GetText()
end

---@param combo Panel
---@param list Panel?
---@return string
local function SelectedWeaponClass(combo, list)
  if IsValid(list) then
    local selected = list:GetSelectedLine()
    local line = selected and list:GetLine(selected)
    if IsValid(line) then return line:GetColumnText(1) end
  end

  return ComboWeaponClass(combo)
end

---@param parent Panel
---@param text string
---@param tab_name string
---@param action string
---@param data_func fun(): table
---@return Panel
local function ActionButton(parent, text, tab_name, action, data_func)
  local button = parent:Add("DButton")
  button:Dock(TOP)
  button:DockMargin(0, 8, 0, 0)
  button:SetText(text)

  ---@param _ Panel
  function button:DoClick(_)
    selected_tab = tab_name
    net.Start(SCLM.NetRunAction)
    net.WriteString(action)
    net.WriteTable(data_func())
    net.SendToServer()
  end

  return button
end

---@param parent Panel
---@param loadout table
---@return Panel
local function WeaponList(parent, loadout)
  local list = parent:Add("DListView")
  list:Dock(FILL)
  list:DockMargin(0, 8, 0, 0)
  list:AddColumn("Weapon")
  list:AddColumn("Primary")
  list:AddColumn("Primary Ammo")
  list:AddColumn("Secondary Ammo")

  for class, weapon in SortedPairs(loadout.weapons or {}) do
    list:AddLine(class, class == loadout.primary and "Yes" or "", tostring(weapon.primary or -1), tostring(weapon.secondary or -1))
  end

  return list
end

---@param parent Panel
---@param owner string
---@param loadout table
---@param is_group boolean
local function BuildEditor(parent, owner, loadout, is_group)
  parent:Clear()

  local form = parent:Add("DPanel")
  form:Dock(LEFT)
  form:SetWide(240)
  form:DockPadding(8, 8, 8, 8)

  Label(form, "Weapon")
  local weapon = Combo(form, SCLM.StateData.weapons)

  Label(form, "Primary Ammo")
  local primary = Entry(form, "-1")
  primary:SetNumeric(true)

  Label(form, "Secondary Ammo")
  local secondary = Entry(form, "-1")
  secondary:SetNumeric(true)

  local action_prefix = is_group and "group" or "personal"
  local owner_data = is_group and owner or LocalSteamID()
  local tab_name = is_group and "Groups" or "Personal"
  local weapon_list

  ActionButton(form, "Add Weapon", tab_name, "add_" .. action_prefix .. "_weapon", function()
    return {
      class = ComboWeaponClass(weapon),
      owner = owner_data,
      primary = tonumber(primary:GetValue()) or -1,
      secondary = tonumber(secondary:GetValue()) or -1
    }
  end)

  ActionButton(form, "Remove Weapon", tab_name, "remove_" .. action_prefix .. "_weapon", function()
    return {
      class = SelectedWeaponClass(weapon, weapon_list),
      owner = owner_data
    }
  end)

  if is_group then
    ActionButton(form, "Toggle Primary", tab_name, "primary_group", function()
      return {
        class = SelectedWeaponClass(weapon, weapon_list),
        owner = owner
      }
    end)

    ActionButton(form, loadout.enforce and "Disable Enforce" or "Enable Enforce", tab_name, "enforce_group", function()
      return {
        enforce = not loadout.enforce,
        owner = owner
      }
    end)

    ActionButton(form, "Clear Loadout", tab_name, "clear_group", function()
      return { owner = owner }
    end)
  else
    ActionButton(form, "Toggle Primary", tab_name, "primary_personal", function()
      return {
        class = SelectedWeaponClass(weapon, weapon_list)
      }
    end)

    ActionButton(form, loadout.enforce and "Disable Enforce" or "Enable Enforce", tab_name, "enforce_personal", function()
      return {
        enforce = not loadout.enforce
      }
    end)

    ActionButton(form, "Clear Personal Loadout", tab_name, "clear_personal", function()
      return {}
    end)
  end

  local detail = parent:Add("DPanel")
  detail:Dock(FILL)
  detail:DockPadding(8, 8, 8, 8)

  Label(detail, string.format("Owner: %s", owner))
  Label(detail, string.format("Primary: %s", loadout.primary ~= "" and loadout.primary or "None"))
  Label(detail, string.format("Enforce: %s", loadout.enforce and "Yes" or "No"))
  weapon_list = WeaponList(detail, loadout)
end

---@param parent Panel
local function BuildGroupTab(parent)
  parent:Clear()

  local selector = parent:Add("DComboBox")
  selector:Dock(TOP)
  selector:DockMargin(8, 8, 8, 0)

  for _, group in ipairs(SCLM.StateData.usergroups or {}) do
    selector:AddChoice(group)
  end

  local editor = parent:Add("DPanel")
  editor:Dock(FILL)
  editor:DockMargin(8, 8, 8, 8)

  ---@param _ Panel
  ---@param _ number
  ---@param group string
  function selector:OnSelect(_, _, group)
    BuildEditor(editor, group, SCLM.StateData.groups[group] or { weapons = {}, primary = "", enforce = false }, true)
  end
end

---@param parent Panel
local function BuildPersonalTab(parent)
  parent:Clear()
  parent:DockPadding(8, 8, 8, 8)

  local steamid = LocalSteamID()
  BuildEditor(parent, steamid, SCLM.StateData.users[steamid] or { weapons = {}, primary = "", enforce = false }, false)
end

---@param parent Panel
---@param admin boolean
local function BuildMenu(parent, admin)
  if IsValid(parent.SCLMContent) then parent.SCLMContent:Remove() end

  local content = parent:Add("DPanel")
  content:Dock(FILL)
  parent.SCLMContent = content

  local tabs = content:Add("DPropertySheet")
  tabs:Dock(FILL)
  local groups_sheet
  local personal_sheet

  if admin then
    local groups = tabs:Add("DPanel")
    groups_sheet = tabs:AddSheet("Groups", groups, "icon16/group.png")
    BuildGroupTab(groups)
  end

  local personal = tabs:Add("DPanel")
  personal_sheet = tabs:AddSheet("Personal", personal, "icon16/user.png")
  BuildPersonalTab(personal)

  if selected_tab == "Personal" and personal_sheet and personal_sheet.Tab then
    tabs:SetActiveTab(personal_sheet.Tab)
  elseif selected_tab == "Groups" and groups_sheet and groups_sheet.Tab then
    tabs:SetActiveTab(groups_sheet.Tab)
  end
end

---@param admin boolean
local function RefreshFrame(admin)
  if IsValid(frame) then BuildMenu(frame, admin) end
end

---@param admin boolean
function SCLM.OpenMenu(admin)
  if IsValid(frame) then frame:Remove() end

  frame = vgui.Create("DFrame")
  frame:SetSize(720, 460)
  frame:Center()
  frame:SetTitle(SCLM.Title)
  frame:MakePopup()
  frame.SCLMAdmin = admin

  BuildMenu(frame, admin)
end

function SCLM.OpenAdminMenu()
  RunConsoleCommand("sclm_menu")
end

function SCLM.OpenPersonalMenu()
  RunConsoleCommand("sclm_loadout")
end

---@param parent Panel
function SCLM.AttachAdminPanel(parent)
  if not IsValid(parent) then return end

  xgui_panel = parent
  BuildMenu(parent, true)
end

function SCLM.RegisterXGUI()
  if xgui_loaded or not xgui or not xgui.null or not xlib then return end

  include("ulx/xgui/sclm.lua")
  xgui_loaded = true

  if xgui.processModules and xgui.initialized then
    xgui.processModules()
  end
end

net.Receive(SCLM.NetState, function()
  SCLM.StateData = net.ReadTable()
  if IsValid(frame) then
    RefreshFrame(frame.SCLMAdmin == true)
  end

  if IsValid(xgui_panel) then
    SCLM.AttachAdminPanel(xgui_panel)
  end
end)

hook.Add("Think", "SCLM_RegisterXGUI", function()
  SCLM.RegisterXGUI()
  if xgui_loaded then hook.Remove("Think", "SCLM_RegisterXGUI") end
end)
