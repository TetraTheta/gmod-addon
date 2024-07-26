--[[
  Commands:
  * sc_remove - Remove the object you are looking at.
  * sc_remove_all - Remove the object you are looking at, including those are connected too.
  * sc_remove_constraints - Remove constraints of the object you are looking at.

  ConVars:
  * (Shared) sc_remove_effect <0|1> - Entity remove effect type. 0 = Remove, 1 = Dissolve.
--]]
require("sctools")
local GetTraceEntity = sctools.GetTraceEntity
local IsSuperAdmin = sctools.IsSuperAdmin
local RemoveEffect = sctools.RemoveEffect
--
local function RemoveOne(ply, _, _, _)
  if not IsSuperAdmin(ply) then return end
  local ent = GetTraceEntity(ply)
  RemoveEffect(ent)
end

local function RemoveAll(ply, _, _, _)
  if not IsSuperAdmin(ply) then return end
  local ent = GetTraceEntity(ply)
  if not IsValid(ent) or ent:IsPlayer() then return end
  if CLIENT then return end
  local conEnts = constraint.GetAllConstrainedEntities(ent)
  for _, t in pairs(conEnts) do
    RemoveEffect(t)
  end

  RemoveEffect(ent)
end

local function RemoveConstraints(ply, _, _, _)
  if not IsSuperAdmin(ply) then return end
  local ent = GetTraceEntity(ply) ---@cast ent Entity
  if IsValid(ent) and not ent:IsPlayer() then
    constraint.RemoveAll(ent)
  end
end

concommand.Add("sc_remove", RemoveOne, nil, "Remove the object you are looking at.", FCVAR_NONE)
concommand.Add("sc_remove_all", RemoveAll, nil, "Remove the object you are looking at, including those are connected too.", FCVAR_NONE)
concommand.Add("sc_remove_constraints", RemoveConstraints, nil, "Remove constraints of the object you are looking at.", FCVAR_NONE)
