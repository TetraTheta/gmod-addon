-- env_hudhint is not available in GMod
if SERVER then util.AddNetworkString("SCReplacerHudhintMessage") end
--
DEFINE_BASECLASS("sc_point")
ENT.Base = "sc_point"
ENT.Type = "point"
--
function ENT:InputShowHudHint(activator, _, _)
  if not activator:IsPlayer() then return end
  local vmsg = self.Message
  if vmsg == nil or vmsg == "" then
    print("Message of 'env_hudhint' is empty.")
    return
  end

  net.Start("SCReplacerHudhintMessage")
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
