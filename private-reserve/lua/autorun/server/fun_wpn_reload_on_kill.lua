-- Reload every weapon when killing NPC
local cv = GetConVar("pr_enable_kill_reload")

---@param p Player
local function ReloadAllWeapons(p)
  local weps = p:GetWeapons()
  timer.Simple(0.01, function()
    for _, wep in pairs(weps) do
      ---@cast wep Weapon
      -- Primary
      if IsValid(wep) and wep:GetPrimaryAmmoType() > -1 then
        local ammo_type_1 = wep:GetPrimaryAmmoType()
        local ammo_total_1 = p:GetAmmoCount(ammo_type_1)
        local clip_diff_1 = wep:GetMaxClip1() - wep:Clip1()
        if clip_diff_1 > 0 and ammo_total_1 > 0 then
          local reload_amount_1 = math.min(clip_diff_1, ammo_total_1)
          wep:SetClip1(wep:Clip1() + reload_amount_1)
          p:SetAmmo(ammo_total_1 - reload_amount_1, ammo_type_1)
        end
      end
      -- Secondary
      if IsValid(wep) and wep:GetSecondaryAmmoType() > -1 then
        local ammo_type_2 = wep:GetSecondaryAmmoType()
        local ammo_total_2 = p:GetAmmoCount(ammo_type_2)
        local clip_diff_2 = wep:GetMaxClip2() - wep:Clip2()
        if clip_diff_2 > 0 and ammo_total_2 > 0 then
          local reload_amount_2 = math.min(clip_diff_2, ammo_total_2)
          wep:SetClip2(wep:Clip2() + reload_amount_2)
          p:SetAmmo(ammo_total_2 - reload_amount_2, ammo_type_2)
        end
      end
    end
  end)
end

--[[
################
#     HOOK     #
################
]]

---@param ap Entity
hook.Add("PlayerDeath", "PR_Reload_On_Kill_Player", function(_, _, ap)
  if not cv then cv = GetConVar("pr_enable_kill_reload") end
  if not cv:GetBool() or not (ap:IsValid() and ap:IsPlayer()) then return end
  ---@cast ap Player
  ReloadAllWeapons(ap)
end)

---@param ap Entity
hook.Add("OnNPCKilled", "PR_Reload_On_Kill_NPC", function(_, ap, _)
  if not cv then cv = GetConVar("pr_enable_kill_reload") end
  if not cv:GetBool() or not (ap:IsValid() and ap:IsPlayer()) then return end
  ---@cast ap Player
  ReloadAllWeapons(ap)
end)
