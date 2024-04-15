if SERVER then
  util.AddNetworkString("SCReplacerHudhintMessage")
end
--
ENT.Type = "point"
ENT.Base = "base_point"
--
function ENT:AcceptInput(inputName, activator, _, _)
  if SERVER and activator:IsPlayer() and inputName == "ShowHudHint" then
    local vmsg = self["message"]
    if vmsg == nil or vmsg == "" then
      print("'message' of 'env_hudhint' is empty!")
      return
    end

    print(vmsg)
    net.Start("SCReplacerHudhintMessage")
    net.WriteString(vmsg)
    net.Send(activator)
  end
end

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
  self[key] = value
end

function ENT:Draw()
end
