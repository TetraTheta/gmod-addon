local b_bor = bit.bor
local MsgN = MsgN
local p_GetHumans = player.GetHumans
local s_explode = string.Explode
local s_find = string.find
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
--[[
##################
#     CONFIG     #
##################
]]
--
--
local function _ReadFile(fileName, default, topComment)
  -- Check file exists
  if file.Exists(fileName, "DATA") then
    -- File exists
    local c = file.Read(fileName, "DATA")
    if c == nil then
      print("[SC Tools] Content of '" .. fileName .. "' is empty. Is this intended?")
      return {}
    else
      local tbl = string.Split(c, "\n")
      local t = {}
      for _, v in ipairs(tbl) do
        local row = string.Split(v, "#")
        local item = row[1]
        if #item > 0 then t[string.Trim(item)] = true end
      end
      return t
    end
  else
    -- File not exists
    ---@diagnostic disable-next-line: cast-type-mismatch
    local f = file.Open(fileName, "w", "DATA") ---@cast f File
    if topComment ~= nil and not table.IsEmpty(topComment) then
      for k, v in ipairs(topComment) do
        f:Write("# " .. topComment[k] .. "\n")
      end
    end

    if default ~= nil and table.Count(default) > 0 then
      for k, v in SortedPairs(default) do
        if v then f:Write(tostring(k) .. "\n") end
      end

      f:Flush()
      f:Close()
      return default
    end

    -- Close file anyway
    f:Flush()
    f:Close()
    return {}
  end
end
sctools.SMALL_MODELS = {}
sctools.SMALL_MODELS_DIRS = {}

function sctools.ReloadConfig(overwrite)
  -- Directory must be created first. This won't throw any exception, so this is fine.
  file.CreateDir("sc_tools")
  local comment = {"You can add comment using '#'.", "'#' can be either start of the line or middle of the line. Any character after '#' will be ignored."}
  if overwrite or table.IsEmpty(sctools.SMALL_MODELS) then
    local sm_default = {
      ["models/combine_apc_destroyed_gib02.mdl"] = true,
      ["models/combine_apc_destroyed_gib03.mdl"] = true,
      ["models/combine_apc_destroyed_gib04.mdl"] = true,
      ["models/combine_apc_destroyed_gib05.mdl"] = true,
      ["models/combine_apc_destroyed_gib06.mdl"] = true,
      ["models/props/cs_office/trash_can_p1.mdl"] = true,
      ["models/props/cs_office/trash_can_p2.mdl"] = true,
      ["models/props/cs_office/trash_can_p3.mdl"] = true,
      ["models/props/cs_office/trash_can_p4.mdl"] = true,
      ["models/props/cs_office/trash_can_p5.mdl"] = true,
      ["models/props/cs_office/trash_can_p7.mdl"] = true,
      ["models/props/cs_office/trash_can_p8.mdl"] = true,
      ["models/props/cs_office/water_bottle.mdl"] = true,
      ["models/props_c17/chair02a.mdl"] = true,
      ["models/props_c17/tools_pliers01a.mdl"] = true,
      ["models/props_c17/tools_wrench01a.mdl"] = true,
      ["models/props_junk/garbage_metalcan001a.mdl"] = true,
      ["models/props_junk/garbage_metalcan002a.mdl"] = true,
      ["models/props_junk/garbage_milkcarton001a.mdl"] = true,
      ["models/props_junk/garbage_milkcarton002a.mdl"] = true,
      ["models/props_junk/garbage_plasticbottle001a.mdl"] = true,
      ["models/props_junk/garbage_plasticbottle003a.mdl"] = true,
      ["models/props_junk/metal_paintcan001a.mdl"] = true,
      ["models/props_junk/metal_paintcan001b.mdl"] = true,
      ["models/props_junk/popcan01a.mdl"] = true,
      ["models/props_junk/shoe001a.mdl"] = true,
      ["models/props_lab/binderblue.mdl"] = true,
      ["models/props_lab/binderbluelabel.mdl"] = true,
      ["models/props_lab/bindergraylabel01a.mdl"] = true,
      ["models/props_lab/bindergraylabel01b.mdl"] = true,
      ["models/props_lab/bindergreen.mdl"] = true,
      ["models/props_lab/bindergreenlabel.mdl"] = true,
      ["models/props_lab/binderredlabel.mdl"] = true,
      ["models/props_lab/box01a.mdl"] = true,
      ["models/props_lab/jar01a.mdl"] = true,
      ["models/props_wasteland/cafeteria_table001a.mdl"] = true,
      ["models/props_wasteland/controlroom_chair001a.mdl"] = true
    }
    sctools.SMALL_MODELS = _ReadFile("sc_tools/small.txt", sm_default, comment)
  end

  if overwrite or table.IsEmpty(sctools.SMALL_MODELS_DIRS) then
    local smd_default = {
      ["models/gibs/"] = true,
      ["models/humans/"] = true
    }
    sctools.SMALL_MODELS_DIRS = _ReadFile("sc_tools/smallDir.txt", smd_default, comment)
  end
end

--[[
#################
#     LOCAL     #
#################
]]
--
local _dissolveCounter = 0
local _dissolver ---@cast _dissolver Entity
--
--
local function _CreateDissolver(ent)
  _dissolver = ents.Create("env_entity_dissolver") ---@diagnostic disable-line: lowercase-global
  _dissolver:SetPos(ent:GetPos())
  _dissolver:Spawn()
  _dissolver:Activate()
  _dissolver:SetKeyValue("magnitude", "100")
  _dissolver:SetKeyValue("dissolvetype", "0")
