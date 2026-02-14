require("sctools")
local GetPlayerByName = sctools.command.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
--[[
###########################
#     COMMAND EXECUTE     #
###########################
]]
--
local argfunc = {
  ---@param p Player
  ---@param t string
  all = function(p, t)
    if t == "fast" then
      p:SetCrouchedWalkSpeed(0.8)
      p:SetRunSpeed(600)
      p:SetSlowWalkSpeed(150)
      p:SetWalkSpeed(300)
      p["SCTOOLS_DEF_CROUCH_SPD"] = 0.8
      p["SCTOOLS_DEF_LADDER_SPD"] = 300
    elseif t == "reset" then
      p:SetCrouchedWalkSpeed(0.3)
      p:SetRunSpeed(400)
      p:SetSlowWalkSpeed(100)
      p:SetWalkSpeed(200)
      p["SCTOOLS_DEF_CROUCH_SPD"] = 0.3
      p["SCTOOLS_DEF_LADDER_SPD"] = 200
    end
  end,
  ---@param p Player
  ---@param t string
  duck = function(p, t)
    if t == "fast" then
      p:SetCrouchedWalkSpeed(0.8)
      p["SCTOOLS_DEF_CROUCH_SPD"] = 0.8
    elseif t == "reset" then
      p:SetCrouchedWalkSpeed(0.3)
      p["SCTOOLS_DEF_CROUCH_SPD"] = 0.3
    end
  end,
  ---@param p Player
  ---@param t string
  run = function(p, t)
    if t == "fast" then
      p:SetRunSpeed(600)
    elseif t == "reset" then
      p:SetRunSpeed(400)
    end
  end,
  ---@param p Player
  ---@param t string
  slow = function(p, t)
    if t == "fast" then
      p:SetSlowWalkSpeed(150)
    elseif t == "reset" then
      p:SetSlowWalkSpeed(100)
    end
  end,
  ---@param p Player
  ---@param t string
  walk = function(p, t)
    if t == "fast" then
      p:SetWalkSpeed(300)
    elseif t == "reset" then
      p:SetWalkSpeed(200)
    end
  end
}

--
---@param ply Player
---@param args table
---@param silent boolean
local function SetSpeed(ply, args, silent)
  if not IsSuperAdmin(ply) then return end
  if #args < 2 or #args > 3 then
    if not silent then SendMessage("[SC SetSpeed] Insufficient or excessive arguments.", ply) end
    return
  end

  local arg1, arg2 = args[1]:lower(), args[2]:lower()
  if not argfunc[arg1] then
    if not silent then SendMessage("[SC SetSpeed] Invalid argument: must be one of these: all, duck, run, slow, walk", ply) end
    return
  end

  if arg2 ~= "fast" and arg2 ~= "reset" then
    if not silent then SendMessage("[SC SetSpeed] Invalid argument: must be either 'fast' or 'reset'.", ply) end
    return
  end

  local p = ply
  if #args == 3 then
    local np = GetPlayerByName(args[3])
    if IsValid(np) then
      p = np
    else
      if not silent then SendMessage("[SC SetSpeed] Cannot find the player", ply) end
      return
    end
  end

  argfunc[arg1](p, arg2)
end

--
--[[
#################################
#     COMMAND AUTO COMPLETE     #
#################################
]]
--
---@param args string
---@return table
local function SetSpeedCompletion(_, args)
  if args:StartsWith("sc_setspeed a") then
    if args:StartsWith("sc_setspeed all fast") then
      return SuggestPlayer("sc_setspeed all fast", args)
    elseif args:StartsWith("sc_setspeed all reset") then
      return SuggestPlayer("sc_setspeed all reset", args)
    else
      return { "sc_setspeed all fast ", "sc_setspeed all reset " }
    end
  elseif args:StartsWith("sc_setspeed d") then
    if args:StartsWith("sc_setspeed duck fast") then
      return SuggestPlayer("sc_setspeed duck fast", args)
    elseif args:StartsWith("sc_setspeed duck reset") then
      return SuggestPlayer("sc_setspeed duck reset", args)
    else
      return { "sc_setspeed duck fast ", "sc_setspeed duck reset " }
    end
  elseif args:StartsWith("sc_setspeed r") then
    if args:StartsWith("sc_setspeed run fast") then
      return SuggestPlayer("sc_setspeed run fast", args)
    elseif args:StartsWith("sc_setspeed run reset") then
      return SuggestPlayer("sc_setspeed run reset", args)
    else
      return { "sc_setspeed run fast ", "sc_setspeed run reset " }
    end
  elseif args:StartsWith("sc_setspeed s") then
    if args:StartsWith("sc_setspeed slow fast") then
      return SuggestPlayer("sc_setspeed slow fast", args)
    elseif args:StartsWith("sc_setspeed slow reset") then
      return SuggestPlayer("sc_setspeed slow reset", args)
    else
      return { "sc_setspeed slow fast ", "sc_setspeed slow reset " }
    end
  elseif args:StartsWith("sc_setspeed w") then
    if args:StartsWith("sc_setspeed walk fast") then
      return SuggestPlayer("sc_setspeed walk fast", args)
    elseif args:StartsWith("sc_setspeed walk reset") then
      return SuggestPlayer("sc_setspeed walk reset", args)
    else
      return { "sc_setspeed walk fast ", "sc_setspeed walk reset " }
    end
  else
    return { "sc_setspeed all", "sc_setspeed duck", "sc_setspeed run", "sc_setspeed slow", "sc_setspeed walk" }
  end
end

--
--[[
############################
#     COMMAND REGISTER     #
############################
]]
--
concommand.Add("sc_setspeed", function(p, _, args, _) SetSpeed(p, args, false) end, SetSpeedCompletion, "Set player's speed.", { FCVAR_NONE })
concommand.Add("sc_setspeed_s", function(p, _, args, _) SetSpeed(p, args, true) end, SetSpeedCompletion, "Set player's speed. (Silent)", { FCVAR_NONE })
