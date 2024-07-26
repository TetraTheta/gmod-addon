--[[
  Commands:
  * sc_setspeed <all|duck|run|slow|walk> <fast|reset> [player]
  See Also:
  * sc_boost_speed.lua
]]
--
require("sctools")
local GetPlayerByName = sctools.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
--
local function SetSpeed(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  local p
  if args[3] ~= nil then
    if args[4] ~= nil then SendMessage("[SC Heal] Only first player will be processed.", ply, HUD_PRINTCONSOLE) end
    p = GetPlayerByName(args[3])
  else
    p = ply
  end

  if not (IsValid(p) and p:IsPlayer()) then SendMessage("[SC Heal] Invalid player", ply, HUD_PRINTCONSOLE) end
  local argfunc = {}
  argfunc["all"] = function(t)
    if t == "fast" then
      p:SetCrouchedWalkSpeed(0.8)
      p:SetRunSpeed(600)
      p:SetSlowWalkSpeed(150)
      p:SetWalkSpeed(300)
      -- Values for 'sc_boost_speed'
      p.sc_default_crouch_speed = 0.8
      p.sc_default_ladder_speed = 300
    elseif t == "reset" then
      p:SetCrouchedWalkSpeed(0.3)
      p:SetRunSpeed(400)
      p:SetSlowWalkSpeed(100)
      p:SetWalkSpeed(200)
      -- Values for 'sc_boost_speed'
      p.sc_default_crouch_speed = 0.3
      p.sc_default_ladder_speed = 200
    else
      SendMessage("[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.", ply, HUD_PRINTCONSOLE)
    end
  end

  argfunc["duck"] = function(t)
    if t == "fast" then
      p:SetCrouchedWalkSpeed(0.8)
      -- Values for 'sc_boost_speed'
      p.sc_default_crouch_speed = 0.8
    elseif t == "reset" then
      p:SetCrouchedWalkSpeed(0.3)
      -- Values for 'sc_boost_speed'
      p.sc_default_crouch_speed = 0.3
    else
      SendMessage("[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.", ply, HUD_PRINTCONSOLE)
    end
  end

  argfunc["run"] = function(t)
    if t == "fast" then
      p:SetRunSpeed(600)
    elseif t == "reset" then
      p:SetRunSpeed(400)
    else
      SendMessage("[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.", ply, HUD_PRINTCONSOLE)
    end
  end

  argfunc["slow"] = function(t)
    if t == "fast" then
      p:SetSlowWalkSpeed(150)
    elseif t == "reset" then
      p:SetSlowWalkSpeed(100)
    else
      SendMessage("[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.", ply, HUD_PRINTCONSOLE)
    end
  end

  argfunc["walk"] = function(t)
    if t == "fast" then
      p:SetWalkSpeed(300)
    elseif t == "reset" then
      p:SetWalkSpeed(200)
    else
      SendMessage("[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.", ply, HUD_PRINTCONSOLE)
    end
  end

  local arglow1 = args[1]:lower()
  local arglow2 = args[2]:lower()
  if argfunc[arglow1] then
    argfunc[arglow1](arglow2)
  else
    SendMessage("[SC SetSpeed] Invalid argument: must be one of these: all, duck, run, slow, walk", ply, HUD_PRINTCONSOLE)
  end
end

concommand.Add("sc_setspeed", SetSpeed, nil, "Set player's speed", FCVAR_NONE)
