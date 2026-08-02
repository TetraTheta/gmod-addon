require("sctools")
local GetPlayerByName = sctools.command.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer

--[[
#################
#    COMMAND    #
#################
]]

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

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param cmd string
---@param args string
---@return table
local function SetSpeedCompletion(cmd, args)
  local raw = args or ""
  if raw:lower():StartsWith(cmd:lower()) then raw = raw:sub(#cmd + 1) end
  raw = raw:gsub("^%s+", "")
  local parts = {}
  for part in raw:gmatch("%S+") do
    parts[#parts + 1] = part
  end
  if #parts >= 2 and (parts[2] == "fast" or parts[2] == "reset") then
    return SuggestPlayer(cmd .. " " .. parts[1] .. " " .. parts[2], args)
  end
  local options = {}
  local completing_mode = #parts == 1 and raw:EndsWith(" ") or #parts == 2
  local values = completing_mode and { "fast", "reset" } or { "all", "duck", "run", "slow", "walk" }
  local prefix = #parts == 2 and parts[2] or completing_mode and "" or parts[1] or ""
  local base = completing_mode and cmd .. " " .. parts[1] or cmd
  for _, value in ipairs(values) do
    if value:StartsWith(prefix) then
      options[#options + 1] = completing_mode and base .. " " .. value .. " " or base .. " " .. value
    end
  end
  return options
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("sc_setspeed", function(p, _, args, _) SetSpeed(p, args, false) end, SetSpeedCompletion, "Set player's speed.", { FCVAR_NONE })
concommand.Add("sc_setspeed_s", function(p, _, args, _) SetSpeed(p, args, true) end, SetSpeedCompletion, "Set player's speed. (Silent)", { FCVAR_NONE })
