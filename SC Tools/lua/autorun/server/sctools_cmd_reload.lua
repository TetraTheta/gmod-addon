require("sctools")
local function ReloadConfig(_, _, _, _)
  sctools.ReloadConfig()
end

concommand.Add("sc_reload", ReloadConfig, nil, "Reload SC Tools configurations.", FCVAR_NONE)
