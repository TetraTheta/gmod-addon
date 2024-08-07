require("sctools")
local g_GetMap = game.GetMap
local GetPlayerByName = sctools.command.GetPlayerByName
local GetTraceEntity = sctools.GetTraceEntity
local GodMap = sctools._GodMap
local GodNPC = sctools._GodNPC
local IsSuperAdmin = sctools.IsSuperAdmin
local p_GetHumans = player.GetHumans
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
--[[
########################
#     AUTO GOD NPC     #
########################
]]
---@param ent Entity Entity to check if it is GodMode applicable NPC or not
---@param p Entity|Player Any valid Player or Entity
---@return boolean
local function _IsCandidateNPC(ent, p)
  local class = ent:GetClass()
  if not IsValid(ent) then
    DevEntMsgN(ent, "is invalid.")
    return false
  end

  if not IsValid(p) then
    DevEntMsgN(p, "is invalid.")
    return false
  end

  ---@cast ent NPC
  if ent:IsNPC() and ent:Disposition(p) ~= D_HT then
    if GodNPC[class] then
      return true
    elseif class == "npc_citizen" and ent:GetInternalVariable("citizentype") == 4 and ent:GetModel() == "models/odessa.mdl" then
      return true
    end
  end
  return false
end

---@param target Entity
---@param dmg CTakeDamageInfo
local function ProcessDamage(target, dmg)
  if not (IsValid(target) and target:IsNPC() and GetConVar("sc_auto_god_npc"):GetBool()) then return end
  -- Assign variable in here (other hooks are unusable)
  local att = dmg:GetAttacker()
  if not dmg:GetAttacker():IsPlayer() and IsValid(p_GetHumans()[1]) then att = p_GetHumans()[1] end
  if _IsCandidateNPC(target, att) and GodMap[g_GetMap()] then
    DevEntMsgN(target, "is now GodMode (Automatic)")
    target.SCTOOLS_GODMODE_ENABLED = true ---@diagnostic disable-line: inject-field
  end

  -- Check GodMode
  ---@cast target NPC
  if target.SCTOOLS_GODMODE_ENABLED then ---@diagnostic disable-line: undefined-field
    if target.SCTOOLS_GODMODE_MANUAL then ---@diagnostic disable-line: undefined-field
      DevEntMsgN(target, "is in GodMode (manual)")
      return true
    else
      if target:Disposition(att) ~= D_HT then
        DevEntMsgN(target, "is in GodMode (automatic)")
        return true
      end
    end
  end
end

hook.Add("EntityTakeDamage", "SCTOOLS_AutoGod_NPC_TakeDamage", ProcessDamage)
--[[
###########################
#     AUTO GOD PLAYER     #
###########################
]]
---@param p Player
local function SetAutoGodSuperAdmin(p)
  if IsSuperAdmin(p) and GetConVar("sc_auto_god_sadmin"):GetBool() then
    p:GodEnable()
    SendMessage("[SC Auto GodMode] GodMode is automatically enabled to you.", p, HUD_PRINTTALK)
    MsgN(Format("[SC Auto GodMode] Enabled automatic GodMode to %s", p:GetName()))
  end
end

hook.Add("PlayerSpawn", "SCTOOLS_AutoGod_SuperAdmin", SetAutoGodSuperAdmin)
--[[
#######################
#     SET GOD NPC     #
#######################
]]
---@param p Player
local function SetGodNPC(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local ent = GetTraceEntity(p)
  if ent:IsNPC() or ent:IsNextBot() then
    ent.SCTOOLS_GODMODE_ENABLED = true ---@diagnostic disable-line: inject-field
    ent.SCTOOLS_GODMODE_MANUAL = true ---@diagnostic disable-line: inject-field
    local msg = ""
    if ent:GetName() == "" then
      msg = Format("[SC GodMode] Enabled GodMode to the NPC [%s (#%s)].", ent:GetClass(), ent:EntIndex())
    else
      msg = Format("[SC GodMode] Enabled GodMode to the NPC [%s (#%s, %s)].", ent:GetClass(), ent:EntIndex(), ent:GetName())
    end

    SendMessage(msg, p)
  end
end

---@param p Player
local function UnsetGodNPC(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local ent = GetTraceEntity(p)
  if IsValid(ent) and ent:IsNPC() or ent:IsNextBot() then
    ent.SCTOOLS_GODMODE_ENABLED = nil ---@diagnostic disable-line: inject-field
    ent.SCTOOLS_GODMODE_MANUAL = nil ---@diagnostic disable-line: inject-field
    local msg = ""
    if ent:GetName() == "" then
      msg = Format("[SC GodMode] Disabled GodMode to the NPC [%s (#%s)].", ent:GetClass(), ent:EntIndex())
    else
      msg = Format("[SC GodMode] Disabled GodMode to the NPC [%s (#%s, %s)].", ent:GetClass(), ent:EntIndex(), ent:GetName())
    end

    SendMessage(msg, p)
  end
end

concommand.Add("sc_set_god", SetGodNPC, nil, "Enable GodMode to the NPC you're looking at.", FCVAR_NONE)
concommand.Add("sc_unset_god", UnsetGodNPC, nil, "Disable GodMode to the NPC you're looking at.", FCVAR_NONE)
--[[
##########################
#     SET GOD PLAYER     #
##########################
]]
---@param ply Player
---@param args table
local function SetGodPlayer(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 then SendMessage("[SC GodMode] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    if p:HasGodMode() then
      p.SCTOOLS_GODMODE_ENABLED = nil ---@diagnostic disable-line: inject-field
      p.SCTOOLS_GODMODE_MANUAL = nil ---@diagnostic disable-line: inject-field
      p:GodDisable()
      SendMessage(Format("[SC GodMode] GodMode is disabled to %s.", p:GetName()), ply)
      SendMessage("[SC GodMode] You are now not in GodMode.", p, HUD_PRINTTALK)
    else
      p.SCTOOLS_GODMODE_ENABLED = true ---@diagnostic disable-line: inject-field
      p.SCTOOLS_GODMODE_MANUAL = true ---@diagnostic disable-line: inject-field
      p:GodEnable()
      SendMessage(Format("[SC GodMode] GodMode is enabled to %s.", p:GetName()), ply)
      SendMessage("[SC GodMode] You are now in GodMode.", p, HUD_PRINTTALK)
    end
  end
end

---@param args string
---@return table
local function SetGodPlayerCompletion(_, args)
  return SuggestPlayer("sc_god", args)
end

concommand.Add("sc_god", SetGodPlayer, SetGodPlayerCompletion, "Toggle GodMode for the player.", FCVAR_NONE)
