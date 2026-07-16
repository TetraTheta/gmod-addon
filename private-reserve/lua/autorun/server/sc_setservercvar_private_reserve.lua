SC_ServerConVarBridge = SC_ServerConVarBridge or {
  defs = {}
}

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
    if string.len(raw) >= 2 and raw:sub(1, 1) == '"' and raw:sub(-1) == '"' then
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

  ---@param defs table
  function bridge.Register(defs)
    for convar, def in pairs(defs) do
      bridge.defs[convar] = def
    end
  end

  concommand.Add("sc_setservercvar", function(ply, _, args, argStr)
    local convar = args[1]
    if convar == nil or convar == "" then return end

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

    cv:SetString(NormalizeValue(def, GetRawValue(args, argStr)))
  end, nil, "Change a whitelisted replicated server ConVar.", { FCVAR_NONE })
end

bridge.Register({
  pr_autojump = { type = "bool", default = "0" },
  pr_autojump_delay = { type = "float", default = "0.75", min = 0, max = 5, decimals = 2 },
  pr_disable_headcrab = { type = "bool", default = "0" },
  pr_enable_additional_pickup = { type = "bool", default = "0" },
  pr_enable_flying_drops = { type = "bool", default = "0" },
  pr_enable_kill_reload = { type = "bool", default = "0" },
  pr_enable_loadout = { type = "bool", default = "0" },
  pr_enable_shoot_open_crate = { type = "bool", default = "0" },
  pr_enable_special_damage = { type = "bool", default = "0" },
  pr_shoot_button_use_enable = { type = "bool", default = "0" },
  pr_shoot_button_use_excluded_weapons = { type = "string", default = "" },
  pr_shoot_button_use_unlock = { type = "bool", default = "0" },
})
