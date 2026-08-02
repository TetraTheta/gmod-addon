require("sctools")
local b_band = bit.band
local g_GetMap = game.GetMap
local GetPlayerByName = sctools.command.GetPlayerByName
local GetTraceEntity = sctools.GetTraceEntity
local GodMap = sctools._GodMap
local GodNPC = sctools._GodNPC
local IsSuperAdmin = sctools.IsSuperAdmin
local p_GetHumans = player.GetHumans
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
--
local cv_auto_god_mode = GetConVar("sc_auto_god_mode")
local cv_auto_god_npc = GetConVar("sc_auto_god_npc")
local cv_auto_god_sadmin = GetConVar("sc_auto_god_sadmin")
--
local function GetGod(ent)
  return sctools.protect[ent]
end

---@param ent Entity
local function SetGod(ent)
  if IsValid(ent) and (ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer()) then
    sctools.protect[ent] = true
    if ent:IsPlayer() and cv_auto_god_mode:GetBool() then
      ---@cast ent Player
      ent:GodEnable()
    end
  end
end

---@param ent Entity
local function UnsetGod(ent)
  if IsValid(ent) and (ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer()) then
    sctools.protect[ent] = nil
    if ent:IsPlayer() then
      ---@cast ent Player
      ent:GodDisable()
    end
  end
end

---@param ent Entity Entity to check if it is GodMode applicable NPC or not
---@param p Player Any valid Player or Entity
---@return boolean 'true' if the entity should be protected
local function IsCandidateNPC(ent, p)
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
  if ent:IsNPC() then
    if ent:Disposition(p) == D_HT then
      -- Remove entity that hates Player from protect table
      UnsetGod(ent)
      return false
    else
      if GodNPC[class] then
        -- The NPC should be protected
        return true
      elseif class == "npc_citizen" and ent:GetInternalVariable("citizentype") == 4 and ent:GetModel() == "models/odessa.mdl" then
        -- Colonel Odessa Cubbage should be protected
        return true
      end
    end
  end
  return false
end

--[[
################
#     HOOK     #
################
]]

hook.Add("EntityTakeDamage", "SCTOOLS_AutoGod_NPC_TakeDamage", function(target, dmg)
  if not IsValid(target) then return end
  -- Check if target is auto god target that slipped through my checks
  if target:IsNPC() and cv_auto_god_npc:GetBool() then
    -- To check if damaged entity is friendly to Player, use first player as the attacker if attacker is not Player
    local att = dmg:GetAttacker()
    if not att:IsPlayer() and IsValid(p_GetHumans()[1]) then att = p_GetHumans()[1] end
    ---@cast att Player
    if IsCandidateNPC(target, att) and GodMap[g_GetMap()] then
      DevEntMsgN(target, "is now GodMode (Automatic)")
      SetGod(target)
    end
  end
  -- Process damage for entity in 'protect' table
  if GetGod(target) and dmg:GetDamage() > 0 then
    if cv_auto_god_mode:GetBool() then
      -- God
      return true
    else
      -- Buddha
      local health = target:Health()
      local damage = dmg:GetDamage()
      if health > 1 and health - damage <= 0 then
        dmg:SetDamage(target:Health() - 1)
      elseif health <= 1 then
        dmg:SetDamage(0)
        return true
      end
    end
  end
end)

hook.Add("PlayerSpawn", "SCTOOLS_AutoGod_SuperAdmin", function(p)
  if not IsSuperAdmin(p) then return end
  local cv = cv_auto_god_sadmin:GetInt()
  local toggle = b_band(cv, 1) > 0
  local verbose = b_band(cv, 2) > 0
  if toggle then
    SetGod(p)
    if verbose then
      SendMessage("[SC Auto GodMode] GodMode is automatically enabled to you.", p, HUD_PRINTTALK)
      MsgN(Format("[SC Auto GodMode] Enabled automatic GodMode to %s", p:Nick()))
    end
  end
end)

--[[
#################
#    COMMAND    #
#################
]]

---@param p Player
---@param isGod boolean Will the entity the player is looking at set as GodMode?
---@param silent boolean
local function SetNPCGod(p, isGod, silent)
  if not IsSuperAdmin(p) then return end
  local ent = GetTraceEntity(p)
  if ent:IsValid() and (ent:IsNPC() or ent:IsNextBot()) then
    local ed = ""
    if isGod then
      ed = "Enabled"
      SetGod(ent)
    else
      ed = "Disabled"
      UnsetGod(ent)
    end
    if not silent then
      local msg = ""
      if ent:GetName() == "" then
        msg = Format("[SC GodMode] %s GodMode to the NPC [%s (#%s)].", ed, ent:GetClass(), ent:EntIndex())
      else
        msg = Format("[SC GodMode] %s GodMode to the NPC [%s (#%s, %s)].", ed, ent:GetClass(), ent:EntIndex(), ent:GetName())
      end
      SendMessage(msg, p)
    end
  end
end

---@param ply Player
---@param args table
---@param silent boolean
local function SetPlayerGod(ply, args, silent)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 and not silent then SendMessage("[SC GodMode] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    if GetGod(p) then
      UnsetGod(p)
      if not silent then
        SendMessage(Format("[SC GodMode] GodMode is disabled to %s.", p:Nick()), ply)
        SendMessage("[SC GodMode] You are now not in GodMode.", p, HUD_PRINTTALK)
      end
    else
      SetGod(p)
      if not silent then
        SendMessage(Format("[SC GodMode] GodMode is enabled to %s.", p:Nick()), ply)
        SendMessage("[SC GodMode] You are now in GodMode.", p, HUD_PRINTTALK)
      end
    end
  end
end

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param args string
---@return table
local function GodPlayerComplete(_, args)
  return SuggestPlayer("sc_god", args)
end

---@param args string
---@return table
local function GodPlayerSilentComplete(_, args)
  return SuggestPlayer("sc_god_s", args)
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]
--
concommand.Add("sc_set_god", function(p, _, _, _) SetNPCGod(p, true, false) end, nil, "Enable GodMode to the NPC you're looking at.", { FCVAR_NONE })
concommand.Add("sc_set_god_s", function(p, _, _, _) SetNPCGod(p, true, true) end, nil, "Enable GodMode to the NPC you're looking at. (Silent)", { FCVAR_NONE })
concommand.Add("sc_unset_god", function(p, _, _, _) SetNPCGod(p, false, false) end, nil, "Disable GodMode to the NPC you're looking at.", { FCVAR_NONE })
concommand.Add("sc_unset_god_s", function(p, _, _, _) SetNPCGod(p, false, true) end, nil, "Enable GodMode to the NPC you're looking at. (Silent)", { FCVAR_NONE })
--
concommand.Add("sc_god", function(ply, _, args, _) SetPlayerGod(ply, args, false) end, GodPlayerComplete, "Toggle GodMode for the player.", { FCVAR_NONE })
concommand.Add("sc_god_s", function(ply, _, args, _) SetPlayerGod(ply, args, true) end, GodPlayerSilentComplete, "Toggle GodMode for the player. (Silent)", { FCVAR_NONE })
