local cv_enable = GetConVar("pr_shoot_button_use_enable")
local cv_excluded_weapons = GetConVar("pr_shoot_button_use_excluded_weapons")
local cv_unlock = GetConVar("pr_shoot_button_use_unlock")

local BASE_WEAPON_CLASSES = {
  "gmod_camera",
  "gmod_tool",
  "weapon_357",
  "weapon_ar2",
  "weapon_bugbait",
  "weapon_crossbow",
  "weapon_crowbar",
  "weapon_frag",
  "weapon_physcannon",
  "weapon_physgun",
  "weapon_pistol",
  "weapon_rpg",
  "weapon_shotgun",
  "weapon_slam",
  "weapon_smg1",
  "weapon_stunstick",
}

local CANDIDATE = {
  func_button = "Press",
  func_door = "Toggle",
  func_door_rotating = "Toggle",
  func_rot_button = "Press",
  prop_door_rotating = "Toggle"
}

---@return string[], table
local function GetExcludedWeaponClasses()
  if not cv_excluded_weapons then cv_excluded_weapons = GetConVar("pr_shoot_button_use_excluded_weapons") end
  local classes = {}
  local seen = {}
  for cls in cv_excluded_weapons:GetString():gmatch("[^,%s]+") do
    cls = cls:lower()
    if not seen[cls] then
      table.insert(classes, cls)
      seen[cls] = true
    end
  end
  table.sort(classes)
  return classes, seen
end

---@param ply Player
---@return string
local function GetShooterWeaponClass(ply)
  local wep = ply:GetActiveWeapon()
  return IsValid(wep) and wep:GetClass() or ""
end

---@return string[]
local function GetSortedWeaponClasses()
  local classes = {}
  local seen = {}
  for _, cls in ipairs(BASE_WEAPON_CLASSES) do
    classes[#classes + 1] = cls
    seen[cls] = true
  end
  for _, wep_data in ipairs(weapons.GetList()) do
    local cls = wep_data.ClassName
    if isstring(cls) and cls ~= "" and not seen[cls] then
      classes[#classes + 1] = cls
      seen[cls] = true
    end
  end

  table.sort(classes)
  return classes
end

---@param classes string[]
local function SetExcludedWeaponClasses(classes)
  if not cv_excluded_weapons then cv_excluded_weapons = GetConVar("pr_shoot_button_use_excluded_weapons") end
  cv_excluded_weapons:SetString(table.concat(classes, " "))
end

---@param value string
---@param prefix string
---@return boolean
local function StartsWith(value, prefix)
  return value:lower():sub(1, #prefix) == prefix:lower()
end

---@param ply Player|Entity
---@return boolean
local function CanEditExcludedWeapons(ply)
  return not IsValid(ply) or ply:IsAdmin()
end

--[[
##############
#    HOOK    #
##############
]]

hook.Add("PostEntityFireBullets", "PR_Shoot_Button_Use", function(shooter, fb)
  if not cv_enable then cv_enable = GetConVar("pr_shoot_button_use_enable") end
  if not cv_unlock then cv_unlock = GetConVar("pr_shoot_button_use_unlock") end
  if not cv_enable:GetBool() or not fb.Trace.Hit then return end
  local ent = fb.Trace.Entity
  local ply = IsValid(fb.Attacker) and fb.Attacker or shooter
  if not (IsValid(ent) and IsValid(ply) and ply:IsPlayer() and ply:Alive()) then return end
  ---@cast ent Entity
  ---@cast ply Player
  local cls = ent:GetClass()
  local act = CANDIDATE[cls]
  if not act then return end
  local _, excluded = GetExcludedWeaponClasses()
  if excluded[GetShooterWeaponClass(ply):lower()] then return end

  ent["_PRNextShootButtonUse"] = ent["_PRNextShootButtonUse"] or 0
  if CurTime() < ent["_PRNextShootButtonUse"] then return end
  ent["_PRNextShootButtonUse"] = CurTime() + 0.2

  if cv_unlock:GetBool() then ent:Fire("Unlock") end
  ent:Fire(act)
end)

--[[
#################
#    COMMAND    #
#################
]]

---@param ply Player|Entity
---@param args table
local function ExcludeAdd(ply, args)
  if not CanEditExcludedWeapons(ply) then return end

  local cls = string.lower(args[1] or "")
  if cls == "" then return end

  local classes, seen = GetExcludedWeaponClasses()
  if seen[cls] then return end

  table.insert(classes, cls)
  table.sort(classes)
  SetExcludedWeaponClasses(classes)
end

---@param ply Player|Entity
---@param args table
local function ExcludeRemove(ply, args)
  if not CanEditExcludedWeapons(ply) then return end
  local class = string.lower(args[1] or "")
  if class == "" then return end
  local classes = GetExcludedWeaponClasses()
  for i = #classes, 1, -1 do
    if classes[i] == class then table.remove(classes, i) end
  end
  SetExcludedWeaponClasses(classes)
end

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param cmd string
---@param args string
---@param classes string[]
---@return string[]
local function CompleteClasses(cmd, args, classes)
  local prefix = args or ""
  if prefix:lower():sub(1, #cmd) == cmd:lower() then prefix = prefix:sub(#cmd + 1) end
  prefix = prefix:Trim()
  local out = {}
  for _, class in ipairs(classes) do
    if StartsWith(class, prefix) then out[#out + 1] = cmd .. " " .. class end
  end
  return out
end

---@param cmd string
---@param args string
---@return string[]
local function ExcludeAddComplete(cmd, args)
  return CompleteClasses(cmd, args, GetSortedWeaponClasses())
end

---@param cmd string
---@param args string
---@return string[]
local function ExcludeRemoveComplete(cmd, args)
  return CompleteClasses(cmd, args, GetExcludedWeaponClasses())
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("pr_shoot_button_use_exclude_add", function(ply, _, args, _) ExcludeAdd(ply, args) end, ExcludeAddComplete, "Add a weapon class to the shoot-button-use exclude list.", { FCVAR_NONE })
concommand.Add("pr_shoot_button_use_exclude_remove", function(ply, _, args, _) ExcludeRemove(ply, args) end, ExcludeRemoveComplete, "Remove a weapon class from the shoot-button-use exclude list.", { FCVAR_NONE })
