---@param keybind string
---@return string
local function ReplaceKeybind(keybind)
  local vkey = input.LookupBinding(keybind, true)
  if vkey then
    return vkey:upper()
  else
    return keybind
  end
end

--[[
###############
#     NET     #
###############
]]

net.Receive("SCTOOLS_env_hudhint_message", function(_, _)
  local hudhint_enable = GetConVar("env_hudhint_enable")
  if hudhint_enable ~= nil and not hudhint_enable:GetBool() then return end

  local phrase = net.ReadString()
  phrase = language.GetPhrase(phrase)
  local vmsg = phrase:gsub("%%(.-)%%", ReplaceKeybind)
  surface.PlaySound("garrysmod/ui_click.wav")
  notification.AddLegacy(vmsg, NOTIFY_GENERIC, 10)
end)
