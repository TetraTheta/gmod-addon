-- It is quite surprising that these are not provided by default
local cv_dev = GetConVar("developer")
--
local level = 3
--
---`MsgN()` but only if `developer` is above 3
---@param ... any
function DevMsgN(...)
  if cv_dev:GetInt() >= level then MsgN(...) end
end

---`DevMsgN()` but for Entity
---@param ent Entity
---@param ... any
function DevEntMsgN(ent, ...)
  local entity = ""
  if CLIENT or ent:GetName() == "" then -- CLIENT can't call ent:GetName()
    entity = Format("%s (#%s) ", ent:GetClass(), ent:EntIndex())
  else
    entity = Format("%s (#%s, %s) ", ent:GetClass(), ent:EntIndex(), ent:GetName())
  end
  DevMsgN(entity, ...)
end

---`ErrorNoHalt()` but only if `developer` is above 3
---@param ... any
function DevError(...)
  if cv_dev:GetInt() >= level then ErrorNoHalt("[ERROR] ", ...) end
end

---`MsgN()` but for Entity
---@param ent Entity
function EntMsgN(ent, ...)
  local entity = ""
  if CLIENT or ent:GetName() == "" then
    entity = Format("%s (#%s) ", ent:GetClass(), ent:EntIndex())
  else
    entity = Format("%s (#%s, %s) ", ent:GetClass(), ent:EntIndex(), ent:GetName())
  end
  MsgN(entity, ...)
end
