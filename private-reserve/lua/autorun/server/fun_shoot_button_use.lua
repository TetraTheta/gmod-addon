local cv_enable = GetConVar("pr_shoot_button_use_enable")
local cv_excluded_weapons = GetConVar("pr_shoot_button_use_excluded_weapons")
local cv_unlock = GetConVar("pr_shoot_button_use_unlock")

local candidate = {
  func_button = "Press",
  func_rot_button = "Press",
  func_door = "Toggle",
  func_door_rotating = "Toggle",
  prop_door_rotating = "Toggle"
}

local function _GetExcludedWeaponClasses()
  if not cv_excluded_weapons then cv_excluded_weapons = GetConVar("pr_shoot_button_use_excluded_weapons") end

  local classes = {}
  local seen = {}
  for class in string.gmatch(cv_excluded_weapons:GetString(), "[^,%s]+") do
    class = string.lower(class)
    if not seen[class] then
      table.insert(classes, class)
      seen[class] = true
    end
  end

  return classes, seen
end

local function _GetShooterWeaponClass(ply)
  local weapon = ply:GetActiveWeapon()
  return IsValid(weapon) and weapon:GetClass() or ""
end

local function _SetExcludedWeaponClasses(classes)
  if not cv_excluded_weapons then cv_excluded_weapons = GetConVar("pr_shoot_button_use_excluded_weapons") end
  cv_excluded_weapons:SetString(table.concat(classes, " "))
end

local function _CanEditExcludedWeapons(ply)
  return not IsValid(ply) or ply:IsAdmin()
end

--[[
################
#     HOOK     #
################
]]
--
hook.Add("PostEntityFireBullets", "PR_Shoot_Button_Use", function(shooter, fb)
  if not cv_enable then cv_enable = GetConVar("pr_shoot_button_use_enable") end
  if not cv_unlock then cv_unlock = GetConVar("pr_shoot_button_use_unlock") end
  if not cv_enable:GetBool() or not fb.Trace.Hit then return end

  local ent = fb.Trace.Entity
  local ply = IsValid(fb.Attacker) and fb.Attacker or shooter
  if not (IsValid(ent) and IsValid(ply) and ply:IsPlayer() and ply:Alive()) then return end

  ---@cast ent Entity
  ---@cast ply Player

  local class = ent:GetClass()
  local action = candidate[class]
  if not action then return end

  local _, excluded = _GetExcludedWeaponClasses()
  if excluded[string.lower(_GetShooterWeaponClass(ply))] then return end

  ent["_PRNextShootButtonUse"] = ent["_PRNextShootButtonUse"] or 0
  if CurTime() < ent["_PRNextShootButtonUse"] then return end
  ent["_PRNextShootButtonUse"] = CurTime() + 0.2

  if cv_unlock:GetBool() then
    ent:Fire("Unlock")
  end

  ent:Fire(action)
end)

concommand.Add("pr_shoot_button_use_exclude_add", function(ply, _, args)
  if not _CanEditExcludedWeapons(ply) then return end

  local class = string.lower(args[1] or "")
  if class == "" then return end

  local classes, seen = _GetExcludedWeaponClasses()
  if seen[class] then return end

  table.insert(classes, class)
  _SetExcludedWeaponClasses(classes)
end)

concommand.Add("pr_shoot_button_use_exclude_remove", function(ply, _, args)
  if not _CanEditExcludedWeapons(ply) then return end

  local class = string.lower(args[1] or "")
  if class == "" then return end

  local classes = _GetExcludedWeaponClasses()
  for i = #classes, 1, -1 do
    if classes[i] == class then table.remove(classes, i) end
  end

  _SetExcludedWeaponClasses(classes)
end)
