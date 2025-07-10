---@param p Player
local function _ReloadAllWeapons(p)
  local wpns = p:GetWeapons()
  timer.Simple(0.01, function()
    for _, wpn in pairs(wpns) do
      ---@cast wpn Weapon
      if IsValid(wpn) and wpn:GetPrimaryAmmoType() > -1 then
        local ammoType1 = wpn:GetPrimaryAmmoType()
        local ammoTotal1 = p:GetAmmoCount(ammoType1)
        local clipDiff1 = wpn:GetMaxClip1() - wpn:Clip1()
        if clipDiff1 > 0 and ammoTotal1 > 0 then
          local reloadAmount1 = math.min(clipDiff1, ammoTotal1)
          wpn:SetClip1(wpn:Clip1() + reloadAmount1)
          p:SetAmmo(ammoTotal1 - reloadAmount1, ammoType1)
        end
      end
      if IsValid(wpn) and wpn:GetSecondaryAmmoType() > -1 then
        local ammoType2 = wpn:GetSecondaryAmmoType()
        local ammoTotal2 = p:GetAmmoCount(ammoType2)
        local clipDiff2 = wpn:GetMaxClip2() - wpn:Clip2()
        if clipDiff2 > 0 and ammoTotal2 > 0 then
          local reloadAmount2 = math.min(clipDiff2, ammoTotal2)
          wpn:SetClip2(wpn:Clip2() + reloadAmount2)
          p:SetAmmo(ammoTotal2 - reloadAmount2, ammoType2)
        end
      end
    end
  end)
end

---@param ap Entity
hook.Add("PlayerDeath", "reloadonkill", function(_, _, ap)
  if not GetConVar("pr_enable_kill_reload"):GetBool() then return end
  if not (ap:IsValid() and ap:IsPlayer()) then return end
  ---@cast ap Player
  _ReloadAllWeapons(ap)
end)

---@param ap Entity
hook.Add("OnNPCKilled", "reloadonkill", function(_, ap, _)
  if not GetConVar("pr_enable_kill_reload"):GetBool() then return end
  if not (ap:IsValid() and ap:IsPlayer()) then return end
  ---@cast ap Player
  _ReloadAllWeapons(ap)
end)
