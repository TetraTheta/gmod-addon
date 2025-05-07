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
---@param p Player
concommand.Add("sc_remove_all", function(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local e = GetTraceEntity(p)
  if IsValid(e) and not e:IsPlayer() then
    local cons = c_GetAllConstrainedEntities(e)
    for _, t in pairs(cons) do
      RemoveEntity(t)
    end

    RemoveEntity(e)
  end
end, nil, "Remove every entities that are connected to the entity you are looking at.", { FCVAR_NONE })
--[[
##############################
#     REMOVE CONSTRAINTS     #
##############################
]]
---@param p Player
concommand.Add("sc_remove_constraints", function(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local e = GetTraceEntity(p)
  if IsValid(e) and not e:IsPlayer() then c_RemoveAll(e) end
end, nil, "Remove constraints from the entity you are looking at.", { FCVAR_NONE })
--[[
######################
#     REMOVE ONE     #
######################
]]
---@param p Player
concommand.Add("sc_remove", function(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local e = GetTraceEntity(p)
  if IsValid(e) and not e:IsPlayer() then RemoveEntity(e) end
end, nil, "Remove the entity you are looking at.", { FCVAR_NONE })
