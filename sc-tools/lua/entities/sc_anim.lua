-- Base of every SC Tools anim entity
if SERVER then AddCSLuaFile() end
DEFINE_BASECLASS("base_anim")
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Type = "anim"
--
---@param inputName string
---@param activator Entity
---@param caller Entity
---@param data string
---@return boolean|nil
function ENT:AcceptInput(inputName, activator, caller, data)
  -- All inputs must be named as 'InputInputName' (e.g., 'InputUse')
  local inputFuncName = Format("Input%s", inputName:gsub("^%l", string.upper))
  if isfunction(self[inputFuncName]) then
    local processed = self[inputFuncName](self, activator, caller, data)
    return processed == nil and true or processed
  elseif self:AddOutputFromAcceptInput(inputName, data) then
    return true
  end
  local name = self:GetName()
  local detail = Format("Unhandled AcceptInput: %s %s %s %s", inputName, tostring(activator), tostring(caller), data)
  if name == nil or name == "" then
    ErrorNoHalt("[ERROR] [", self.ClassName, "] ", detail, "\n")
  else
    ErrorNoHalt("[ERROR] [", self.ClassName, ": ", name, "] ", detail, "\n")
  end
end

---@return nil
function ENT:InputKill(_, _, _)
  self:Remove()
end

---@return nil
function ENT:InputKillHierarchy(_, _, _)
  for _, child in pairs(self:GetChildren()) do
    child:Remove()
  end
  self:Remove()
end

---@param key string
---@param value string
---@return boolean|nil
function ENT:KeyValue(key, value)
  if self:AddOutputFromKeyValue(key, value) then return true end
  if isfunction(self.SCApplyKeyValue) then return self:SCApplyKeyValue(key, value) end
  self[key] = value
end
