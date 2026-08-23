local efbc = ents.FindByClass
local efbn = ents.FindByName
local curmap = game.GetMap()

---@param ent_tbl table
local function RemoveAll(ent_tbl)
  if not istable(ent_tbl) then return end
  for i = 1, #ent_tbl do
    local e = ent_tbl[i]
    if IsValid(e) then e:Remove() end
  end
end

local MAP_DATA = {
  ["airex03b"] = {
    name = "air-exchange",
    func = function()
      RemoveAll(efbn("tripmine_room_explosion_relay"))
      print("[Air Exchange] Removed 'tripmine_room_explosion_relay'")
      print("[Air Exchange] But you should enable cheat again in next map. Actual tripmine explosion is in next map.")
    end
  },
  ["airex03c"] = {
    name = "air-exchange",
    func = function()
      RemoveAll(efbn("tripmine_room_explosion_relay"))
      print("[Air Exchange] Removed 'tripmine_room_explosion_relay'")
    end
  },
  ["newtimes_c4m4"] = {
    name = "new-times",
    func = function()
      RemoveAll(efbn("chain_reaction"))
      print("[New Times] Removed 'chain_reaction'")
    end
  },
  ["ws_powerfailure_1"] = {
    name = "power-failure",
    func = function()
      RemoveAll(efbn("manhack_chaser"))
      RemoveAll(efbn("manhack_maker"))
      RemoveAll(efbn("temphack_1"))
      RemoveAll(efbn("temphack_2"))
      RemoveAll(efbn("temphack_3"))
      RemoveAll(efbc("npc_manhack"))
      print("[Power Failure] Removed manhack hell")
    end
  },
  ["ws_powerfailure_2"] = {
    name = "power-failure",
    func = function()
      RemoveAll(efbn("failure_relay"))
      RemoveAll(efbn("failure_relay0"))
      RemoveAll(efbn("failure_secret"))
      RemoveAll(efbn("rubble_mover"))
      print("[Power Failure] Removed UXO end")
    end
  },
}

---@param args table
---@return table?
local function GetCheatData(args)
  local arg_1 = args[1] and args[1]:lower()
  local arg_2 = args[2] and args[2]:lower()
  local data

  if arg_2 then
    data = MAP_DATA[arg_2]
    if data and data.name == arg_1 and curmap == arg_2 then return data end
    return nil
  end

  if arg_1 then
    data = MAP_DATA[arg_1]
    if data and curmap == arg_1 then return data end

    data = MAP_DATA[curmap]
    if data and data.name == arg_1 then return data end
    return nil
  end

  return MAP_DATA[curmap]
end

---@param str string
---@return string
local function Trim(str)
  return str:match("^%s*(.-)%s*$")
end

--[[
#################
#    COMMAND    #
#################
]]

---@param ply any
---@param args table
local function Cheat(ply, _, args, _)
  if not SERVER then return end

  local data = GetCheatData(args)
  if data then
    data.func()
  else
    print("[Cheat] There no cheat registered for this map: " .. curmap)
  end
end

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param cmd string
---@param arg_str string
---@param args table
---@return table
local function CheatAutoComplete(cmd, arg_str, args)
  local query = Trim(arg_str):lower()
  local prefix = cmd .. " "

  local modes = {}
  local mode_map = {}
  local maps = {}

  for map, data in pairs(MAP_DATA) do
    if not mode_map[data.name] then
      mode_map[data.name] = {}
      table.insert(modes, data.name)
    end
    table.insert(mode_map[data.name], map)
    table.insert(maps, map)
  end

  table.sort(modes)
  table.sort(maps)

  local candidates = { cmd }

  for _, mode in ipairs(modes) do
    table.insert(candidates, prefix .. mode)
  end

  for _, map in ipairs(maps) do
    table.insert(candidates, prefix .. map)
  end

  for _, mode in ipairs(modes) do
    table.sort(mode_map[mode])
    for _, map in ipairs(mode_map[mode]) do
      table.insert(candidates, prefix .. mode .. " " .. map)
    end
  end

  local suggestions = {}
  for _, candidate in ipairs(candidates) do
    if query == "" or candidate:lower():sub(1, #cmd + #query + 1) == cmd .. " " .. query then
      table.insert(suggestions, candidate)
    end
  end

  return suggestions
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("cheat", Cheat, CheatAutoComplete, "Cheat for various maps")
