---@param str string
---@return table
local function _StringToTable(str)
  local tbl = {}
  for key in string.gmatch(str, "([^|]+)") do
    tbl[key] = true
  end
  return tbl
end

local cvGlowClass = "sc_glow_class"
local cvGlowModel = "sc_glow_model"
local cvGlowName = "sc_glow_name"
hook.Add("PreDrawHalos", "SCTOOLS_GlowDraw", function()
  local tbl = {} -- table with Entity
  -- class
  local classes = GetConVar(cvGlowClass):GetString()
  if classes ~= "" then
    local classesTable = _StringToTable(classes)
    for k, _ in pairs(classesTable) do
      table.Merge(tbl, ents.FindByClass(k))
    end
  end

  -- model
  local models = GetConVar(cvGlowModel):GetString()
  if models ~= "" then
    local modelsTable = _StringToTable(models)
    for k, _ in pairs(modelsTable) do
      table.Merge(tbl, ents.FindByModel(k))
    end
  end

  -- name
  local names = GetConVar(cvGlowName):GetString()
  if names ~= "" then
    local namesTable = _StringToTable(names)
    for k, _ in pairs(namesTable) do
      table.Merge(tbl, ents.FindByName(k))
    end
  end

  halo.Add(tbl, color_white, 3, 3, 2, true, true)
end)
