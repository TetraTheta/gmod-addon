local e_GetAll = ents.GetAll

---@param str string
---@return table
local function StringToTable(str)
  local tbl = {}
  for key in str:gmatch("([^|]+)") do
    tbl[key] = true
  end
  DevMsgN(table.ToString(tbl, "glow(tbl)", true))
  return tbl
end

---@param tbl table
---@return string
local function TableToString(tbl)
  local str = ""
  for k, v in SortedPairs(tbl) do
    if v then str = str == "" and k or str .. "|" .. k end
  end
  DevMsgN("glow(str): ", str)
  return str
end

--[[
#################
#    COMMAND    #
#################
]]

---@param ply Player|Entity
---@return boolean
local function CanModifyGlow(ply)
  return not IsValid(ply) or not ply:IsPlayer() or ply:IsUserGroup("superadmin")
end

---@param value string
---@param prefix string
---@return boolean
local function StartsWith(value, prefix)
  return value:lower():sub(1, #prefix) == prefix:lower()
end

---@param target string
---@param args table
---@param isAdd boolean `true`: Add, `false`: Remove
local function GlowModify(ply, target, args, isAdd)
  if not CanModifyGlow(ply) or args[1] == nil or args[1] == "" then return end
  local elem_str = GetConVar(target):GetString()
  local elem_tbl = StringToTable(elem_str)
  local val = isAdd and true or nil
  elem_tbl[args[1]] = val
  GetConVar(target):SetString(TableToString(elem_tbl))
end

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param cmd string
---@param args string
---@param values table
---@return table
local function CompleteFromSet(cmd, args, values)
  local prefix = args or ""
  if prefix:lower():sub(1, #cmd) == cmd:lower() then prefix = prefix:sub(#cmd + 1) end
  prefix = prefix:Trim()
  local out = {}
  for value in SortedPairs(values) do
    if StartsWith(value, prefix) then out[#out + 1] = cmd .. " " .. value end
  end
  return out
end

---@param cmd string
---@param args string
---@return table
local function GlowAddClassComplete(cmd, args)
  local values = {}
  for _, ent in ipairs(e_GetAll()) do
    if IsValid(ent) then values[ent:GetClass():lower()] = true end
  end
  return CompleteFromSet(cmd, args, values)
end

---@param cmd string
---@param args string
---@return table
local function GlowAddModelComplete(cmd, args)
  local values = {}
  for _, ent in ipairs(e_GetAll()) do
    if IsValid(ent) then
      local model = string.lower(ent:GetModel() or "")
      if model ~= "" then values[model] = true end
    end
  end
  return CompleteFromSet(cmd, args, values)
end

---@param cmd string
---@param args string
---@return table
local function GlowAddNameComplete(cmd, args)
  local values = {}
  for _, ent in ipairs(e_GetAll()) do
    if IsValid(ent) then
      local name = string.lower(ent:GetName() or "")
      if name ~= "" then values[name] = true end
    end
  end
  return CompleteFromSet(cmd, args, values)
end

---@param convar string
---@return table
local function GetGlowConVarValues(convar)
  local cv = GetConVar(convar)
  return cv ~= nil and StringToTable(cv:GetString()) or {}
end

---@param cmd string
---@param args string
---@return table
local function GlowRemoveClassComplete(cmd, args)
  return CompleteFromSet(cmd, args, GetGlowConVarValues("sc_glow_class"))
end

---@param cmd string
---@param args string
---@return table
local function GlowRemoveModelComplete(cmd, args)
  return CompleteFromSet(cmd, args, GetGlowConVarValues("sc_glow_model"))
end

---@param cmd string
---@param args string
---@return table
local function GlowRemoveNameComplete(cmd, args)
  return CompleteFromSet(cmd, args, GetGlowConVarValues("sc_glow_name"))
end

--
--[[
##########################
#    COMMAND REGISTER    #
##########################
]]
--
concommand.Add("sc_glow_add_class", function(ply, _, args, _) GlowModify(ply, "sc_glow_class", args, true) end, GlowAddClassComplete, "Make entities with given class to glow", { FCVAR_NONE })
concommand.Add("sc_glow_remove_class", function(ply, _, args, _) GlowModify(ply, "sc_glow_class", args, false) end, GlowRemoveClassComplete, "Stop entities with given class from glowing", { FCVAR_NONE })
--
concommand.Add("sc_glow_add_model", function(ply, _, args, _) GlowModify(ply, "sc_glow_model", args, true) end, GlowAddModelComplete, "Make entities with given model to glow", { FCVAR_NONE })
concommand.Add("sc_glow_remove_model", function(ply, _, args, _) GlowModify(ply, "sc_glow_model", args, false) end, GlowRemoveModelComplete, "Stop entities with given model from glowing", { FCVAR_NONE })
--
concommand.Add("sc_glow_add_name", function(ply, _, args, _) GlowModify(ply, "sc_glow_name", args, true) end, GlowAddNameComplete, "Make entities with given targetname to glow", { FCVAR_NONE })
concommand.Add("sc_glow_remove_name", function(ply, _, args, _) GlowModify(ply, "sc_glow_name", args, false) end, GlowRemoveNameComplete, "Stop entities with given targetname from glowing", { FCVAR_NONE })
