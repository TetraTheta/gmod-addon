local efbc = ents.FindByClass
local efbn = ents.FindByName
local curmap = game.GetMap()

local function RemoveAll(entTable)
  if not istable(entTable) then return end
  for i = 1, #entTable do
    local e = entTable[i]
    if IsValid(e) then e:Remove() end
  end
end

local MAP_DATA = {
  ["airex03b"] = {
    name = "air-exchange",
    func = function()
      RemoveAll(efbn("tripmine_room_explosion_relay"))
      print("[Air Exchange] Removed 'tripmine_room_explosion_relay'")
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

local function Cheat(ply, _, args, _)
  if not SERVER then return end

  local mapName = args[2] and args[2]:lower() or args[1] and args[1]:lower() or curmap
  local data = MAP_DATA[mapName]
  if data and curmap == mapName then
    data.func()
  else
    print("[Cheat] There no cheat registered for this map: " .. curmap)
  end
end

---@return table
local function CheatAutoComplete(cmd, _, args)
  local firstArg = args[1] and args[1]:lower() or ""
  local prefix = cmd .. " "

  local modes = {}
  local modeMap = {}
  local maps = {}

  for map, data in pairs(MAP_DATA) do
    if not modeMap[data.name] then
      modeMap[data.name] = {}
      table.insert(modes, data.name)
    end
    table.insert(modeMap[data.name], map)
    table.insert(maps, map)
  end

  table.sort(modes)
  table.sort(maps)

  if modeMap[firstArg] then
    local suggestions = {}
    table.sort(modeMap[firstArg])
    for _, map in ipairs(modeMap[firstArg]) do
      table.insert(suggestions, prefix .. firstArg .. " " .. map)
    end
    return suggestions
  end

  local suggestions = {}

  if firstArg == "" then
    for _, mode in ipairs(modes) do
      table.insert(suggestions, prefix .. mode)
    end
    return suggestions
  end

  for _, mode in ipairs(modes) do
    if string.StartsWith(mode, firstArg) then
      table.insert(suggestions, prefix .. mode)
    end
  end

  for _, map in ipairs(maps) do
    if string.StartsWith(map, firstArg) then
      table.insert(suggestions, prefix .. map)
    end
  end

  return suggestions
end

concommand.Add("cheat", Cheat, CheatAutoComplete, "Cheat for various maps")
