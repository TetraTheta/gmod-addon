require("sctools")
local c_GetAllConstrainedEntities = constraint.GetAllConstrainedEntities
local GetTraceEntity = sctools.GetTraceEntity
local IsSuperAdmin = sctools.IsSuperAdmin
local RemoveConstraintsFromEntity = sctools.RemoveConstraints
local RemoveEntity = sctools.RemoveEntity

--[[
#################
#    COMMAND    #
#################
]]

---@param ply Player
local function RemoveOne(ply)
  if not IsSuperAdmin(ply) then return end
  local e = GetTraceEntity(ply)
  if IsValid(e) and not e:IsPlayer() then RemoveEntity(e) end
end

---@param ply Player
local function RemoveAll(ply)
  if not IsSuperAdmin(ply) then return end
  local e = GetTraceEntity(ply)
  if IsValid(e) and not e:IsPlayer() then
    local cons = c_GetAllConstrainedEntities(e)
    for _, t in pairs(cons) do
      RemoveEntity(t)
    end
    RemoveEntity(e)
  end
end

---@param ply Player
local function RemoveConstraints(ply)
  if not IsSuperAdmin(ply) then return end
  RemoveConstraintsFromEntity(GetTraceEntity(ply))
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("sc_remove", function(p, _, _, _) RemoveOne(p) end, nil, "Remove the entity you are looking at.", { FCVAR_NONE })
concommand.Add("sc_remove_all", function(p, _, _, _) RemoveAll(p) end, nil, "Remove every entities that are connected to the entity you are looking at.", { FCVAR_NONE })
concommand.Add("sc_remove_constraints", function(p, _, _, _) RemoveConstraints(p) end, nil, "Remove constraints from the entity you are looking at.", { FCVAR_NONE })
