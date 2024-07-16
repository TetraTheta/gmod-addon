-- Custom implementation of 'trigger_changelevel' that doesn't require 'info_landmark'
--
ENT.Base = "base_point"
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true
ENT.Type = "point"
--
function ENT:AcceptInput(inputName, _, _, _)
  if SERVER and inputName == "ChangeLevel" then
    self:ChangeLevel()
  end
end

function ENT:ChangeLevel()
  local nmap = self.Map
  if nmap then
    print("[sc_changelevel] Changing level to " .. nmap .. "...")
    game.ConsoleCommand("map " .. nmap .. "\n")
  else
    print("[sc_changelevel] 'map' of 'sc_changelevel' is empty!")
  end
end

function ENT:Draw()
end

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
  if key:lower() == "map" then
    self.Map = value
  else
    self[key] = value
  end
end

function ENT:PreInitialize()
  self.Map = ""
end
