SC_SMALL_MODELS = {}
SC_SMALL_MODELS_DIRS = {}
---Read config files and save them as a table.
---The table
---@param overwrite boolean Ovewrite current table anyway?
function ReadConfigFiles(overwrite)
  -- We have to create directory first. This will not emit error, so this is fine.
  file.CreateDir("sc_tools")
  local comment = {"You can add comment using '#'.", "'#' can be either start of the line or middle of the line. Any character after '#' will be ignored."}
  if overwrite or table.IsEmpty(SC_SMALL_MODELS) then
    local small_models_default = {}
    small_models_default["models/combine_apc_destroyed_gib02.mdl"] = true
    small_models_default["models/combine_apc_destroyed_gib03.mdl"] = true
    small_models_default["models/combine_apc_destroyed_gib04.mdl"] = true
    small_models_default["models/combine_apc_destroyed_gib05.mdl"] = true
    small_models_default["models/combine_apc_destroyed_gib06.mdl"] = true
    small_models_default["models/props/cs_office/trash_can_p1.mdl"] = true
    small_models_default["models/props/cs_office/trash_can_p2.mdl"] = true
    small_models_default["models/props/cs_office/trash_can_p3.mdl"] = true
    small_models_default["models/props/cs_office/trash_can_p4.mdl"] = true
    small_models_default["models/props/cs_office/trash_can_p5.mdl"] = true
    small_models_default["models/props/cs_office/trash_can_p7.mdl"] = true
    small_models_default["models/props/cs_office/trash_can_p8.mdl"] = true
    small_models_default["models/props/cs_office/water_bottle.mdl"] = true
    small_models_default["models/props_c17/chair02a.mdl"] = true
    small_models_default["models/props_c17/chair02a.mdl"] = true
    small_models_default["models/props_c17/tools_pliers01a.mdl"] = true
    small_models_default["models/props_c17/tools_wrench01a.mdl"] = true
    small_models_default["models/props_junk/garbage_metalcan001a.mdl"] = true
    small_models_default["models/props_junk/garbage_metalcan002a.mdl"] = true
    small_models_default["models/props_junk/garbage_milkcarton001a.mdl"] = true
    small_models_default["models/props_junk/garbage_milkcarton002a.mdl"] = true
    small_models_default["models/props_junk/garbage_plasticbottle001a.mdl"] = true
    small_models_default["models/props_junk/garbage_plasticbottle003a.mdl"] = true
    small_models_default["models/props_junk/metal_paintcan001a.mdl"] = true
    small_models_default["models/props_junk/metal_paintcan001b.mdl"] = true
    small_models_default["models/props_junk/popcan01a.mdl"] = true
    small_models_default["models/props_junk/shoe001a.mdl"] = true
    small_models_default["models/props_lab/binderblue.mdl"] = true
    small_models_default["models/props_lab/binderbluelabel.mdl"] = true
    small_models_default["models/props_lab/bindergraylabel01a.mdl"] = true
    small_models_default["models/props_lab/bindergraylabel01b.mdl"] = true
    small_models_default["models/props_lab/bindergreen.mdl"] = true
    small_models_default["models/props_lab/bindergreenlabel.mdl"] = true
    small_models_default["models/props_lab/binderredlabel.mdl"] = true
    small_models_default["models/props_lab/box01a.mdl"] = true
    small_models_default["models/props_lab/jar01a.mdl"] = true
    small_models_default["models/props_wasteland/cafeteria_table001a.mdl"] = true
    small_models_default["models/props_wasteland/controlroom_chair001a.mdl"] = true
    SC_SMALL_MODELS = ReadConfigFile("sc_tools/small.txt", small_models_default, comment)
  end

  if overwrite or table.IsEmpty(SC_SMALL_MODELS_DIRS) then
    local small_models_dirs_default = {}
    small_models_dirs_default["models/gibs/"] = true
    small_models_dirs_default["models/humans/"] = true
    SC_SMALL_MODELS_DIRS = ReadConfigFile("sc_tools/smallDir.txt", small_models_dirs_default, comment)
  end
end

---Read the file and return a table created from its content.<br>
---Each line is key of the table, and their value is always `true`.<br>
---This will ignore any line/character starts with `#`.
---@param fileName string Path to the file. Must be under 'garrysmod/data' directory.
---@param default table Default table if file is empty or not accessible.
---@param topComment table Table consist of comment line that will be placed on top of the newly created file.
---@return table result Table created from parsed content of the file.
function ReadConfigFile(fileName, default, topComment)
  -- Check file exists
  if file.Exists(fileName, "DATA") then
    -- File exists
    local c = file.Read(fileName, "DATA")
    if c == nil then
      print("[SC Tools] Content of '" .. fileName .. "' is empty. Is this intended?")
      return {}
    else
      local tbl = string.Split(c, "\n")
      local t = {}
      for _, v in ipairs(tbl) do
        local row = string.Split(v, "#")
        local item = row[1]
        if #item > 0 then t[string.Trim(item)] = true end
      end
      return t
    end
  else
    -- File not exists
    local f = file.Open(fileName, "w", "DATA")
    if topComment ~= nil and table.Count(topComment) > 0 then
      for k, v in ipairs(topComment) do
        ---@diagnostic disable-next-line: undefined-field
        f:Write("# " .. topComment[k] .. "\n")
      end
    end

    if default ~= nil and table.Count(default) > 0 then
      for k, v in SortedPairs(default) do
        ---@diagnostic disable-next-line: undefined-field
        if v then f:Write(tostring(k) .. "\n") end
      end

      ---@diagnostic disable-next-line: undefined-field
      f:Flush()
      ---@diagnostic disable-next-line: undefined-field
      f:Close()
      return default
    end

    -- Close file anyway
    ---@diagnostic disable-next-line: undefined-field
    f:Flush()
    ---@diagnostic disable-next-line: undefined-field
    f:Close()
    return {}
  end
end

hook.Add("InitPostEntity", "SCReload_Init", function() ReadConfigFiles(true) end)
