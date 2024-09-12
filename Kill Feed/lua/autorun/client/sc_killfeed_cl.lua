-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/base/gamemode/cl_deathnotice.lua
--[[
TODO:
- Instead of using 'HS.png' as background, use single color resembles CS:GO (preferring pure Lua instead of material)
- When using background, draw border when the kill is related to the player himself
- Replace various kill icons
]]

local FeedList = {}
local Delete = {}
local EntryX = {}
local EntryY = {}
local KFStyle = CreateClientConVar("aaronsfeed_style", 0, true, false, "[FOR TESTING PURPOSE] Change Style of Feed. 0 - Default, 1 - Oldschool, 2 - GMod like", 0, 2)
local XPosition = CreateClientConVar("aaronsfeed_x", ScrW() - 35, true, false, "This ConVar allow you to adjust X position of feed. Use this when feed is offscreen.", 0, ScrW())
local YPosition = CreateClientConVar("aaronsfeed_y", ScrH() - 1000, true, false, "This ConVar allow you to adjust Y position of feed. Use this when feed is offscreen.", 0, ScrH())
net.Receive("SCKF", function()
  local entry = {
    attacker = net.ReadString(),
    attackerTeam = net.ReadInt(8),
    victim = net.ReadString(),
    victimTeam = net.ReadInt(8),
    inflictor = net.ReadString(),
    headshot = net.ReadBool(),
    downed = net.ReadBool(),
    time = CurTime()
  }

  table.insert(FeedList, entry)
end)

net.Receive("SCKFMsg", function()
  local message = {
    message = net.ReadString(),
    color = net.ReadColor(),
    time = CurTime()
  }

  table.insert(FeedList, message)
end)

