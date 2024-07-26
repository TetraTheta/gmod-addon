local b_bor = bit.bor
local MsgN = MsgN
local p_GetHumans = player.GetHumans
local s_sub = string.sub
local u_GetPlayerTrace = util.GetPlayerTrace
local u_TraceLine = util.TraceLine
--
-- Use this module via 'require("sctools")'
sctools = {} ---@diagnostic disable-line: lowercase-global
module("sctools", package.seeall)
--
-- Clients don't need this module
if CLIENT then return end
-- Config
sctools.SMALL_MODELS = {}
sctools.SMALL_MODELS_DIRS = {}
--
---Get player by his (nick)name.<br>
---The player must be inside of the server.
---@param name string (nick)name.
---@return Player|nil result `Player` if found, `nil` if not found.
function sctools.GetPlayerByName(name)
  local rname = ""
  if s_sub(name, 1, 1) == '"' and s_sub(name, -1) == '"' then
    rname = s_sub(name, 2, -2)
  else
    rname = name
  end

  for _, p in ipairs(p_GetHumans()) do
    ---@cast p Player
    if p:GetName():lower() == rname:lower() then return p end
  end
  return nil
end

---Get entity that the player is looking at.
---@param ply Player
---@return Entity|nil `Entity` if found. `nil` if not found.
function sctools.GetTraceEntity(ply)
  local tr = u_GetPlayerTrace(ply)
  tr.mask = b_bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX)
  local trace = u_TraceLine(tr)
  if trace.Hit then
    return trace.Entity
  else
    return nil
  end
end

---Check if the table has key that have given value.
---@param tbl table Table to check for value
---@param val any Value
---@return boolean `true` if the value exists. `false` if not.
function sctools.HasValue(tbl, val)
  for _, v in pairs(tbl) do
    if v == val then return true end
  end
  return false
end

---Check if given player is SuperAdmin.<br>
---The player must be inside of the server.
---@param ent Player Player to check for SuperAdmin.
---@return boolean result `true` if the player is SuerAdmin.
function sctools.IsSuperAdmin(ent)
  return IsValid(ent) and ent:IsPlayer() and ent:IsUserGroup("superadmin")
end

---Send message to player.
---@param msg any
---@param target Entity|Player If `NULL` is passed, the message will be sent to Console.
---@param msgtype number [HUD enum](https://wiki.facepunch.com/gmod/Enums/HUD)
function sctools.SendMessage(msg, target, msgtype)
  msgtype = msgtype or HUD_PRINTCONSOLE
  if target == NULL then
    -- target is console
    MsgN(msg)
  elseif IsValid(target) and target:IsPlayer() then
    if msgtype == HUD_PRINTCENTER then
      target:PrintMessage(HUD_PRINTCENTER, msg)
    elseif msgtype == HUD_PRINTCONSOLE then
      target:PrintMessage(HUD_PRINTCONSOLE, msg)
    elseif msgtype == HUD_PRINTTALK then
      target:PrintMessage(HUD_PRINTTALK, msg)
    end
  end
end

function sctools.SuggestPlayer(target, cmd, args)
  if string.lower(cmd) ~= string.lower(target) then return {} end
  args = string.Trim(string.lower(args))
  local suggestions = {}
  for _, hPlayer in ipairs(player.GetHumans()) do
    local lowerName = string.lower(hPlayer:GetName())
    if string.find(lowerName, args) then table.insert(suggestions, cmd .. " \"" .. hPlayer:GetName() .. "\"") end
  end
  return suggestions
end

function sctools.RemoveEffect(ent)
  local removeType = GetConVar("sc_remove_effect"):GetInt()
  if removeType == 0 then
    sctools.RemoveEffectRemove(ent)
  elseif removeType == 1 then
    sctools.RemoveEffectDissolve(ent)
  end
end

local _dissolveCounter = 0
local _dissolver ---@cast _dissolver Entity
function sctools.RemoveEffectDissolve(ent)
  if not IsValid(ent) or ent:IsPlayer() then return false end
  -- Use alternative effect for special classes which cannot be dissolved
  local just_break_classes = {"func_breakable", "func_breakable_surf"}
  local just_remove_classes = {"func_brush", "func_door", "func_door_rotating", "func_physbox"}
  local ent_class = ent:GetClass()
  for _, v in ipairs(just_break_classes) do
    if v == ent_class then
      ent:Fire("Break")
      return
    end
  end
  for _, v in ipairs(just_remove_classes) do
    if v == ent_class then
      sctools.RemoveEffectRemove(ent)
      return
    end
  end

  -- https://developer.valvesoftware.com/wiki/Env_entity_dissolver
  local phys = ent:GetPhysicsObject()
  if IsValid(phys) then phys:EnableGravity(false) end
  ent:SetName("sc_dissolve_" .. _dissolveCounter)
  if not IsValid(_dissolver) then
    _dissolver = ents.Create("env_entity_dissolver") ---@diagnostic disable-line: lowercase-global
    _dissolver:SetPos(ent:GetPos())
    _dissolver:Spawn()
    _dissolver:Activate()
    _dissolver:SetKeyValue("magnitude", "100")
    _dissolver:SetKeyValue("dissolvetype", "0")
  end

  _dissolver:Fire("Dissolve", "sc_dissolve_" .. _dissolveCounter)
  -- Disable collision
  ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
  ent:SetSolid(SOLID_NONE)
  ent:SetRenderFX(kRenderFxFadeFast)
  -- Use timer.Create for updating 60 sec counter
  timer.Create("SCRemoveDissolveCleanup", 60, 1, function() if IsValid(_dissolver) then _dissolver:Remove() end end)
end

function sctools.RemoveEffectRemove(ent)
  if not IsValid(ent) or ent:IsPlayer() then return false end
  -- Remove all constraints to stop ropes from hanging around
  constraint.RemoveAll(ent)
  -- Disable collision
  ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
  ent:SetSolid(SOLID_NONE)
  -- Remove the entity after 0.1 second
  timer.Simple(0.1, function() if IsValid(ent) then ent:Remove() end end)
  -- Make the entity not solid
  ent:SetNotSolid(true)
  ent:SetMoveType(MOVETYPE_NONE)
  ent:SetNoDraw(true)
  -- Show effect
  local ed = EffectData()
  ed:SetOrigin(ent:GetPos())
  ed:SetEntity(ent)
  util.Effect("entity_remove", ed, true, true)
  return true
end

return sctools
