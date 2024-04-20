--[[
  NOTE

  If I declare local function/variable here, it won't be detected in other files even if this file is included via 'include()'.
  Declare this file as module, or define function/variable as global to use them in other files.
]]
--
include("autorun/sc_tools_config.lua")
--
---Check if given player is SuperAdmin
---@param target Player Player to check for SuperAdmin
---@return boolean result true if the player is SuerAdmin
function CheckSAdmin(target)
  return IsValid(target) and target:IsPlayer() and target:IsUserGroup("superadmin")
end

---Check if given entity is Console or SuperAdmin
---@param target Entity Entity to check for Console or SuperAdmin
---@return boolean result true if the entity is either Console or SuperAdmin
function CheckSAdminConsole(target)
  ---@diagnostic disable-next-line: param-type-mismatch
  return target == NULL or CheckSAdmin(target)
end

---Generate autocomplete table
---@param command string The concommand this autocompletion is for. (Same from concommand.AutoComplete)
---@param arguments string The arguments typed so far. (Same from concommand.AutoComplete)
---@param suggestPlayer boolean Should suggest player at the end of the autocompletion?
---@param ... table Subcommand of the command.
---@return table table Autocomplete Table
function GenerateAutoComplete(command, arguments, suggestPlayer, ...)
  local vargs = {...}
  local cmd = command:lower()
  local args = arguments:lower():Trim():Split(" ")
  if #args == 0 then
    local tbl = {}
    for _, v in ipairs(vargs[1]) do
      table.insert(cmd .. " " .. v)
    end
    return tbl
    -- else
    --   for i = 1, #args do
    --     for _, v in ipairs(vargs[i]) do
    --       ---TODO finish this
    --     end
    --   end
  end
  return {}
end

function SuggestPlayer(target, cmd, args)
  if string.lower(cmd) ~= string.lower(target) then return {} end
  args = string.Trim(string.lower(args))
  local suggestions = {}
  for _, hPlayer in ipairs(player.GetHumans()) do
    local lowerName = string.lower(hPlayer:GetName())
    if string.find(lowerName, args) then table.insert(suggestions, cmd .. " \"" .. hPlayer:GetName() .. "\"") end
  end
  return suggestions
end

function GetPlayerByName(name)
  local rname = ""
  if string.sub(name, 1, 1) == '"' and string.sub(name, -1) == '"' then
    rname = string.sub(name, 2, -2)
  else
    rname = name
  end

  for _, p in ipairs(player.GetHumans()) do
    if p:GetName():lower() == rname:lower() then return p end
  end
  return nil
end

function GetTraceEntity(ply)
  local tr = util.GetPlayerTrace(ply)
  tr.mask = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX)
  local trace = util.TraceLine(tr)
  if trace.Hit then return trace.Entity end
end

function HasValue(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then return true end
  end
  return false
end

function SendMessage(target, msgtype, msg)
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

function RemoveEffect(ent)
  local removeType = GetConVar("sc_remove_effect"):GetInt()
  if removeType == 0 then
    RemoveEffectRemove(ent)
  elseif removeType == 1 then
    RemoveEffectDissolve(ent)
  end
end

local dissolveCounter = 0
local dissolver -- Reuse dissolver
function RemoveEffectDissolve(ent)
  if not IsValid(ent) or ent:IsPlayer() then return false end
  if CLIENT then return true end
  -- Use alternative effect for special classes which cannot be dissolved
  local ent_class = ent:GetClass()
  if ent_class == "func_breakable" then
    ent:Fire("Break")
    return
  else
    local just_remove_classes = {"func_door_rotating", "func_physbox"}
    for _, v in ipairs(just_remove_classes) do
      if v == ent_class then
        RemoveEffectRemove(ent)
        return
      end
    end
  end
  -- https://developer.valvesoftware.com/wiki/Env_entity_dissolver
  local phys = ent:GetPhysicsObject()
  if IsValid(phys) then phys:EnableGravity(false) end
  ent:SetName("sc_dissolve_" .. dissolveCounter)
  if not IsValid(dissolver) then
    dissolver = ents.Create("env_entity_dissolver")
    dissolver:SetPos(ent:GetPos())
    dissolver:Spawn()
    dissolver:Activate()
    dissolver:SetKeyValue("magnitude", "100")
    dissolver:SetKeyValue("dissolvetype", "0")
  end

  dissolver:Fire("Dissolve", "sc_dissolve_" .. dissolveCounter)
  -- Disable collision
  ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
  ent:SetSolid(SOLID_NONE)
  ent:SetRenderFX(kRenderFxFadeFast)
  -- Use timer.Create for updating 60 sec counter
  timer.Create("SCRemoveDissolveCleanup", 60, 1, function() if IsValid(dissolver) then dissolver:Remove() end end)
end

function RemoveEffectRemove(ent)
  if not IsValid(ent) or ent:IsPlayer() then return false end
  if CLIENT then return true end
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
