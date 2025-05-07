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
--
local function _GetGod(ent)
  return sctools.protect[ent]
end

---@param ent Entity
local function _SetGod(ent)
  if IsValid(ent) and (ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer()) then
    sctools.protect[ent] = true
    if ent:IsPlayer() and GetConVar("sc_auto_god_mode"):GetBool() then
      ---@cast ent Player
      ent:GodEnable()
    end
  end
end

---@param ent Entity
local function _UnsetGod(ent)
  if IsValid(ent) and (ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer()) then
    sctools.protect[ent] = nil
    if ent:IsPlayer() then
      ---@cast ent Player
      ent:GodDisable()
    end
  end
end
--[[
########################
#     AUTO GOD NPC     #
########################
]]
---@param ent Entity Entity to check if it is GodMode applicable NPC or not
---@param p Player Any valid Player or Entity
---@return boolean 'true' if the entity should be protected
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
  if ent:IsNPC() then
    if ent:Disposition(p) == D_HT then
      -- Remove entity that hates Player from protect table
      _UnsetGod(ent)
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

---@param target Entity
---@param dmg CTakeDamageInfo
hook.Add("EntityTakeDamage", "SCTOOLS_AutoGod_NPC_TakeDamage", function(target, dmg)
  if not IsValid(target) then return end

  -- Check if target is auto god target that slipped through my checks
  if target:IsNPC() and GetConVar("sc_auto_god_npc"):GetBool() then
    -- To check if damaged entity is friendly to Player, use first player as the attacker if attacker is not Player
    local att = dmg:GetAttacker()
    if not att:IsPlayer() and IsValid(p_GetHumans()[1]) then att = p_GetHumans()[1] end
    ---@cast att Player

    if _IsCandidateNPC(target, att) and GodMap[g_GetMap()] then
      DevEntMsgN(target, "is now GodMode (Automatic)")
      _SetGod(target)
    end
  end

  -- Process damage for entity in 'protect' table
  if _GetGod(target) and dmg:GetDamage() > 0 then
    if GetConVar("sc_auto_god_mode"):GetBool() then
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
--[[
###########################
#     AUTO GOD PLAYER     #
###########################
]]
---@param p Player
hook.Add("PlayerSpawn", "SCTOOLS_AutoGod_SuperAdmin", function(p)
  if IsSuperAdmin(p) and GetConVar("sc_auto_god_sadmin"):GetBool() then
    _SetGod(p)
    SendMessage("[SC Auto GodMode] GodMode is automatically enabled to you.", p, HUD_PRINTTALK)
    MsgN(Format("[SC Auto GodMode] Enabled automatic GodMode to %s", p:GetName()))
  end
end)
--[[
#######################
#     SET GOD NPC     #
#######################
]]
---@param p Player
concommand.Add("sc_set_god", function(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local ent = GetTraceEntity(p)
  if ent:IsNPC() or ent:IsNextBot() then
    _SetGod(ent)
    local msg = ""
    if ent:GetName() == "" then
      msg = Format("[SC GodMode] Enabled GodMode to the NPC [%s (#%s)].", ent:GetClass(), ent:EntIndex())
    else
      msg = Format("[SC GodMode] Enabled GodMode to the NPC [%s (#%s, %s)].", ent:GetClass(), ent:EntIndex(), ent:GetName())
    end

    SendMessage(msg, p)
  end
end, nil, "Enable GodMode to the NPC you're looking at.", { FCVAR_NONE })

---@param p Player
concommand.Add("sc_unset_god", function(p, _, _, _)
  if not IsSuperAdmin(p) then return end
  local ent = GetTraceEntity(p)
  if IsValid(ent) and ent:IsNPC() or ent:IsNextBot() then
    _UnsetGod(ent)
    local msg = ""
    if ent:GetName() == "" then
      msg = Format("[SC GodMode] Disabled GodMode to the NPC [%s (#%s)].", ent:GetClass(), ent:EntIndex())
    else
      msg = Format("[SC GodMode] Disabled GodMode to the NPC [%s (#%s, %s)].", ent:GetClass(), ent:EntIndex(), ent:GetName())
    end

    SendMessage(msg, p)
  end
end, nil, "Disable GodMode to the NPC you're looking at.", { FCVAR_NONE })
--[[
##########################
#     SET GOD PLAYER     #
##########################
]]
concommand.Add("sc_god", function(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 then SendMessage("[SC GodMode] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    if _GetGod(p) then
      _UnsetGod(p)
      SendMessage(Format("[SC GodMode] GodMode is disabled to %s.", p:GetName()), ply)
      SendMessage("[SC GodMode] You are now not in GodMode.", p, HUD_PRINTTALK)
    else
      _SetGod(p)
      SendMessage(Format("[SC GodMode] GodMode is enabled to %s.", p:GetName()), ply)
      SendMessage("[SC GodMode] You are now in GodMode.", p, HUD_PRINTTALK)
    end
  end
end, function(_, args)
  return SuggestPlayer("sc_god", args)
end, "Toggle GodMode for the player.", { FCVAR_NONE })
