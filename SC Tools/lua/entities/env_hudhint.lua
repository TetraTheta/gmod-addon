-- env_hudhint is not available in GMod
if SERVER then util.AddNetworkString("SCReplacerHudhintMessage") end
--
ENT.Base = "base_point"
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true
ENT.Type = "point"
--
function ENT:AcceptInput(inputName, activator, _, _)
  if SERVER and activator:IsPlayer() and inputName == "ShowHudHint" then
    local vmsg = self["message"]
    if vmsg == nil or vmsg == "" then
      print("'message' of 'env_hudhint' is empty!")
      return
    end

    net.Start("SCReplacerHudhintMessage")
    net.WriteString(vmsg)
    net.Send(activator)
  end
end

function ENT:Draw()
end

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
  self[key] = value
end
