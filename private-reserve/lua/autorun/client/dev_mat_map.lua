-- Get materials used by map or entity
local e_GetAll = ents.GetAll
local f_Exists = file.Exists
local g_GetMap = game.GetMap
local g_GetWorld = game.GetWorld
local u_GetPlayerTrace = util.GetPlayerTrace
local u_GetModelInfo = util.GetModelInfo
local u_IsValidModel = util.IsValidModel
local u_TraceLine = util.TraceLine

---@param path string
---@return string
local function NormalizeAssetPath(path)
  path = path:Trim():lower()
  path = path:gsub("\\", "/")
  path = path:gsub("%.vmt$", "")
  path = path:gsub("%.mdl$", ".mdl")
  path = path:gsub("^materials/", "")
  return path
end

---@param mat_name string
---@return boolean
local function HasMaterial(mat_name)
  if mat_name == "" or mat_name == "** empty **" or mat_name == "**displacement**" or mat_name == "**studio**" then return false end
  local mat = Material(mat_name)
  if mat:IsError() then return false end
  local base_texture = NormalizeAssetPath(mat:GetString("$basetexture") or "")
  return base_texture == "" or f_Exists("materials/" .. base_texture .. ".vtf", "GAME")
end

---@param model_name string
---@return boolean
local function HasModel(model_name)
  return model_name ~= "" and u_IsValidModel(model_name)
end

