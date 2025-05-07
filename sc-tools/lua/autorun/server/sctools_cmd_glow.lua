---@param str string
---@return table
local function _StringToTable(str)
  local tbl = {}
  for key in string.gmatch(str, "([^|]+)") do
    tbl[key] = true
  end

  DevMsgN(table.ToString(tbl, "gc(tbl)", true))
  return tbl
end

---@param tbl table
---@return string
local function _TableToString(tbl)
  local str = ""
  for k, v in SortedPairs(tbl) do
    if v then str = str == "" and k or str .. "|" .. k end
  end

  DevMsgN("gc(str): ", str)
  return str
end

--[[
######################
#     GLOW CLASS     #
######################
]]
local cvGlowClass = "sc_glow_class"
--
---@param args table
concommand.Add("sc_glow_add_class", function(_, _, args, _)
  local classes = GetConVar(cvGlowClass):GetString()
  local classesTable = _StringToTable(classes)
  classesTable[args[1]] = true
  GetConVar(cvGlowClass):SetString(_TableToString(classesTable))
end, nil, "Make entities with given class to glow", { FCVAR_NONE })
--
---@param args table
concommand.Add("sc_glow_remove_class", function(_, _, args, _)
  local classes = GetConVar(cvGlowClass):GetString()
  local classesTable = _StringToTable(classes)
  classesTable[args[1]] = nil
  GetConVar(cvGlowClass):SetString(_TableToString(classesTable))
end, nil, "Stop entities with given class from glowing", { FCVAR_NONE })
--[[
######################
#     GLOW MODEL     #
######################
]]
local cvGlowModel = "sc_glow_model"
--
---@param args table
concommand.Add("sc_glow_add_model", function(_, _, args, _)
  local models = GetConVar(cvGlowModel):GetString()
  local modelsTable = _StringToTable(models)
  modelsTable[args[1]] = true
  GetConVar(cvGlowModel):SetString(_TableToString(modelsTable))
end, nil, "Make entities with given model to glow", { FCVAR_NONE })
--
---@param args table
concommand.Add("sc_glow_remove_model", function(_, _, args, _)
  local models = GetConVar(cvGlowModel):GetString()
  local modelsTable = _StringToTable(models)
  modelsTable[args[1]] = nil
  GetConVar(cvGlowModel):SetString(_TableToString(modelsTable))
end, nil, "Stop entities with given model from glowing", { FCVAR_NONE })
--[[
###########################
#     GLOW TARGETNAME     #
###########################
]]
local cvGlowName = "sc_glow_name"
--
---@param args table
concommand.Add("sc_glow_add_name", function(_, _, args, _)
  local names = GetConVar(cvGlowName):GetString()
  local namesTable = _StringToTable(names)
  namesTable[args[1]] = true
  GetConVar(cvGlowName):SetString(_TableToString(namesTable))
end, nil, "Make entities with given targetname to glow", { FCVAR_NONE })
--
---@param args table
concommand.Add("sc_glow_remove_name", function(_, _, args, _)
  local names = GetConVar(cvGlowName):GetString()
  local namesTable = _StringToTable(names)
  namesTable[args[1]] = nil
  GetConVar(cvGlowName):SetString(_TableToString(namesTable))
end, nil, "Stop entities with given targetname from glowing", { FCVAR_NONE })
