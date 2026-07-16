---@param str string
---@return table
local function _StringToTable(str)
  local tbl = {}
  for key in string.gmatch(str, "([^|]+)") do
    tbl[key] = true
  end

  DevMsgN(table.ToString(tbl, "glow(tbl)", true))
  return tbl
end

---@param tbl table
---@return string
local function _TableToString(tbl)
  local str = ""
  for k, v in SortedPairs(tbl) do
    if v then str = str == "" and k or str .. "|" .. k end
  end

  DevMsgN("glow(str): ", str)
  return str
end

--
--[[
###########################
#     COMMAND EXECUTE     #
###########################
]]
--
---@param ply Player|Entity
---@return boolean
local function _CanModifyGlow(ply)
  return not IsValid(ply) or not ply:IsPlayer() or ply:IsUserGroup("superadmin")
end

---@param target string
---@param args table
---@param isAdd boolean `true`: Add, `false`: Remove
local function GlowModify(ply, target, args, isAdd)
  if not _CanModifyGlow(ply) or args[1] == nil or args[1] == "" then return end
  local elem_str = GetConVar(target):GetString()
  local elem_tbl = _StringToTable(elem_str)
  local val = isAdd and true or nil
  elem_tbl[args[1]] = val
  GetConVar(target):SetString(_TableToString(elem_tbl))
end

--
--[[
#################################
#     COMMAND AUTO COMPLETE     #
#################################
]]
--
--
--[[
############################
#     COMMAND REGISTER     #
############################
]]
--
concommand.Add("sc_glow_add_class", function(ply, _, args, _) GlowModify(ply, "sc_glow_class", args, true) end, nil, "Make entities with given class to glow", { FCVAR_NONE })
concommand.Add("sc_glow_remove_class", function(ply, _, args, _) GlowModify(ply, "sc_glow_class", args, false) end, nil, "Stop entities with given class from glowing", { FCVAR_NONE })
--
concommand.Add("sc_glow_add_model", function(ply, _, args, _) GlowModify(ply, "sc_glow_model", args, true) end, nil, "Make entities with given model to glow", { FCVAR_NONE })
concommand.Add("sc_glow_remove_model", function(ply, _, args, _) GlowModify(ply, "sc_glow_model", args, false) end, nil, "Stop entities with given model from glowing", { FCVAR_NONE })
--
concommand.Add("sc_glow_add_name", function(ply, _, args, _) GlowModify(ply, "sc_glow_name", args, true) end, nil, "Make entities with given targetname to glow", { FCVAR_NONE })
concommand.Add("sc_glow_remove_name", function(ply, _, args, _) GlowModify(ply, "sc_glow_name", args, false) end, nil, "Stop entities with given targetname from glowing", { FCVAR_NONE })