---@param out string[]
---@param asset string
---@param exists boolean
local function AddAssetLine(out, asset, exists)
  out[#out + 1] = string.format("[%s] %s", exists and "exists" or "missing", asset)
end

---@param mat_name string
local function PrintMaterialData(mat_name)
  local mat = Material(mat_name)
  local base_texture = NormalizeAssetPath(mat:GetString("$basetexture") or "")
  local has_texture = base_texture == "" or f_Exists("materials/" .. base_texture .. ".vtf", "GAME")
  local has_mat = not mat:IsError() and has_texture
  print(string.format("[%s] %s", has_mat and "exists" or "missing", mat_name))
  if mat:IsError() then return end
  print("shader: " .. mat:GetShader())
  print("$basetexture: " .. base_texture)
  if base_texture ~= "" then print("$basetexture exists: " .. tostring(has_texture)) end
end

---@param mats table<string, boolean>
---@param mat_name string
local function AddMaterial(mats, mat_name)
  mat_name = NormalizeAssetPath(mat_name)
  if mat_name ~= "" then mats[mat_name] = HasMaterial(mat_name) end
end

---@param mats table<string, boolean>
---@param model_name string
local function AddModelMaterials(mats, model_name)
  local info = u_GetModelInfo(model_name)
  if info == nil or info.Materials == nil then return end
  local dirs = info.MaterialDirectories or { "" }
  for _, mat_name in ipairs(info.Materials) do
    for _, dir in ipairs(dirs) do
      AddMaterial(mats, dir .. mat_name)
    end
  end
end

---@param models table<string, boolean>
---@param model_name string
local function AddModel(models, model_name)
  model_name = NormalizeAssetPath(model_name)
  if model_name ~= "" and model_name:sub(1, 1) ~= "*" then models[model_name] = HasModel(model_name) end
end

---@param assets table<string, boolean>
---@return string[]
local function BuildAssetLines(assets)
  local names = {}
  for asset in pairs(assets) do
    names[#names + 1] = asset
  end
  table.sort(names)
  local lines = {}
  for _, asset in ipairs(names) do
    AddAssetLine(lines, asset, assets[asset])
  end
  return lines
end

---@param lines string[]
---@param file_name string
local function PrintAndSaveLines(lines, file_name)
  for _, line in ipairs(lines) do
    print(line)
  end
  file.Write(file_name, table.concat(lines, "\n"))
  print("wrote data/" .. file_name)
end

---@param ent Entity
---@param mats table<string, boolean>
local function AddBrushMaterials(ent, mats)
  local surfaces = ent:GetBrushSurfaces()
  if surfaces == nil then return end
  for _, surface in ipairs(surfaces) do
    local mat = surface:GetMaterial()
    if mat ~= nil then AddMaterial(mats, mat:GetName()) end
  end
end

---@return table<string, boolean>
local function GetMapBrushMaterials()
  local mats = {}
  AddBrushMaterials(g_GetWorld(), mats)
  for _, ent in ipairs(e_GetAll()) do
    if ent ~= g_GetWorld() then AddBrushMaterials(ent, mats) end
  end
  for _, ent in ipairs(e_GetAll()) do
    local model_name = ent:GetModel()
    if model_name ~= nil and model_name:sub(1, 1) ~= "*" and not model_name:EndsWith(".bsp") then AddModelMaterials(mats, model_name) end
  end
  return mats
end

---@return table<string, boolean>
local function GetMapModels()
  local models = {}
  for _, ent in ipairs(e_GetAll()) do
    local model_name = ent:GetModel()
    if model_name ~= nil and not model_name:EndsWith(".bsp") then AddModel(models, model_name) end
  end
  return models
end

---@return TraceResult
local function GetEyeTrace()
  local tr = u_GetPlayerTrace(LocalPlayer())
  return u_TraceLine(tr) --[[@as TraceResult]]
end

---@param ent Entity
---@return string[]
local function GetEntityMaterialLines(ent)
  local mats = {}
  AddBrushMaterials(ent, mats)
  local model_name = ent:GetModel()
  if model_name ~= nil and model_name:sub(1, 1) ~= "*" and not model_name:EndsWith(".bsp") then AddModelMaterials(mats, model_name) end
  for _, mat_name in ipairs(ent:GetMaterials()) do
    AddMaterial(mats, mat_name)
  end
  return BuildAssetLines(mats)
end

---@param tr TraceResult
---@return boolean
local function IsStaticPropTrace(tr)
  if tr.HitWorld == nil or tr.HitBox == nil then return false end
  local HitWorld = tr.HitWorld
  local HitBox = tr.HitBox
  ---@cast HitWorld boolean
  ---@cast HitBox number
  return HitWorld and HitBox > 0
end

--[[
#################
#    COMMAND    #
#################
]]

---@param ply Player
---@param args string[]
local function GetMapMaterial(ply, _, args, _)
  local lines = BuildAssetLines(GetMapBrushMaterials())
  if #lines == 0 then
    print("get_map_material: no brush materials found")
    return
  end
  if args[1] == "save" then
    PrintAndSaveLines(lines, "material_" .. g_GetMap() .. ".txt")
  else
    for _, line in ipairs(lines) do
      print(line)
    end
  end
end

---@param args string[]
local function GetMapModel(_, _, args, _)
  local lines = BuildAssetLines(GetMapModels())
  if #lines == 0 then
    print("get_map_model: no models found")
    return
  end
  if args[1] == "save" then
    PrintAndSaveLines(lines, "model_" .. g_GetMap() .. ".txt")
  else
    for _, line in ipairs(lines) do
      print(line)
    end
  end
end

local function GetMaterialData(_, _, _, _)
  local tr = GetEyeTrace()
  if not tr.Hit then
    print("get_material_data: nothing hit")
    return
  end
  if IsStaticPropTrace(tr) then
    print("get_material_data: hit static prop id " .. tostring(tr.HitBox))
    print("hit texture is not a reliable model material: " .. tostring(tr.HitTexture))
    return
  end
  local hit_mat = NormalizeAssetPath(tr.HitTexture or "")
  if hit_mat ~= "" and hit_mat ~= "**studio**" and hit_mat ~= "**displacement**" then
    PrintMaterialData(hit_mat)
    return
  end
  local ent = tr.Entity
  if not IsValid(ent) then
    print("get_material_data: no material data found")
    return
  end
  ---@cast ent Entity
  local lines = GetEntityMaterialLines(ent)
  if #lines == 0 then
    print("get_material_data: no material data found")
    return
  end
  print("get_material_data: " .. hit_mat .. " fallback")
  for _, line in ipairs(lines) do
    print(line)
  end
end

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param cmd string
---@param args string
---@return string[]
local function CompleteSave(cmd, args)
  local prefix = args or ""
  if prefix:lower():sub(1, #cmd) == cmd:lower() then prefix = prefix:sub(#cmd + 1) end
  prefix = prefix:Trim():lower()
  if string.sub("save", 1, #prefix) == prefix then return { cmd .. " save" } end
  return {}
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("get_map_material", GetMapMaterial, CompleteSave, "Show current map brush materials.", { FCVAR_NONE })
concommand.Add("get_map_model", GetMapModel, CompleteSave, "Show current map models.", { FCVAR_NONE })
concommand.Add("get_material_data", GetMaterialData, nil, "Show material data you are looking at.", { FCVAR_NONE })
