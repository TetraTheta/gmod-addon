--[[
  Commands:
  * sc_setspeed <all|duck|run|slow|walk> <fast|reset> [player]
  See Also:
  * sc_boost_speed.lua
]]
--
include("autorun/sc_tools_shared.lua")
local function SetSpeed(ply, _, args, _)
  if not CheckSAdmin(ply) then return end
  local p
  if args[3] ~= nil then
    if args[4] ~= nil then SendMessage(ply, HUD_PRINTCONSOLE, "[SC Heal] Only first player will be processed.") end
    p = GetPlayerByName(args[3])
  else
    p = ply
  end

  if not (IsValid(p) and p:IsPlayer()) then SendMessage(ply, HUD_PRINTCONSOLE, "[SC Heal] Invalid player") end
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
      SendMessage(ply, HUD_PRINTCONSOLE, "[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.")
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
      SendMessage(ply, HUD_PRINTCONSOLE, "[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.")
    end
  end

  argfunc["run"] = function(t)
    if t == "fast" then
      p:SetRunSpeed(600)
    elseif t == "reset" then
      p:SetRunSpeed(400)
    else
      SendMessage(ply, HUD_PRINTCONSOLE, "[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.")
    end
  end

  argfunc["slow"] = function(t)
    if t == "fast" then
      p:SetSlowWalkSpeed(150)
    elseif t == "reset" then
      p:SetSlowWalkSpeed(100)
    else
      SendMessage(ply, HUD_PRINTCONSOLE, "[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.")
    end
  end

  argfunc["walk"] = function(t)
    if t == "fast" then
      p:SetWalkSpeed(300)
    elseif t == "reset" then
      p:SetWalkSpeed(200)
    else
      SendMessage(ply, HUD_PRINTCONSOLE, "[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.")
    end
  end

  local arglow1 = args[1]:lower()
  local arglow2 = args[2]:lower()
  if argfunc[arglow1] then
    argfunc[arglow1](arglow2)
  else
    SendMessage(ply, HUD_PRINTCONSOLE, "[SC SetSpeed] Invalid argument: must be one of these: all, duck, run, slow, walk")
  end
end

local function SetSpeedAutoComplete(_, args)
  --local tblArg = string.Split(args, " ")
  --[[
  -- format: multiline
  local fullsuggestion = {
    "sc_setspeed all fast",
    "sc_setspeed all reset",
    "sc_setspeed duck fast",
    "sc_setspeed duck reset",
    "sc_setspeed run fast",
    "sc_setspeed run reset",
    "sc_setspeed slow fast",
    "sc_setspeed slow reset",
    "sc_setspeed walk fast",
    "sc_setspeed walk reset"
  }

  -- Add player list
  local tbl = {}
  for _, v in ipairs(fullsuggestion) do
    if string.StartsWith(strargs, v) then
      for _, p in ipairs(player.GetHumans()) do
        table.insert(tbl, v .. " \"" .. p:GetName():lower() .. "\"")
      end
    end
  end

  if not table.IsEmpty(tbl) then return tbl end
  ---
  -- No argument
  if strargs == nil or strargs == "" then return {"sc_setspeed all", "sc_setspeed duck", "sc_setspeed run", "sc_setspeed slow", "sc_setspeed walk"} end
  -- One argument
  if string.StartWith(strargs, "a") then
    return {"sc_setspeed all fast", "sc_setspeed all reset"}
  elseif string.StartWith(strargs, "d") then
    return {"sc_setspeed duck fast", "sc_setspeed duck reset"}
  elseif string.StartWith(strargs, "r") then
    return {"sc_setspeed run fast", "sc_setspeed run reset"}
  elseif string.StartWith(strargs, "s") then
    return {"sc_setspeed slow fast", "sc_setspeed slow reset"}
  elseif string.StartWith(strargs, "w") then
    return {"sc_setspeed walk fast", "sc_setspeed walk reset"}
  else
    -- Wrong argument
    return {"sc_setspeed all", "sc_setspeed duck", "sc_setspeed run", "sc_setspeed slow", "sc_setspeed walk"}
  end
  ]]
  --
end

concommand.Add("sc_setspeed", SetSpeed, SetSpeedAutoComplete, "Set player's speed", FCVAR_NONE)
