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
---@param args table
local function GlowClassAdd(_, _, args, _)
  local classes = GetConVar(cvGlowClass):GetString()
  local classesTable = _StringToTable(classes)
  classesTable[args[1]] = true
  GetConVar(cvGlowClass):SetString(_TableToString(classesTable))
end

---@param args table
local function GlowClassRemove(_, _, args, _)
  local classes = GetConVar(cvGlowClass):GetString()
  local classesTable = _StringToTable(classes)
  classesTable[args[1]] = nil
  GetConVar(cvGlowClass):SetString(_TableToString(classesTable))
end

concommand.Add("sc_glow_add_class", GlowClassAdd, nil, "Make entities with given class to glow", FCVAR_NONE)
concommand.Add("sc_glow_remove_class", GlowClassRemove, nil, "Stop entities with given class from glowing", FCVAR_NONE)
--[[
######################
#     GLOW MODEL     #
######################
]]
local cvGlowModel = "sc_glow_model"
---@param args table
local function GlowModelAdd(_, _, args, _)
  local models = GetConVar(cvGlowModel):GetString()
  local modelsTable = _StringToTable(models)
  modelsTable[args[1]] = true
  GetConVar(cvGlowModel):SetString(_TableToString(modelsTable))
end

---@param args table
local function GlowModelRemove(_, _, args, _)
  local models = GetConVar(cvGlowModel):GetString()
  local modelsTable = _StringToTable(models)
  modelsTable[args[1]] = nil
  GetConVar(cvGlowModel):SetString(_TableToString(modelsTable))
end

concommand.Add("sc_glow_add_model", GlowModelAdd, nil, "Make entities with given model to glow", FCVAR_NONE)
concommand.Add("sc_glow_remove_model", GlowModelRemove, nil, "Stop entities with given model from glowing", FCVAR_NONE)
--[[
###########################
#     GLOW TARGETNAME     #
###########################
]]
local cvGlowName = "sc_glow_name"
---@param args table
local function GlowNameAdd(_, _, args, _)
  local names = GetConVar(cvGlowName):GetString()
  local namesTable = _StringToTable(names)
  namesTable[args[1]] = true
  GetConVar(cvGlowName):SetString(_TableToString(namesTable))
end

---@param args table
local function GlowNameRemove(_, _, args, _)
  local names = GetConVar(cvGlowName):GetString()
  local namesTable = _StringToTable(names)
  namesTable[args[1]] = nil
  GetConVar(cvGlowName):SetString(_TableToString(namesTable))
end

concommand.Add("sc_glow_add_name", GlowNameAdd, nil, "Make entities with given targetname to glow", FCVAR_NONE)
concommand.Add("sc_glow_remove_name", GlowNameRemove, nil, "Stop entities with given targetname from glowing", FCVAR_NONE)
