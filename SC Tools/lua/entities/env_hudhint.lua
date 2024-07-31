-- env_hudhint is not available in GMod
local nw = "SCTOOLS_env_hudhint_message"
if SERVER then util.AddNetworkString(nw) end
--
DEFINE_BASECLASS("sc_point")
ENT.Base = "sc_point"
ENT.Type = "point"
--

function ENT:InputHideHudHint(_, _, _)
  -- There is no way to hide notification.AddLegacy() message early
end

---@param activator Entity
function ENT:InputShowHudHint(activator, _, _)
  if not activator:IsPlayer() then return end
  ---@cast activator Player
  local vmsg = self.Message
  if vmsg == nil or vmsg == "" then
    local name = self:GetName()
    if name == nil or name == "" then
      ErrorNoHalt("[ERROR] [env_hudhint] Value of the 'message' key is empty!\n")
      return
    else
      ErrorNoHalt("[ERROR] [env_hudhint: ", name, "] Value of the 'message' key is empty!\n")
      return
    end
  end

  net.Start(nw)
  net.WriteString(vmsg)
  net.Send(activator)
end

function ENT:KeyValue(key, value)
  if key:lower() == "message" then
    self.Message = value
  else
    self[key] = value
  end
end

function ENT:PreInitialize()
  self.Message = ""
end
