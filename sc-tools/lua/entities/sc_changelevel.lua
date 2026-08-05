-- Custom implementation of 'trigger_changelevel' that doesn't require 'info_landmark'
--
DEFINE_BASECLASS("sc_point")
ENT.Base = "sc_point"
ENT.Type = "point"
--
function ENT:InputChangeLevel(_, _, _)
  local nmap = self.Map
  ---@cast nmap string
  if nmap ~= nil and nmap ~= "" then
    print("[sc_changelevel] Changing level to " .. nmap .. "...")
    game.ConsoleCommand("map " .. nmap .. "\n")
  else
    local name = self:GetName()
    if name == nil or name == "" then
      ErrorNoHalt("[ERROR] [sc_changelevel] Value of the 'map' key is empty!\n")
    else
      ErrorNoHalt("[ERROR] [sc_changelevel: ", name, "] Value of the 'map' key is empty!\n")
    end
  end
end

---@param key string
---@param value string
---@return nil
function ENT:SCApplyKeyValue(key, value)
  if key:lower() == "map" then
    self.Map = value
  else
    self[key] = value
  end
end
