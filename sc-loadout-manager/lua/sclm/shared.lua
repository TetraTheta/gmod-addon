SCLM = SCLM or {}

SCLM.AccessPrivilege = "sclm gui"
SCLM.DataDir = "sclm"
SCLM.DataFile = SCLM.DataDir .. "/loadouts.txt"
SCLM.HookPlayerLoadout = "SCLM:PlayerLoadout"
SCLM.NetRunAction = "SCLM_RunAction"
SCLM.NetState = "SCLM_State"
SCLM.Title = "SC Loadout Manager"
SCLM.Version = "1.0.0"

---@param msg string
---@param ... any
function SCLM.Log(msg, ...)
  MsgN(string.format("[SCLM] " .. msg, ...))
end

---@param value any
---@return boolean
function SCLM.ToBool(value)
  if isbool(value) then return value end
  if isnumber(value) then return value ~= 0 end
  if not isstring(value) then return false end

  value = value:Trim():lower()
  return value == "1" or value == "true" or value == "yes" or value == "on"
end
