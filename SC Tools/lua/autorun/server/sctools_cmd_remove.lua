require("sctools")
local c_GetAllConstrainedEntities = constraint.GetAllConstrainedEntities
local c_RemoveAll = constraint.RemoveAll
local GetTraceEntity = sctools.GetTraceEntity
local IsSuperAdmin = sctools.IsSuperAdmin
local RemoveEntity = sctools.RemoveEntity
--
--[[
######################
#     REMOVE ALL     #
######################
]]
local function RemoveAll(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local e = GetTraceEntity(p)
  if IsValid(e) and not e:IsPlayer() then
    local cons = c_GetAllConstrainedEntities(e)
    for _, t in pairs(cons) do
      RemoveEntity(t)
    end

    RemoveEntity(e)
  end
end

concommand.Add("sc_remove_all", RemoveAll, nil, "Remove every entities that are connected to the entity you are looking at.", FCVAR_NONE)
--[[
##############################
#     REMOVE CONSTRAINTS     #
##############################
]]
local function RemoveConstraints(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local e = GetTraceEntity(p)
  if IsValid(e) and not e:IsPlayer() then c_RemoveAll(e) end
end

concommand.Add("sc_remove_constraints", RemoveConstraints, nil, "Remove constraints from the entity you are looking at.", FCVAR_NONE)
--[[
######################
#     REMOVE ONE     #
######################
]]
local function RemoveOne(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local e = GetTraceEntity(p)
  if IsValid(e) and not e:IsPlayer() then RemoveEntity(e) end
end

concommand.Add("sc_remove", RemoveOne, nil, "Remove the entity you are looking at.", FCVAR_NONE)
