-- 'sctools' Lua module
sctools = {} ---@diagnostic disable-line: lowercase-global
sctools.command = {}
sctools.protect = {} -- GodMode (Hidden Table)
module("sctools", package.seeall)
--
if CLIENT then return end
--
-- localize functions for optimization
local b_bor = bit.bor
local c_RemoveAll = constraint.RemoveAll
local DevEntMsgN = DevEntMsgN
local ErrorNoHalt = ErrorNoHalt
local f_Exists = file.Exists
local f_Read = file.Read
local f_Write = file.Write
local p_GetHumans = player.GetHumans
local s_Explode = string.Explode
local s_find = string.find
local s_Split = string.Split
local s_sub = string.sub
local s_Trim = string.Trim
local t_insert = table.insert
local t_IsEmpty = table.IsEmpty
local u_GetPlayerTrace = util.GetPlayerTrace
local u_TraceLine = util.TraceLine
--
--[[
#################
#     LOCAL     #
#################
]]
---'Disable' NPC if applicable.
---@param ent Entity
local function _DisableNPC(ent)
  if t_IsEmpty(sctools._NPCDisable) then return end
  local class = ent:GetClass()
  if sctools._NPCDisable[class] then
    for _, v in ipairs(sctools._NPCDisable[class]) do
      local f, _, _ = s_find(v, " ")
      if f ~= nil and f > 0 then
        local t = s_Explode(" ", v)
        DevEntMsgN(ent, Format("INPUT: %s %s", t[1], t[2]))
        ent:Fire(t[1], t[2])
      else
        DevEntMsgN(ent, Format("INPUT: %s", v))
        ent:Fire(v)
      end
    end
  end
end

---Read config file and return its value as table
---@param f string Path of config file
---@return table
local function _ReadFile(f)
  local tbl = {}
  local c = ""
  if f_Exists(f, "DATA") then
    c = f_Read(f, "DATA")
    if not c then
      ErrorNoHalt("[ERROR] Can't open file: ", f)
      return tbl
    end
  else
    --ErrorNoHalt("[ERROR] File doesn't exist: ", f)
    c = f_Read("data_static/" .. f, "GAME")
    f_Write(f, c)
  end

  if c then
    local lines = s_Split(c, "\n")
    for _, line in ipairs(lines) do
      local k, v = line:match("([^|]*)|?(.*)")
      k = s_Trim(k)
      v = s_Trim(v)
      if k == "" or k:StartsWith("#") then continue end
      if v == "" then
        tbl[k] = true
      else
        local vs = s_Split(v, ":")
        tbl[k] = vs
      end
    end
  end

  return tbl
end

---Remove entity as if it were removed by Toolgun's 'Remover' tool.
---@param ent Entity
local function _RemoveEntity(ent)
  if not IsValid(ent) or ent:IsPlayer() then return end
  -- remove effect
  -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/sandbox/entities/weapons/gmod_tool/stools/remover.lua
  c_RemoveAll(ent)
  timer.Simple(1, function() if IsValid(ent) then ent:Remove() end end)
  ent:SetNotSolid(true)
  ent:SetMoveType(MOVETYPE_NONE)
  ent:SetNoDraw(true)
  local ed = EffectData()
  ed:SetOrigin(ent:GetPos())
  ed:SetEntity(ent)
  util.Effect("entity_remove", ed, true, true)
end

--
--[[
##################
#     PUBLIC     #
##################
]]
--
---Get entity that player is looking at.
---@param ply Player
---@return Entity
function sctools.GetTraceEntity(ply)
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

---Check if the player is SuperAdmin. The player must be inside of the server.
---@param p Player
---@return boolean
function sctools.IsSuperAdmin(p)
  return IsValid(p) and p:IsPlayer() and p:IsUserGroup("superadmin")
end

