-- Reload weapon automatically after holstering
if not ConVarExists("sk_auto_reload_time") then
  CreateConVar("sk_auto_reload_time", "3", { FCVAR_REPLICATED }, "Seconds before holstered weapons silently reload.", 0)
end

local cv = GetConVar("sk_auto_reload_time")

---@param wep Weapon
---@return string
local function TimerName(wep)
  return "PR_WeaponAutoReload_" .. wep:EntIndex()
end

--[[
################
#     HOOK     #
################
]]

---@param ply Player
---@param old_wep Weapon
---@param new_wep Weapon
hook.Add("PlayerSwitchWeapon", "PR_Weapon_Auto_Reload_Switch", function(ply, old_wep, new_wep)
  if IsValid(new_wep) then timer.Remove(TimerName(new_wep)) end
  if not IsValid(old_wep) or old_wep == new_wep then return end
  if not cv then cv = GetConVar("sk_auto_reload_time") end
  timer.Create(TimerName(old_wep), math.max(cv and cv:GetFloat() or 3, 0), 1, function()
    if not IsValid(ply) or not IsValid(old_wep) or ply:GetActiveWeapon() == old_wep then return end
    -- Reload Primary
    local ammo_type_1 = old_wep:GetPrimaryAmmoType()
    if ammo_type_1 >= 0 then
      local ammo_total_1 = ply:GetAmmoCount(ammo_type_1)
      local clip_diff_1 = old_wep:GetMaxClip1() - old_wep:Clip1()
      if clip_diff_1 > 0 and ammo_total_1 > 0 then
        local reload_amount_1 = math.min(clip_diff_1, ammo_total_1)
        old_wep:SetClip1(old_wep:Clip1() + reload_amount_1)
        ply:SetAmmo(ammo_total_1 - reload_amount_1, ammo_type_1)
      end
    end
    -- Reload Secondary
    local ammo_type_2 = old_wep:GetSecondaryAmmoType()
    if ammo_type_2 >= 0 then
      local ammo_total_2 = ply:GetAmmoCount(ammo_type_2)
      local clip_diff_2 = old_wep:GetMaxClip2() - old_wep:Clip2()
      if clip_diff_2 > 0 and ammo_total_2 > 0 then
        local reload_amount_2 = math.min(clip_diff_2, ammo_total_2)
        old_wep:SetClip2(old_wep:Clip2() + reload_amount_2)
        ply:SetAmmo(ammo_total_2 - reload_amount_2, ammo_type_2)
      end
    end
  end)
end)
