SWEP.Base = "sc_adminpistol"
-- Declaring class name here because I can't use 'self.ClassName' or 'SWEP.ClassName'.
SCAPCclassName = "sc_adminpistol_clean"
-- SWEP Information
SWEP.Category = "SC Admin Weapons"
SWEP.Spawnable = true
SWEP.AdminOnly = true
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
  self:ChangeSecondaryMode("SCAPC_ChangeMode")
end
