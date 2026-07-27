local function PrintUsage(command, argument)
  print(command .. " <" .. argument .. ">")
end

local function TrimName(value)
  return string.Trim(value or "")
end

local function WithoutExtension(name, extension)
  return string.EndsWith(name, extension) and string.sub(name, 1, #name - #extension) or name
end

local function HasUnsafePath(name)
  return string.find(name, "%.%.", 1, true) ~= nil or string.StartsWith(name, "/") or string.StartsWith(name, "\\")
end

local function WriteModFile(path, content)
  local handle = file.Open(path, "wb", "MOD")
  if not handle then return false end

  ---@diagnostic disable-next-line: undefined-field
  handle:Write(content)
  ---@diagnostic disable-next-line: undefined-field
  handle:Close()
  return true
end

local function DecodeDupe(_, _, _, argStr)
  local name = WithoutExtension(TrimName(argStr), ".dupe")
  if name == "" then
    PrintUsage("decode_dupe", "dupe name")
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

local function EncodeDupe(_, _, _, argStr)
  local name = WithoutExtension(TrimName(argStr), ".json")
  if name == "" then
    PrintUsage("encode_dupe", "json name")
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

concommand.Add("decode_dupe", DecodeDupe, nil, "Decode dupes/<name>.dupe to data/<name>.json.", { FCVAR_NONE })
concommand.Add("encode_dupe", EncodeDupe, nil, "Encode data/<name>.json to data/<name>.dat and dupes/<name>.dupe when writable.", { FCVAR_NONE })
