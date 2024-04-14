-- https://developer.valvesoftware.com/wiki/Env_hudhint
-- https://wiki.facepunch.com/gmod/input.LookupBinding
net.Receive("SCReplacerHudhintMessage", function(_, _)
  local v = net.ReadString()
  print(v)
  if v:StartsWith("#") then
    local phrase = language.GetPhrase(v)
    local vbind, vmsg = phrase:match("%%(.-)%%(.*)")
    local vkey = input.LookupBinding(vbind, true)
    surface.PlaySound("garrysmod/ui_click.wav")
    notification.AddLegacy(vkey:upper() .. " : " .. vmsg:upper(), NOTIFY_GENERIC, 10)
  elseif v:StartsWith("%") then
    local vbind, vmsg = v:match("%%(.-)%%(.*)")
    local vkey = input.LookupBinding(vbind, true)
    surface.PlaySound("garrysmod/ui_click.wav")
    notification.AddLegacy(vkey:upper() .. " : " .. vmsg, NOTIFY_GENERIC, 10)
  else
    surface.PlaySound("garrysmod/ui_click.wav")
    notification.AddLegacy(v, NOTIFY_GENERIC, 10)
  end
end)
