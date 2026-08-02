local s_gmatch = string.gmatch
local t_merge = table.Merge
--
---@param str string
---@return table
local function StringToTable(str)
  local tbl = {}
  for key in s_gmatch(str, "([^|]+)") do
    tbl[key] = true
  end
  return tbl
end

--[[
################
#     HOOK     #
################
]]

local cvGlowClass = "sc_glow_class"
local cvGlowModel = "sc_glow_model"
local cvGlowName = "sc_glow_name"

hook.Add("PreDrawHalos", "SCTOOLS_GlowDraw", function()
  local tbl = {} -- table with Entity
  -- class
  local classes = GetConVar(cvGlowClass):GetString()
  if classes ~= "" then
    local classesTable = StringToTable(classes)
    for k, _ in pairs(classesTable) do
      t_merge(tbl, ents.FindByClass(k))
    end
  end

  -- model
  local models = GetConVar(cvGlowModel):GetString()
  if models ~= "" then
    local modelsTable = StringToTable(models)
    for k, _ in pairs(modelsTable) do
      t_merge(tbl, ents.FindByModel(k))
    end
  end

  -- name
  local names = GetConVar(cvGlowName):GetString()
  if names ~= "" then
    local namesTable = StringToTable(names)
    for k, _ in pairs(namesTable) do
      t_merge(tbl, ents.FindByName(k))
    end
  end

  halo.Add(tbl, color_white, 3, 3, 2, true, true)
end)
