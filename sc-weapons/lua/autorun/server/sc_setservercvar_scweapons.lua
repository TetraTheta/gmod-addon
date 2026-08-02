SC_ServerConVarBridge = SC_ServerConVarBridge or { defs = {} }

local bridge = SC_ServerConVarBridge

if bridge.Register == nil then
  ---@param msg string
  ---@param ply Player|Entity|nil
  local function PrintResult(msg, ply)
    if ply ~= nil and IsValid(ply) and ply:IsPlayer() then
      ply:PrintMessage(HUD_PRINTCONSOLE, msg)
    else
      MsgN(msg)
    end
  end

  ---@param raw string
  ---@return string
  local function StripQuotes(raw)
    if raw:len() >= 2 and raw:sub(1, 1) == '"' and raw:sub(-1) == '"' then
      return raw:sub(2, -2)
    end
    return raw
  end

  ---@param args table
  ---@param argStr string
  ---@return string
  local function GetRawValue(args, argStr)
    local raw = string.match(argStr or "", "^%S+%s+(.+)$")
    if raw == nil then raw = args[2] or "" end
    return StripQuotes(raw)
  end

  ---@param def table
  ---@param raw string
  ---@return string
  local function NormalizeValue(def, raw)
    if def.type == "string" then return raw end
    local num = tonumber(raw)
    if num == nil then num = tonumber(def.default) or 0 end
    if def.type == "bool" then
      return num ~= 0 and "1" or "0"
    end
    if def.min ~= nil and num < def.min then num = def.min end
    if def.max ~= nil and num > def.max then num = def.max end
    if def.type == "int" then
      num = math.floor(num)
    elseif def.decimals ~= nil then
      num = math.Round(num, def.decimals)
    end
    return tostring(num)
  end

  ---@param value string
  ---@param prefix string
  ---@return boolean
  local function StartsWith(value, prefix)
    return value:lower():sub(1, #prefix) == prefix:lower()
  end

  --[[
  ##############################
  #    COMMAND AUTOCOMPLETE    #
  ##############################
  ]]

  ---@param cmd string
  ---@param convar string
  ---@param raw string
  ---@return string[]
  local function CompleteValue(cmd, convar, raw)
    local def = bridge.defs[convar]
    if def == nil then return {} end

    local values = {}
    if def.type == "bool" then
      values = { "0", "1" }
    elseif def.type == "int" and def.min ~= nil and def.max ~= nil and def.max - def.min <= 16 then
      for value = def.min, def.max do
        values[#values + 1] = tostring(value)
      end
    end
    local out = {}
    for _, value in ipairs(values) do
      if StartsWith(value, raw) then out[#out + 1] = cmd .. " " .. convar .. " " .. value end
    end
    return out
  end

  ---@param cmd string
  ---@param args string
  ---@return string[]
  local function CompleteServerConVar(cmd, args)
    args = args or ""
    if args:lower():sub(1, #cmd) == cmd:lower() then args = args:sub(#cmd + 1) end
    args = args:gsub("^%s+", "")
    local convar, raw = args:match("^(%S+)%s+(%S*)$")
    if convar ~= nil then return CompleteValue(cmd, convar, raw) end
    local prefix = args:match("^(%S*)$") or ""
    local out = {}
    for name in SortedPairs(bridge.defs) do
      if StartsWith(name, prefix) then out[#out + 1] = cmd .. " " .. name end
    end
    return out
  end

  ---@param defs table
  function bridge.Register(defs)
    for convar, def in pairs(defs) do
      bridge.defs[convar] = def
    end
  end

  --[[
  #################
  #    COMMAND    #
  #################
  ]]

  ---@param ply Player|Entity|nil
  ---@param args table
  ---@param arg_str string
  local function SetServerConVar(ply, args, arg_str)
    local convar = args[1]
    if convar == nil or convar == "" then return end

    ---@cast ply Player
    if IsValid(ply) and ply:IsPlayer() and not ply:IsUserGroup("superadmin") then
      PrintResult("[SC Menu] Superadmin only.", ply)
      return
    end

    local def = bridge.defs[convar]
    if def == nil then
      PrintResult("[SC Menu] Not whitelisted: " .. convar, ply)
      return
    end

    local cv = GetConVar(convar)
    if cv == nil then
      PrintResult("[SC Menu] Missing ConVar: " .. convar, ply)
      return
    end

    cv:SetString(NormalizeValue(def, GetRawValue(args, arg_str)))
  end

  --[[
  ##########################
  #    COMMAND REGISTER    #
  ##########################
  ]]

  concommand.Add("sc_setservercvar", function(ply, _, args, arg_str) SetServerConVar(ply, args, arg_str) end, CompleteServerConVar, "Change a whitelisted replicated server ConVar.", { FCVAR_NONE })
end

bridge.Register({
  scaw_mp5_default = { type = "int", default = "1", min = 1, max = 5 },
  scaw_mp5sd_default = { type = "int", default = "1", min = 1, max = 5 },
  scaw_owner_immune_explosion = { type = "bool", default = "0" },
  scaw_pistol_default = { type = "int", default = "1", min = 1, max = 5 },
})
