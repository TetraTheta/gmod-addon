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
  }
}

local function Cheat(_, _, _, _)
  if not SERVER then return end

  local data = MAP_DATA[curmap]
  if data and data.func then
    data.func()
  else
    print("[Cheat] There no cheat registered for this map: " .. curmap)
  end
end

---@return table
local function CheatAutoComplete(cmd, _, args)
  local firstArg = args[1] and args[1]:lower() or ""
  local prefix = cmd .. " "
  if firstArg == "air-exchange" then
    return {
      prefix .. "air-exchange airex03b",
      prefix .. "air-exchange airex03c"
    }
  elseif firstArg == "new-times" then
    return {
      prefix .. "new-times newtimes_c4m4"
    }
  end
  return {
    prefix .. "air-exchange",
    prefix .. "new-times",
  }
end

concommand.Add("cheat", Cheat, CheatAutoComplete, "Cheat for various maps")
