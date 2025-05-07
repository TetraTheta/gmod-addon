require("sctools")
--
concommand.Add("sc_reload", function(_, _, _, _)
  sctools.ReloadConfig()
end, nil, "Reload SC Tools configurations.", { FCVAR_NONE })
