-- https://developer.valvesoftware.com/wiki/Env_hudhint
-- https://wiki.facepunch.com/gmod/input.LookupBinding
net.Receive("SCReplacerHudhintMessage", function(_, _)
  local phrase = net.ReadString()
  if phrase:StartsWith("#") then
    phrase = language.GetPhrase(phrase)
  end

  local function replaceKeybinds(keybind)
    local vkey = input.LookupBinding(keybind, true)
    if vkey then
      return vkey:upper()
    else
      return keybind
    end
  end

  local vmsg = phrase:gsub("%%(.-)%%", replaceKeybinds)
  surface.PlaySound("garrysmod/ui_click.wav")
  notification.AddLegacy(vmsg, NOTIFY_GENERIC, 10)
end)
