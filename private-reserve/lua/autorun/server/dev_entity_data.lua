local b_bor = bit.bor
local u_GetPlayerTrace = util.GetPlayerTrace
local u_TraceLine = util.TraceLine
--
---@return Entity
local function _GetTraceEntity(ply)
  if not IsValid(ply) then return NULL end
  local tr = u_GetPlayerTrace(ply)
  -- MASK_SOLID(33570827): CONTENTS_SOLID(1) + CONTENTS_WINDOW(2) + CONTENTS_GRATE(8) + CONTENTS_MOVEABLE(16384) + CONTENTS_MONSTER(33554432)
  tr.mask = b_bor(MASK_SOLID, CONTENTS_AUX, CONTENTS_DEBRIS)
  local trace = u_TraceLine(tr) ---@cast trace TraceResult
  if trace.Hit then
    return trace.Entity
  else
    return NULL
  end
end

--
--[[
###########################
#     COMMAND EXECUTE     #
###########################
]]
--
local function GetEntityData(ply, args)
  local ent = _GetTraceEntity(ply)
  if ent:IsValid() then
    local keyvalues = ent:GetKeyValues()
    local savetable = ent:GetSaveTable(true)
    local luatable = ent:GetTable()
    -- Print to console
    print("========== KeyValues (Hammer KV) ==========")
    PrintTable(keyvalues)
    print("========== KeyValues (Save) ==========")
    PrintTable(savetable)
    print("========== KeyValues (Lua) ==========")
    PrintTable(luatable)
    if args[1] == "save" then
      local filename = "entdata-" .. ent:GetClass() .. "-" .. ent:GetCreationID() .. ".txt"
      local keyvalues_string = table.ToString(keyvalues, "KeyValues (Hammer KV)", true)
      local savetable_string = table.ToString(savetable, "KeyValues (Save)", true)
      local luatable_string = table.ToString(luatable, "KeyValues (Lua)", true)
      local content = keyvalues_string .. "\n" .. savetable_string .. "\n" .. luatable_string
      file.Write(filename, content)
    end
  else
    print("Invalid Entity")
  end
end

--
--[[
#################################
#     COMMAND AUTO COMPLETE     #
#################################
]]
--
---@return table
local function GetEntityDataAutoComplete(_, _, _)
  return {"get_entity_data", "get_entity_data save"}
end

--
--[[
############################
#     COMMAND REGISTER     #
############################
]]
--
concommand.Add("get_entity_data", function(ply, _, args, _) GetEntityData(ply, args) end, GetEntityDataAutoComplete, "Show entity data you're looking at.", {FCVAR_NONE})
