-- Base of every SC Tools' point entity
DEFINE_BASECLASS("base_point")
ENT.Base = "base_point"
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true
ENT.Type = "point"
--
local s_gsub = string.gsub
local s_split = string.Split
local s_upper = string.upper
local t_concat = table.concat
--
---@param inputName string
---@param activator Entity
---@param caller Entity
---@param data string
function ENT:AcceptInput(inputName, activator, caller, data)
  -- All inputs must be named as 'InputInputName' (e.g., 'InputUse')
  local strInputFuncName = Format("Input%s", s_gsub(inputName, "^%l", s_upper))
  if isfunction(self[strInputFuncName]) then
    local processed = self[strInputFuncName](self, activator, caller, data)
    return processed == nil and true or processed
  elseif inputName == "AddOutput" then
    local d = s_split(data, " ")
    self:SetKeyValue(d[1], t_concat(d, "", 2):gsub(":", ","))
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

function ENT:Initialize()
end

function ENT:KeyValue(key, value)
  self[key] = value
end

function ENT:PreInitialize()
end
