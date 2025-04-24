net.Receive("SCTOOLS_env_hudhint_message", function(_, _)
  local phrase = net.ReadString()
  phrase = language.GetPhrase(phrase)
  --
  local function _ReplaceKeybind(keybind)
    local vkey = input.LookupBinding(keybind, true)
    if vkey then
      return vkey:upper()
    else
      return keybind
    end
  end

  local vmsg = phrase:gsub("%%(.-)%%", _ReplaceKeybind)
  surface.PlaySound("garrysmod/ui_click.wav")
  notification.AddLegacy(vmsg, NOTIFY_GENERIC, 10)
end)