end

local function dissolve(counter)
  timer.Simple(0, function() _dissolver:Fire("Dissolve", "sc_dissolve_" .. counter) end)
end

---Dissolve entity with `env_entity_dissolver`.
---@param ent Entity
local function _EntityDissolve(ent)
  if IsValid(ent) then
    -- Disable collision
    ent:SetCollisionGroup(COLLISION_GROUP_VEHICLE_CLIP)
    --ent:SetSolid(SOLID_NONE)
    ent:SetRenderFX(kRenderFxFadeFast)
    -- Disable physics
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then phys:EnableGravity(false) end
    -- Set targetname for dissolving
    _dissolveCounter = _dissolveCounter + 1
    ent:SetName("sc_dissolve_" .. _dissolveCounter)
    -- Create dissolver if not exists
    if not IsValid(_dissolver) then _CreateDissolver(ent) end
    -- Dissolve it in next tick
    dissolve(_dissolveCounter)
    timer.Simple(1.1, function() if IsValid(ent) then ent:Remove() end end)
    -- Use timer.Create for updating 60 sec counter
    timer.Create("SCRemoveDissolveCleanup", 60, 1, function() if IsValid(_dissolver) then _dissolver:Remove() end end)
  end
end

---Remove entity like 'Remove' mode of Toolgun.
---@param ent Entity
local function _EntityRemove(ent)
  if IsValid(ent) and not ent:IsPlayer() then
    -- Remove all constraints to stop ropes from hanging around
    constraint.RemoveAll(ent)
    -- Disable collision
    ent:SetCollisionGroup(COLLISION_GROUP_VEHICLE_CLIP)
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
  end
end

---'Disable' entity. (e.g., stop moving, stop attacking)
---@param ent NPC
local function _NPCDisable(ent)
  local npcs = {
    combine_mine = {"Disarm"},
    npc_alyx = {"HolsterWeapon"},
    npc_antlion = {"DisableJump", "StopFightToPosition"},
    npc_antlionguard = {"ClearChargeTarget", "DisableBark", "DisablePreferPhysicsAttack", "StopInvestigating"},
    npc_apcdriver = {"StopFiring", "Stop"},
    npc_barnacle = {"LetGo"},
    npc_barney = {"HolsterWeapon"},
    npc_breen = {"HolsterWeapon"},
    npc_citizen = {"HolsterWeapon"},
    npc_clawscanner = {"ClearFollowTarget", "DisableSpotlight"},
    npc_combine_camera = {"Disable", "SetIdle"},
    npc_combine_s = {"HolsterWeapon", "StopPatrolling"},
    npc_combinedropship = {"StopPatrol", "SetGunRange 1"},
    npc_combinegunship = {"BlindfireOff", "OmniscientOff", "StopPatrol"},
    npc_cscanner = {"ClearFollowTarget", "DisableSpotlight"},
    npc_eli = {"HolsterWeapon"},
    npc_fisherman = {"HolsterWeapon"},
    npc_gman = {"HolsterWeapon"},
    npc_helicopter = {"DisableDeadlyShooting", "GunOff", "MissileOff", "StopPatrol"},
    npc_hunter = {"Crouch", "DisableShooting"},
    npc_kleiner = {"HolsterWeapon"},
    npc_magnusson = {"HolsterWeapon"},
    npc_manhack = {"InteractivePowerDown"},
    npc_metropolice = {"HolsterWeapon"},
    npc_missiledefense = {"HolsterWeapon"},
    npc_monk = {"HolsterWeapon"},
    npc_mossman = {"HolsterWeapon"},
    npc_rollermine = {"InteractivePowerDown", "TurnOff"},
    npc_sniper = {"DisableSniper", "StopSweeping"},
    npc_stalker = {"HolsterWeapon"},
    npc_strider = {"DisableAggressiveBehavior", "StopPatrol"},
    npc_turret_ceiling = {"Disable"},
    npc_turret_floor = {"Disable"},
    npc_turret_ground = {"Disable", "InteractivePowerDown"},
    npc_vehicledriver = {"StopFiring", "Stop"},
    npc_vortigaunt = {"HolsterWeapon"},
  }

  local class = ent:GetClass()
  if npcs[class] then
    for _, v in ipairs(npcs[class]) do
      local f, _, _ = s_find(v, " ")
      if f ~= nil and f > 0 then
        local t = s_explode(" ", v)
        ent:Fire(t[1], t[2])
      else
        ent:Fire(v)
      end
    end
  end
end

--[[
##################
#     PUBLIC     #
##################
]]
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
    _NPCDisable(ent)
    _EntityRemove(ent)
  elseif removeType == 1 then
    _NPCDisable(ent)
    local class = ent:GetClass()
    local break_class = {"func_breakable", "func_breakable_surf"}
    local remove_class = {"func_brush", "func_door", "func_door_rotating", "func_movelinear", "func_physbox"}
    for _, v in ipairs(break_class) do
      if v == class then
        ent:Fire("Break")
        return
      end
    end

    for _, v in ipairs(remove_class) do
      if v == class then
        _EntityRemove(ent)
        return
      end
    end

    _EntityDissolve(ent)
  end
end
--
return sctools
