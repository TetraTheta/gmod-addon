SWEP.Base = "sc_adminpistol"
-- Declaring class name here because I can't use 'self.ClassName' or 'SWEP.ClassName'.
SCAPCclassName = "sc_adminpistol_clean"
-- SWEP Information
SWEP.Category = "SC Admin Weapons"
SWEP.PrintName = "Admin Pistol (Clean)"
SWEP.Instructions = "Click to shoot, Reload to change secondary fire mode. Doesn't create bullet hole decal."
-- Prevent weapon impact decal
function SWEP:DoImpactEffect(_, _)
  return true
end

--
-- Reload
--
function SWEP:Reload()
  local owner = self:GetOwner()
  --- NPC cannot do secondary attack
  ---@cast owner Player
  if not IsFirstTimePredicted() or not owner:KeyPressed(IN_RELOAD) or self:GetNextPrimaryFire() > CurTime() then return end
  local val = self.Secondary.Mode + 1
  if val > 4 or val < 0 then val = 0 end
  self.Secondary.Mode = val
  if SERVER then
    net.Start("SCAPC_ChangeMode")
    net.WriteUInt(val, 3)
    net.Send(owner)
  end
end
