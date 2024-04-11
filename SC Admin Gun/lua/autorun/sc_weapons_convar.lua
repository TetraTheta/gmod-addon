-- Hacky way to define ConVar early
local flags = {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY}
if not ConVarExists("sc_adminpistol_default") then CreateConVar("sc_adminpistol_default", "0", flags, "Default secondary fire mode of SC Admin Pistol", 0, 4) end
--
-- Allow ConVar to be changed from SuperAdmin
net.Receive("sc_adminpistol_default_changeconvar", function(_, ply)
  if not (IsValid(ply) and ply:IsPlayer() and ply:IsSuperAdmin()) then return end
  local command = net.ReadString()
  if command == "sc_adminpistol_default" then RunConsoleCommand("sc_adminpistol_default", net.ReadInt(3)) end
end)
