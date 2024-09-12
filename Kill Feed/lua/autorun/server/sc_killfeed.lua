-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/base/gamemode/npc.lua

SupportNPCNick = {
  ["towerlv1"] = true,
  ["towerlv2"] = true,
  ["towerlv3"] = true,
  ["basetd"] = true,
}

util.AddNetworkString("SCKF")
util.AddNetworkString("SCKFMsg")
function SendKFNotice(victim, attacker, inflictor, custominfl, headshot, downed)
  if not attacker:IsWorld() and not IsValid(attacker) then return end
  local victimname = (victim.IsLambdaPlayer or victim:IsPlayer()) and victim:Nick() or (victim.IsZetaPlayer and victim.zetaname or victim:IsNPC() and GAMEMODE:GetDeathNoticeEntityName(victim) or SupportNPCNick[victim:GetClass()] and victim:Nick() or victim:GetClass())
  local attackerclass = attacker:GetClass()
  local attackername = (attacker.IsLambdaPlayer or attacker:IsPlayer()) and attacker:Nick() or (attacker.IsZetaPlayer and attacker.zetaname or attacker:IsNPC() and GAMEMODE:GetDeathNoticeEntityName(attacker) or SupportNPCNick[attacker:GetClass()] and attacker:Nick() or attacker:GetClass())
  local victimteam = (victim.IsLambdaPlayer or victim:IsPlayer()) and victim:Team() or 999
  local attackerteam = (attacker.IsLambdaPlayer or attacker:IsPlayer()) and attacker:Team() or 999
  local attackerWep = attacker.GetActiveWeapon
  local inflictorname = victim == attacker and "suicide" or (IsValid(inflictor) and (inflictor.l_killiconname or ((inflictor == attacker and attackerWep and IsValid(attackerWep(attacker))) and attackerWep(attacker):GetClass() or inflictor:GetClass())) or attackerclass or "UNKNOWN")
  local custominflictor = custominfl
  if custominflictor ~= nil then inflictorname = custominflictor end
  net.Start("SCKF")
  net.WriteString(attackername)
  net.WriteInt(attackerteam, 8)
  net.WriteString(victimname)
  net.WriteInt(victimteam, 8)
  net.WriteString(inflictorname)
  net.WriteBool(headshot)
  net.WriteBool(downed)
  net.Broadcast()
end

function SendKFNoticeCustom(victim, victimteam, attacker, attackerteam, inflictor, headshot, downed)
  net.Start("SCKF")
  net.WriteString(attacker)
  net.WriteInt(attackerteam, 8)
  net.WriteString(victim)
  net.WriteInt(victimteam, 8)
  net.WriteString(inflictor)
  net.WriteBool(headshot)
  net.WriteBool(downed)
  net.Broadcast()
end

local FriendlyFire = CreateConVar("aaronsfeed_friendlyfire", 0, FCVAR_ARCHIVE, "Shoud appear friendly fire message similar to CS:GO/CSS?", 0, 1)
hook.Add("OnNPCKilled", "SCKFnpcdeath", function(npc, attacker, inflictor)
  if not npc.Downed then
    SendKFNotice(npc, attacker, inflictor, nil, npc.headshoted, false)
  elseif attacker:IsWorld() and npc.Downed then
    if npc.EnemyDowned ~= nil then
      SendKFNotice(npc, npc.EnemyDowned, inflictor, "bleedout", false, false)
    else
      SendKFNotice(npc, npc, inflictor, "bleedout", false, false)
    end
  else
    SendKFNotice(npc, attacker, inflictor, nil, npc.headshoted, false)
  end
end)

hook.Add("PlayerDeath", "SCKFplayerdeath", function(player, inflictor, attacker)
  if not player.Downed then
    SendKFNotice(player, attacker, inflictor, nil, player.headshoted, false)
  elseif attacker:IsWorld() and player.Downed then
    if player.EnemyDowned ~= nil then
      SendKFNotice(player, player.EnemyDowned, inflictor, "bleedout", false, false)
    else
      SendKFNotice(player, player, inflictor, "bleedout", false, false)
    end
  else
    SendKFNotice(player, attacker, inflictor, nil, player.headshoted, false)
  end
end)

--hook.Add("PlayerDowned", "TestingDownedHookKillFeed", function(attacker, inflictor, victim) SendKFNotice(victim, attacker, inflictor, nil, victim.headshoted, true) end)
hook.Add("ScalePlayerDamage", "SCKFHeadPlayer", function(player, hitgroup, dmginfo) player.headshoted = hitgroup == HITGROUP_HEAD end)
hook.Add("ScaleNPCDamage", "SCKFHeadNPC", function(npc, hitgroup, dmginfo) npc.headshoted = hitgroup == HITGROUP_HEAD end)
hook.Add("EntityTakeDamage", "SCKFdamageHandler", function(target, dmginfo)
  if GetConVar("aaronsfeed_friendlyfire"):GetBool() then
    local attacker = dmginfo:GetAttacker()
    local inf = dmginfo:GetInflictor()
    if (not target:IsNPC() or target:GetClass() ~= "npc_lambdaplayer") and attacker ~= target then
      if attacker ~= target and (attacker:IsPlayer() or attacker.IsLambdaPlayer) and (target:IsPlayer() or target.IsLambdaPlayer) and attacker:Team() ~= TEAM_UNASSIGNED and target:Team() ~= TEAM_UNASSIGNED and attacker:Team() == target:Team() and (not target.Cooldown or target.Cooldown <= CurTime()) then
        AddFeedTeamMessage("[FRIENDLY FIRE] " .. attacker:Name() .. " attacked a teammate " .. target:Name() .. "!", Color(0, 217, 255), team.GetPlayers(attacker:Team()))
        target.Cooldown = CurTime() + 2
      end
    end
  end

  if target:IsPlayer() or target.IsLambdaPlayer or target:IsNPC() then
    local damageType = dmginfo:GetDamageType()
    target.dmgtype = damageType
    --PrintMessage(HUD_PRINTTALK, damageType)
  end
end)

function AddFeedMessage(message, color)
  net.Start("SCKFMsg")
  net.WriteString(message)
  net.WriteColor(color)
  net.Broadcast()
  net.Abort()
end

function AddFeedTeamMessage(message, color, team)
  net.Start("SCKFMsg")
  net.WriteString(message)
  net.WriteColor(color)
  net.Send(team)
  net.Abort()
end
