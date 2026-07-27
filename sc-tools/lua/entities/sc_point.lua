-- Base of every SC Tools' point entity
DEFINE_BASECLASS("base_point")
ENT.Base = "base_point"
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true
ENT.Type = "point"
--
---@param inputName string
---@param activator Entity
---@param caller Entity
---@param data string
function ENT:AcceptInput(inputName, activator, caller, data)
  -- All inputs must be named as 'InputInputName' (e.g., 'InputUse')
  local strInputFuncName = Format("Input%s", inputName:gsub("^%l", string.upper))
  if isfunction(self[strInputFuncName]) then
    local processed = self[strInputFuncName](self, activator, caller, data)
    return processed == nil and true or processed
  elseif inputName == "AddOutput" then
    local key, value = data:match("^(%S+)%s*(.*)$")
    if key ~= nil then
      self:SetKeyValue(key, value:gsub(":", ","))
      return true
    end
  else
    local name = self:GetName()
    local detail = Format("Unhandled AcceptInput: %s %s %s %s", inputName, tostring(activator), tostring(caller), data)
    if name == nil or name == "" then
      ErrorNoHalt("[ERROR] [", self.ClassName, "] ", detail)
    else
      ErrorNoHalt("[ERROR] [", self.ClassName, ": ", name, "] ", detail)
    end
  end
end

function ENT:InputKill(_, _, _)
  self:Remove()
end

function ENT:InputKillHierarchy(_, _, _)
  for _, v in pairs(self:GetChildren()) do
    v:Remove()
  end

  self:Remove()
end

function ENT:KeyValue(key, value)
  self[key] = value
end
