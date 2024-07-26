--[[
  Commands:
  * sc_god <player> - Keep the given player god mode (useful in maps that consistently remove god mode from players).
  * sc_set_god - Set the NPC you're looking at to be invulnerable.
  * sc_unset_god - Set the NPC you're looking at not to be vulnerable.

  ConVars:
  * sc_auto_god_npc <0|1> - Automatically make NPC in campaign maps invulnerable.
  * sc_auto_god_sadmin <0|1> - Automatically make users in 'superadmin' user group invulnerable.
  * sc_ignore_important <0|1> - Ignore 'important' flag of NPC
--]]
--[[
  d1_, d2_, d3_, ep1_, ep2_: Half-Life 2 (+EP1, EP2)
  ks_: Mistake Of Pythagoras
  dw_: Dangerous World
--]]
require("sctools")
local GetPlayerByName = sctools.GetPlayerByName
local GetTraceEntity = sctools.GetTraceEntity
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.SuggestPlayer
--
-- format: multiline
local map_prefix = {
  "d1_",
  "d2_",
  "d3_",
  "ep1_",
  "ep2_",
  "ks_",
  "dw_"
}

-- format: multiline
local npc_list = {
  "npc_alyx",
  "npc_barney",
  "npc_eli",
  "npc_kleiner",
  "npc_magnusson",
  "npc_monk",
  "npc_mossman",
  "npc_vortigaunt"
}

local function FilterMap(map)
  for _, prefix in ipairs(map_prefix) do
    if map:StartWith(prefix) then return true end
  end
  return false
end

local function FilterNPC(victim)
  local class = victim:GetClass()
  if table.HasValue(npc_list, class) then
    return true
  elseif class == "npc_citizen" then
    if victim:GetInternalVariable("citizentype") == 4 and victim:GetModel() == "models/odessa.mdl" then return true end
  end
  return false
end

local function ProcessDamage(victim, dmg)
  if not IsValid(victim) then return true end
  -- Set damage to 0 for 'important' entity
  if victim.important == true then
    dmg:SetDamage(0)
    MsgN("[SC God NPC] Target (", victim:GetName(), ", ", victim:GetClass(), ") is marked as important. Ignoring damage...")
    return true
  end

  -- Process damage to NPC in campaign maps
  if not GetConVar("sc_auto_god_npc"):GetBool() then return false end
  local curMap = game.GetMap()
  if FilterMap(curMap) and FilterNPC(victim) then
    if GetConVar("sc_ignore_important"):GetBool() then
      -- If 'sc_ignore_important' is set, just make the NPC killable
      victim:SetKeyValue("GameEndAlly", 0)
      victim:ClearAllOutputs()
      return false
    else
      dmg:SetDamage(0)
      MsgN("[SC Auto God NPC] Automatic God Mode is activated to the NPC (", victim:GetName(), ", ", victim:GetClass(), "). Ignoring damage...")
      return true
    end
  end
end

local function SetGodNPC(ply, _, _, _)
  if not IsSuperAdmin(ply) then return end
  local ent = GetTraceEntity(ply) ---@cast ent Entity
  if ent:IsNPC() or ent:IsNextBot() then
    ent.important = true ---@diagnostic disable-line: inject-field
    MsgN("[SC God NPC] The NPC (", ent:GetName(), ", ", ent:GetClass(), ") is set as important.")
  end
end

local function SetGodPlayer(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if args[1] ~= nil then
    if args[2] ~= nil then SendMessage("[SC God Player] Only first player will be processed.", ply, HUD_PRINTCONSOLE) end
    local p = GetPlayerByName(args[1])
    if p ~= nil and IsValid(p) and p:IsPlayer() then
      -- Attempt 1: Set 'important' to the player
      p.important = true ---@diagnostic disable-line: inject-field
      -- Attempt 2: Set God Mode to the player
      p:GodEnable()
      SendMessage("[SC God Player] God Mode is enabled to " .. p:GetName() .. ".", ply, HUD_PRINTTALK)
    end
  else
    SendMessage("[SC God Player] You must provide one player.", ply, HUD_PRINTCONSOLE)
  end
end

local function SetGodPlayerAutoComplete(cmd, args)
  return SuggestPlayer("sc_god", cmd, args)
end

local function SetGodSAdmin(ply)
  if not GetConVar("sc_auto_god_sadmin"):GetBool() then return end
  if IsSuperAdmin(ply) then
    ply:GodEnable()
    ply:ChatPrint("[SC Auto God SAdmin] God Mode is automatically activated to you.")
    MsgN("[SC Auto God SAdmin] Automatically activated God Mode to ", ply:GetName())
  end
end

local function UnsetGodNPC(ply, _, _, _)
  if not IsSuperAdmin(ply) then return end
  local ent = GetTraceEntity(ply) ---@cast ent Entity
  if ent:IsNPC() or ent:IsNextBot() then
    ent.important = nil ---@diagnostic disable-line: inject-field
    MsgN("[SC God NPC] The NPC (", ent:GetName(), ", ", ent:GetClass(), ") is no longer set as important.")
  end
end

hook.Add("EntityTakeDamage", "sc_god_npc", ProcessDamage)
hook.Add("PlayerSpawn", "sc_god_sadmin", SetGodSAdmin)
concommand.Add("sc_god", SetGodPlayer, SetGodPlayerAutoComplete, "Keep the given player god mode (useful in maps that consistently remove god mode from players).", FCVAR_NONE)
concommand.Add("sc_set_god", SetGodNPC, nil, "Set the NPC you're looking at to be invulnerable.", FCVAR_NONE)
concommand.Add("sc_unset_god", UnsetGodNPC, nil, "Set the NPC you're looking at not to be vulnerable.", FCVAR_NONE)