killicon.Add("falldmg", "sc_killfeed/falldmg", Color(255, 255, 255))
killicon.Add("envdmg", "sc_killfeed/envdmg", Color(255, 255, 255))
killicon.Add("killmove", "sc_killfeed/killmove", Color(255, 255, 255))
killicon.Add("bleedout", "sc_killfeed/bleedout", Color(255, 153, 0))
local function ShowFeed()
  local gradient = Material("materials/gradientKF.png")
  local HS = Material("materials/HS.png")
  local downedicon = Material("materials/downed.png")
  local XScr = GetConVar("aaronsfeed_x"):GetInt()
  local YScr = GetConVar("aaronsfeed_y"):GetInt()
  local Spacing = 25
  local HSOffset
  local SetKFStyle = GetConVar("aaronsfeed_style"):GetInt()
  for i, entry in pairs(FeedList) do
    local attacker = entry.attacker
    local attackerTeam = team.GetColor(entry.attackerTeam)
    local inflictor = entry.inflictor
    local victim = entry.victim
    local victimTeam = team.GetColor(entry.victimTeam)
    local time = entry.time
    local headshot = entry.headshot
    local downed = entry.downed
    local dmgtype = 0
    local message = entry.message
    local messagecolor = entry.color
    local HAdjust = 0
    EntryX[i] = Lerp(FrameTime() / 0.1, EntryX[i] or XScr + 1000, XScr)
    EntryY[i] = Lerp(FrameTime() / 0.1, EntryY[i] or YScr, YScr)
    if not downed then
      if dmgtype == 32 and attacker ~= victim then
        attacker = victim
        inflictor = "falldmg"
        victim = "fell to his death!"
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == victim then
        attacker = victim
        inflictor = "default"
        victim = "suicided!"
        attackerTeam = attackerTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == "trigger_hurt" then
        attacker = victim
        inflictor = "envdmg"
        victim = "took fatal damage!"
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == "func_door" then
        attacker = victim
        inflictor = "envdmg"
        victim = "got squished!"
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == "prop_ragdoll" then
        attacker = victim
        inflictor = "falldmg"
        victim = "tripped over someones body!"
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == "prop_physics" then
        attacker = victim
        victim = "got crushed by prop!"
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == "gmod_thruster" then
        attacker = victim
        victim = "got mauled by thruster!"
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == "gmod_wheel" then
        attacker = victim
        victim = "turned into pile of flesh by wheel!"
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == "env_fire" or attacker == "entityflame" then
        attacker = victim
        victim = "burned to death!"
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif attacker == "worldspawn" then
        attacker = victim
        inflictor = "falldmg"
        victim = "died."
        attackerTeam = victimTeam
        victimTeam = Color(255, 255, 255)
      elseif inflictor == "weapon_bsmod_killmove" or inflictor == "player" or inflictor == "npc_lambdaplayer" then
        inflictor = "killmove"
      end
    elseif (attacker == victim or attacker == "worldspawn") and downed then
      attacker = victim
      victim = "downed itself!"
      inflictor = "falldmg"
      attackerTeam = victimTeam
      victimTeam = Color(255, 255, 255)
    elseif (attacker == victim and inflictor == "bleedout") and downed then
      attacker = victim
      victim = "bleedout to death!"
      inflictor = "falldmg"
      attackerTeam = victimTeam
      victimTeam = Color(255, 255, 255)
    end

    surface.SetFont("TargetID")
    local AttW, AttH
    local VicW, VicH
    local WepW, WepH
    local MessW, MessH
    local WeaponAdjust
    if message == nil then
      AttW, AttH = surface.GetTextSize(attacker)
      VicW, VicH = surface.GetTextSize(victim)
      WepW, WepH = killicon.GetSize(inflictor)
    else
      attacker = ""
      victim = ""
      AttW, AttH = 0, 0
      VicW, VicH = 0, 0
      WepW, WepH = 0, 0
      MessW, MessH = surface.GetTextSize(message)
    end

    --print("Width of " .. inflictor .. ": " .. WepW)
    --print("Height of " .. inflictor .. ": ".. WepH)
    --print("Width of " .. victim .. ": " .. VicW)
    --print("Height of " .. victim .. ": ".. VicH)
    if (headshot and not downed) or (downed and not headshot) then
      HSOffset = 50
    elseif downed and headshot then
      HSOffset = 90
    else
      HSOffset = 0
    end

    if WepH > 50 and WepH < 70 then HAdjust = 8 end
    if string.sub(inflictor, 1, 5) == "arc9_" then Spacing = 40 end
    if attacker == LocalPlayer():Name() and (victim ~= LocalPlayer():Name() and victim ~= "fell to his death!" and victim ~= "suicided!" and victim ~= "took fatal damage!") then
      if SetKFStyle == 0 then
        surface.SetDrawColor(170, 170, 170, 255)
      else
        surface.SetDrawColor(170, 170, 170, 50)
      end
    elseif victim == LocalPlayer():Name() or (attacker == LocalPlayer():Name() and (victim == "fell to his death!" or victim == "suicided!" or victim == "took fatal damage!")) then
      if SetKFStyle == 0 then
        surface.SetDrawColor(150, 0, 0, 255)
      else
        surface.SetDrawColor(150, 0, 0, 100)
      end
    else
      if SetKFStyle == 0 then
        surface.SetDrawColor(0, 0, 0)
      else
        surface.SetDrawColor(0, 0, 0, 100)
      end
    end

    if attacker ~= "" and victim ~= "" then
      if SetKFStyle == 0 then
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(EntryX[i] - 650, EntryY[i] - 15, 900, 35)
      elseif SetKFStyle == 1 then
        surface.DrawRect(EntryX[i] - VicW - WepW - 50 - HSOffset - AttW - 10, EntryY[i] - 15, AttW + WepW + HSOffset + VicW + 75, 35)
      end

      draw.SimpleText(language.GetPhrase(victim), "TargetID", EntryX[i], EntryY[i], victimTeam, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
      killicon.Render(EntryX[i] - VicW - WepW - Spacing - HSOffset, EntryY[i] - 20 - HAdjust, inflictor, 255)
      draw.SimpleText(language.GetPhrase(attacker), "TargetID", EntryX[i] - VicW - WepW - HSOffset - (2 * Spacing), EntryY[i], attackerTeam, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
      if headshot and not downed then
        surface.SetMaterial(HS)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectRotated(EntryX[i] - VicW - HSOffset + 10, EntryY[i] + 2, 30, 30, 0)
      elseif downed and not headshot then
        surface.SetMaterial(downedicon)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectRotated(EntryX[i] - VicW - HSOffset + 10, EntryY[i] + 2, 50, 50, 0)
      elseif headshot and downed then
        surface.SetMaterial(HS)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectRotated(EntryX[i] - VicW - HSOffset + 60, EntryY[i] + 2, 30, 30, 0)
        surface.SetMaterial(downedicon)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectRotated(EntryX[i] - VicW - HSOffset + 10, EntryY[i] + 2, 50, 50, 0)
      end
    elseif message ~= "" or message ~= nil then
      if SetKFStyle == 0 then
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(EntryX[i] - 650, EntryY[i] - 15, 900, 35)
      elseif SetKFStyle == 1 then
        surface.DrawRect(EntryX[i] - MessW - 5, EntryY[i] - 15, MessW + 10, 35)
      end

      draw.SimpleText(message, "TargetID", EntryX[i], EntryY[i], messagecolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    if time + 9 <= CurTime() then EntryX[i] = Lerp(FrameTime() / 0.8, EntryX[i] or XScr, XScr + 10000) end
    if time + 10 <= CurTime() then table.insert(Delete, i) end
    YScr = YScr + 35
  end

  for j = #Delete, 1, -1 do
    local idx = Delete[j]
    table.remove(FeedList, idx)
    table.remove(EntryX, idx)
    table.remove(EntryY, idx)
  end

  Delete = {}
end

hook.Add("HUDPaint", "ShowRevFeed", ShowFeed)
hook.Add("DrawDeathNotice", "HideDefKF", function(x, y) return false end)
