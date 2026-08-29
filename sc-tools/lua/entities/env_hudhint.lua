-- env_hudhint is not available in GMod
local nw = "SCTOOLS_env_hudhint_message"
if SERVER then util.AddNetworkString(nw) end
--
DEFINE_BASECLASS("sc_point")
ENT.Base = "sc_point"
ENT.Type = "point"
--
local SF_HUDHINT_ALLPLAYERS = 1
--
---@param value string|nil
---@param fallback number
---@return number
local function NumberFromString(value, fallback)
  if not isstring(value) then return fallback end
  return tonumber(value) or fallback
end

---@param msg string
---@param ent Entity
---@param activator Entity
---@return nil
local function SendHudHint(msg, ent, activator)
  ---@diagnostic disable-next-line: undefined-field
  local all_plys = bit.band(ent.SpawnFlags or ent:GetSpawnFlags(), SF_HUDHINT_ALLPLAYERS) ~= 0
  if not all_plys and (not IsValid(activator) or not activator:IsPlayer()) then return end
  net.Start(nw)
  net.WriteString(msg)
  if all_plys then
    net.Broadcast()
  else
    net.Send(activator)
  end
end

---@param activator Entity
---@return nil
function ENT:InputHideHudHint(activator, _, _)
  SendHudHint("", self, activator)
end

---@param activator Entity
---@return nil
function ENT:InputShowHudHint(activator, _, _)
  local vmsg = self.Message
  ---@cast vmsg string
  if vmsg == nil or vmsg == "" then
    local name = self:GetName()
    if name == nil or name == "" then
      ErrorNoHalt("[ERROR] [env_hudhint] Value of the 'message' key is empty!\n")
      -- No need to return here because other code won't be executed anyway
    else
      ErrorNoHalt("[ERROR] [env_hudhint: ", name, "] Value of the 'message' key is empty!\n")
      -- No need to return here because other code won't be executed anyway
    end
  else
    SendHudHint(vmsg, self, activator)
  end
end

---@param key string
---@param value string
---@return nil
function ENT:SCApplyKeyValue(key, value)
  local lkey = key:lower()
  if lkey == "message" then
    self.Message = value
  elseif lkey == "spawnflags" then
    self.SpawnFlags = math.floor(NumberFromString(value, 0))
  else
    ---@diagnostic disable-next-line: inject-field
    self[key] = value
  end
end
