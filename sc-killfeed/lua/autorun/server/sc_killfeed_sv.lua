--[[
#############
#    NET    #
#############
]]

-- Register the supplemental network channel used to mark headshot deaths.
util.AddNetworkString("SC_KillfeedHeadshot")

-- Keep only a short-lived per-target summary of the most recent lethal damage burst.
-- For bullets, prefer the actual pellet trace hitgroups over Scale*Damage / LastHitGroup.
local recent_hitgroups = setmetatable({}, { __mode = "k" }) -- 'key'(Player) is weak reference
local recent_hitgroup_ttl = 0.1

local function SendHeadshotMarker(is_headshot)
  net.Start("SC_KillfeedHeadshot")
  net.WriteBool(is_headshot)
  net.Broadcast()
end

---@param target Entity
---@param attacker Entity
---@return table
local function GetRecentHitgroupState(target, attacker)
  local recent = recent_hitgroups[target]
  local ct = CurTime()

  if not recent or recent.attacker ~= attacker or recent.expires_at < ct then
    recent = {
      attacker = attacker,
      expires_at = ct + recent_hitgroup_ttl,
      has_headshot = false,
      has_trace_data = false
    }
    recent_hitgroups[target] = recent
    return recent
  end

  recent.expires_at = ct + recent_hitgroup_ttl
  return recent
end

---@param target Entity
---@param attacker Entity
---@param hitgroup integer
local function RememberTraceHitgroup(target, attacker, hitgroup)
  if not (IsValid(target) and IsValid(attacker)) then return end

  local recent = GetRecentHitgroupState(target, attacker)
  recent.has_trace_data = true
  recent.has_headshot = recent.has_headshot or hitgroup == HITGROUP_HEAD
end

---@param target Entity
---@param hitgroup integer
---@param dmginfo CTakeDamageInfo
local function RememberDamageHitgroup(target, hitgroup, dmginfo)
  if not IsValid(target) then return end

  local attacker = dmginfo:GetAttacker()
  if not IsValid(attacker) then return end

  local recent = GetRecentHitgroupState(target, attacker)
  recent.has_headshot = recent.has_headshot or hitgroup == HITGROUP_HEAD
end

---@param target Entity
---@param attacker Entity
---@param fallback_hitgroup integer
---@return boolean
local function ConsumeHeadshotState(target, attacker, fallback_hitgroup)
  local recent = recent_hitgroups[target]
  recent_hitgroups[target] = nil

  if recent and recent.attacker == attacker and recent.expires_at >= CurTime() then
    if recent.has_trace_data then
      return recent.has_headshot
    end

    return recent.has_headshot or fallback_hitgroup == HITGROUP_HEAD
  end

  return fallback_hitgroup == HITGROUP_HEAD
end

--[[
##############
#    HOOK    #
##############
]]

-- Track the final trace result for every pellet. This is more reliable for shotgun killfeed
-- than only looking at ScaleNPCDamage / LastHitGroup after multiple pellets land.
hook.Add("PostEntityFireBullets", "SC_Killfeed_PostEntityFireBullets", function(_, fired_bullet)
  local tr = fired_bullet.Trace
  local attacker = fired_bullet.Attacker
  if not (tr and tr.Hit and IsValid(tr.Entity) and IsValid(attacker)) then return end

  local target = tr.Entity
  ---@cast target Entity
  ---@cast attacker Entity
  if not (target:IsPlayer() or target:IsNPC()) then return end

  RememberTraceHitgroup(target, attacker, tr.HitGroup)
end)

-- Track player hitgroups as a fallback for non-bullet damage.
hook.Add("ScalePlayerDamage", "SC_Killfeed_ScalePlayerDamage", function(ply, hitgroup, dmginfo)
  RememberDamageHitgroup(ply, hitgroup, dmginfo)
end)

-- Track NPC hitgroups as a fallback for non-bullet damage and keep the previous last-hitgroup behavior.
hook.Add("ScaleNPCDamage", "SC_Killfeed_ScaleNPCDamage", function(npc, hitgroup, dmginfo)
  npc["sc_last_hitgroup"] = hitgroup
  RememberDamageHitgroup(npc, hitgroup, dmginfo)
end)

-- Send one headshot marker per player death so the client can pair it with AddDeathNotice.
hook.Add("PlayerDeath", "SC_Killfeed_PlayerDeath", function(ply, inflictor, attacker)
  SendHeadshotMarker(ConsumeHeadshotState(ply, attacker, ply:LastHitGroup()))
end)

-- Send one headshot marker per NPC death so the client can pair it with AddDeathNotice.
hook.Add("OnNPCKilled", "SC_Killfeed_NPCDeath", function(npc, attacker, inflictor)
  local npc_class = npc:GetClass()
  if npc_class == "npc_bullseye" or npc_class == "npc_launcher" then
    recent_hitgroups[npc] = nil
    npc["sc_last_hitgroup"] = nil
    return
  end

  SendHeadshotMarker(ConsumeHeadshotState(npc, attacker, npc["sc_last_hitgroup"]))
  npc["sc_last_hitgroup"] = nil
end)
