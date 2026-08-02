---@param name string
---@param extension string
---@return string
local function WithoutExtension(name, extension)
  return name:EndsWith(extension) and name:sub(1, #name - #extension) or name
end

---@param cmd string
---@param args string
---@param files string[]
---@param extension string
---@return string[]
local function CompleteFiles(cmd, args, files, extension)
  local prefix = args or ""
  if prefix:lower():sub(1, #cmd) == cmd:lower() then prefix = prefix:sub(#cmd + 1) end
  prefix = WithoutExtension(prefix:Trim(), extension):lower()
  local out = {}
  table.sort(files)
  for _, file_name in ipairs(files) do
    local name = WithoutExtension(file_name, extension)
    if name:lower():sub(1, #prefix) == prefix then out[#out + 1] = cmd .. " " .. name end
  end
  return out
end

---@param name string
---@return boolean
local function HasUnsafePath(name)
  return name:find("%.%.", 1, true) ~= nil or name:StartsWith("/") or name:StartsWith("\\")
end

---@param path string
---@param content string
---@return boolean
local function WriteModFile(path, content)
  local handle = file.Open(path, "wb", "MOD")
  if not handle then return false end

  ---@diagnostic disable-next-line: undefined-field
  handle:Write(content)
  ---@diagnostic disable-next-line: undefined-field
  handle:Close()
  return true
end

--[[
#################
#    COMMAND    #
#################
]]

---@param argStr string
local function DecodeDupe(_, _, _, argStr)
  local name = WithoutExtension(string.Trim(argStr or ""), ".dupe")
  if name == "" then
    print("decode_dupe <dupe name>")
    return
  end
  if HasUnsafePath(name) then
    print("decode_dupe: unsafe path")
    return
  end
  local dupePath = "dupes/" .. name .. ".dupe"
  local dupe = engine.OpenDupe(dupePath)
  if not dupe or not dupe.data then
    print("decode_dupe: failed to open " .. dupePath)
    return
  end
  local json = util.Decompress(dupe.data)
  if not json then
    print("decode_dupe: failed to decompress " .. dupePath)
    return
  end
  local jsonPath = name .. ".json"
  file.Write(jsonPath, json)
  print("decode_dupe: wrote data/" .. jsonPath)
end

---@param argStr string
local function EncodeDupe(_, _, _, argStr)
  local name = WithoutExtension(string.Trim(argStr or ""), ".json")
  if name == "" then
    print("encode_dupe <json name>")
    return
  end
  if HasUnsafePath(name) then
    print("encode_dupe: unsafe path")
    return
  end
  local jsonPath = name .. ".json"
  local json = file.Read(jsonPath, "DATA")
  if not json then
    print("encode_dupe: failed to read data/" .. jsonPath)
    return
  end
  if not util.JSONToTable(json) then
    print("encode_dupe: invalid JSON in data/" .. jsonPath)
    return
  end
  local encoded = "DUP3" .. util.Compress(json)
  local datPath = name .. ".dat"
  file.Write(datPath, encoded)
  local dupePath = "dupes/" .. name .. ".dupe"
  if WriteModFile(dupePath, encoded) then
    print("encode_dupe: wrote " .. dupePath)
  else
    print("encode_dupe: wrote data/" .. datPath .. " (dupes/ is not writable)")
  end
end

--[[
##############################
#    COMMAND AUTOCOMPLETE    #
##############################
]]

---@param cmd string
---@param args string
---@return string[]
local function DecodeDupeComplete(cmd, args)
  local files = file.Find("dupes/*.dupe", "MOD")
  return CompleteFiles(cmd, args, files, ".dupe")
end

---@param cmd string
---@param args string
---@return string[]
local function EncodeDupeComplete(cmd, args)
  local files = file.Find("*.json", "DATA")
  return CompleteFiles(cmd, args, files, ".json")
end

--[[
##########################
#    COMMAND REGISTER    #
##########################
]]

concommand.Add("decode_dupe", DecodeDupe, DecodeDupeComplete, "Decode dupes/<name>.dupe to data/<name>.json.", { FCVAR_NONE })
concommand.Add("encode_dupe", EncodeDupe, EncodeDupeComplete, "Encode data/<name>.json to data/<name>.dat and dupes/<name>.dupe when writable.", { FCVAR_NONE })