---Reload config of SC Tools
function sctools.ReloadConfig()
  sctools._GodMap = _ReadFile("sctools/auto_god_map.txt")
  sctools._GodNPC = _ReadFile("sctools/auto_god_npc.txt")
  sctools._NPCDisable = _ReadFile("sctools/npc_disable_input.txt")
  sctools._SmallModel = _ReadFile("sctools/small_model.txt")
  sctools._SmallModelDir = _ReadFile("sctools/small_model_dir.txt")
end

---Remove the entity with effect.
---@param ent Entity
function sctools.RemoveEntity(ent)
  if not IsValid(ent) or ent:IsPlayer() then return end
  local removeType = GetConVar("sc_remove_effect"):GetInt()
  _DisableNPC(ent)
  if removeType == 0 then
    -- Remove effect
    DevEntMsgN(ent, "RemoveEntity: Remove")
    ent.SCTOOLS_REMOVAL = true ---@diagnostic disable-line inject-field
    _RemoveEntity(ent)
  elseif removeType == 1 then
    -- Dissolve effect
    local class = ent:GetClass()
    local class_break = {
      ["func_breakable_surf"] = true,
      ["func_breakable"] = true,
    }

    local class_remove = {
      ["func_brush"] = true,
      ["func_door_rotating"] = true,
      ["func_door"] = true,
      ["func_movelinear"] = true,
      ["func_physbox"] = true,
      ["func_rotating"] = true,
      ["func_tracktrain"] = true,
    }

    if class_break[class] then
      DevEntMsgN(ent, "RemoveEntity: Break")
      ent.SCTOOLS_REMOVAL = true ---@diagnostic disable-line inject-field
      ent:Fire("Break")
    elseif class_remove[class] then
      DevEntMsgN(ent, "RemoveEntity: Remove")
      ent.SCTOOLS_REMOVAL = true ---@diagnostic disable-line inject-field
      _RemoveEntity(ent)
    else
      DevEntMsgN(ent, "RemoveEntity: Dissolve")
      ent.SCTOOLS_REMOVAL = true ---@diagnostic disable-line inject-field
      ent:Dissolve(ENTITY_DISSOLVE_NORMAL, 100) ---@diagnostic disable-line: undefined-field, undefined-global
      timer.Simple(1, function() if IsValid(ent) then ent:Remove() end end)
    end
  end
end

---Send message to player (or console if `target` is `NULL`).
---@param msg string Message to send
---@param target Entity|Player Player who will receive the message
---@param hudType integer|nil [HUD](https://wiki.facepunch.com/gmod/Enums/HUD) enum (Default: `HUD_PRINTCONSOLE`)
function sctools.SendMessage(msg, target, hudType)
  msg = isstring(msg) and msg or tostring(msg)
  if target == NULL then
    MsgN(msg)
  elseif IsValid(target) and target:IsPlayer() then
    hudType = hudType or HUD_PRINTCONSOLE
    target:PrintMessage(hudType, msg)
  end
end

--[[
###################
#     COMMAND     #
###################
]]
---Get `Player` by his name or nickname. The player must be inside of the server.
---@param name string
---@return Player `Player` if found, `NULL` if not found.
function sctools.command.GetPlayerByName(name)
  if s_sub(name, 1, 1) == "\"" and s_sub(name, -1) == "\"" then name = s_sub(2, -2) end
  for _, p in ipairs(p_GetHumans()) do ---@cast p Player
    if p:GetName():lower() == name:lower() then return p end
  end
  return NULL
end

---Return AutoComplete table for suggesting player. This only supports basic suggestion like `command_name "player name"`.
---@param cmd string
---@param args string
---@return table
function sctools.command.SuggestPlayer(cmd, args)
  args = s_Trim(args:lower())
  local tbl = {}
  for _, p in ipairs(p_GetHumans()) do ---@cast p Player
    local ln = p:GetName():lower()
    if s_find(ln, args) then t_insert(tbl, Format("%s \"%s\"", cmd, p:GetName())) end
  end
  return tbl
end

--[[
######################
#     INITIALIZE     #
######################
]]
sctools.ReloadConfig()
--
--[[
##################
#     RETURN     #
##################
]]
--
return sctools
