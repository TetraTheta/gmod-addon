AddCSLuaFile("autorun/client/ent_game_text_cl.lua")
local nw = "SCTOOLS_game_text_message"
local force_glua_cvar = "game_text_force_glua"
--
local SF_ENVTEXT_ALLPLAYERS = 1
local states = setmetatable({}, { __mode = "k" })
--
---@param value string|nil
---@param fallback number
---@return number
local function NumberFromString(value, fallback)
  if not isstring(value) then return fallback end
  return tonumber(value) or fallback
end

---@param value string
---@return string
local function NormalizeText(value)
  local s = value:gsub("\r\n", "/n")
  s = s:gsub("\n", "/n")
  s = s:gsub("\r", "/n")
  s = s:gsub("\\n", "/n")
  return s
end

---@param value string
---@return string
local function NativeText(value)
  local s = NormalizeText(value):gsub("/n", "\n")
  return s
end

---@param ent Entity
---@return table
local function GameTextState(ent)
  local state = states[ent]
  if state ~= nil then return state end
  state = {
    autobreak = false,
    channel = 1,
    color1 = Color(200, 200, 200, 255),
    color2 = Color(240, 110, 0, 255),
    effect = 0,
    fadein = 1.5,
    fadeout = 0.5,
    font = "",
    fxtime = 0.25,
    holdtime = 1.2,
    master = "",
    message = "",
    spawnflags = ent:GetSpawnFlags(),
    x = -1,
    y = -1
  }
  states[ent] = state
  return state
end

---@param ent Entity
---@param key string
---@param value string
---@return boolean
local function ApplyKeyValue(ent, key, value)
  local state = GameTextState(ent)
  local lkey = key:lower()
  if lkey == "autobreak" then
    state.autobreak = tobool(value)
  elseif lkey == "channel" then
    state.channel = math.floor(NumberFromString(value, 1))
  elseif lkey == "color" then
    state.color1 = string.ToColor(value)
  elseif lkey == "color2" then
    state.color2 = string.ToColor(value)
  elseif lkey == "effect" then
    state.effect = math.floor(NumberFromString(value, 0))
  elseif lkey == "fadein" then
    state.fadein = math.max(NumberFromString(value, 1.5), 0)
  elseif lkey == "fadeout" then
    state.fadeout = math.max(NumberFromString(value, 0.5), 0)
  elseif lkey == "font" then
    state.font = value
  elseif lkey == "fxtime" then
    state.fxtime = math.max(NumberFromString(value, 0.25), 0)
  elseif lkey == "holdtime" then
    state.holdtime = math.max(NumberFromString(value, 1.2), 0)
  elseif lkey == "master" then
    state.master = value
  elseif lkey == "message" then
    state.message = NormalizeText(value)
  elseif lkey == "spawnflags" then
    state.spawnflags = math.floor(NumberFromString(value, 0))
  elseif lkey == "x" then
    state.x = NumberFromString(value, -1)
  elseif lkey == "y" then
    state.y = NumberFromString(value, -1)
  else
    state[lkey] = value
    return false
  end
  return true
end

---@param ent Entity
---@param value any
---@return boolean
local function ApplyAddOutput(ent, value)
  if not isstring(value) then return false end
  local key, data = value:match("^%s*(%S+)%s+(.+)$")
  if key == nil or data == nil then return false end
  ApplyKeyValue(ent, key, data)
  if key:lower() ~= "message" then return false end
  ent:SetKeyValue("message", NativeText(data))
  return true
end

---@param ent Entity
---@return table
local function SyncNativeKeyValues(ent)
  local state = GameTextState(ent)
  for key, value in pairs(ent:GetKeyValues()) do
    if isstring(key) and (isstring(value) or isnumber(value)) then ApplyKeyValue(ent, key, tostring(value)) end
  end
  return state
end

---@param ent Entity
---@param state table
---@return nil
local function ApplyNativeText(ent, state)
  ent:SetKeyValue("message", NativeText(state.message or ""))
end

---@param state table
---@return boolean
local function NeedsLuaDisplay(state)
  return state.autobreak == true or state.font ~= nil and state.font ~= ""
end

---@param activator Entity
---@return boolean
local function ForceLuaDisplay(activator)
  local ply = IsValid(activator) and activator:IsPlayer() and activator or player.GetAll()[1]
  return IsValid(ply) and ply:GetInfoNum(force_glua_cvar, 0) ~= 0
end

---@param state table
---@param ply Player|nil
---@return nil
local function SendText(state, ply)
  if state.message == nil or state.message == "" then return end
  net.Start(nw)
  net.WriteBool(state.autobreak or false)
  net.WriteInt(state.channel or 1, 16)
  net.WriteColor(state.color1 or Color(200, 200, 200, 255))
  net.WriteColor(state.color2 or Color(240, 110, 0, 255))
  net.WriteUInt(math.Clamp(state.effect or 0, 0, 7), 3)
  net.WriteFloat(state.fadein or 1.5)
  net.WriteFloat(state.fadeout or 0.5)
  net.WriteString(state.font or "")
  net.WriteFloat(state.fxtime or 0.25)
  net.WriteFloat(state.holdtime or 1.2)
  net.WriteString(state.message or "")
  net.WriteFloat(state.x or -1)
  net.WriteFloat(state.y or -1)
  if ply == nil then
    net.Broadcast()
  else
    net.Send(ply)
  end
end

---@param ent Entity
---@param activator Entity
---@return boolean
local function DisplayText(ent, activator)
  local state = SyncNativeKeyValues(ent)
  ApplyNativeText(ent, state)
  if not ForceLuaDisplay(activator) and not NeedsLuaDisplay(state) then return false end
  if bit.band(state.spawnflags or 0, SF_ENVTEXT_ALLPLAYERS) ~= 0 then
    SendText(state, nil)
  elseif game.SinglePlayer() then
    SendText(state, player.GetAll()[1])
  elseif IsValid(activator) and activator:IsPlayer() then
    ---@cast activator Player
    SendText(state, activator)
  end
  return true
end

util.AddNetworkString(nw)

--[[
##############
#    HOOK    #
##############
]]

hook.Add("AcceptInput", "SCTOOLS_game_text_AcceptInput", function(ent, input, activator, caller, value)
  if not IsValid(ent) or ent:GetClass() ~= "game_text" then return nil end
  local linput = input:lower()
  if linput == "addoutput" then
    return ApplyAddOutput(ent, value) or nil
  elseif linput == "display" then
    return DisplayText(ent, activator) or nil
  elseif linput == "setfont" then
    GameTextState(ent).font = tostring(value or "")
  elseif linput == "setposx" then
    local state = GameTextState(ent)
    state.x = NumberFromString(tostring(value or ""), state.x or -1)
    ent:SetKeyValue("x", tostring(state.x))
  elseif linput == "setposy" then
    local state = GameTextState(ent)
    state.y = NumberFromString(tostring(value or ""), state.y or -1)
    ent:SetKeyValue("y", tostring(state.y))
  elseif linput == "settext" then
    local state = GameTextState(ent)
    state.message = NormalizeText(tostring(value or ""))
    ApplyNativeText(ent, state)
  elseif linput == "settextcolor" then
    local data = tostring(value or "")
    GameTextState(ent).color1 = string.ToColor(data)
    ent:SetKeyValue("color", data)
  elseif linput == "settextcolor2" then
    local data = tostring(value or "")
    GameTextState(ent).color2 = string.ToColor(data)
    ent:SetKeyValue("color2", data)
  else
    return nil
  end
  return true
end)

hook.Add("EntityKeyValue", "SCTOOLS_game_text_EntityKeyValue", function(ent, key, value)
  if not IsValid(ent) or ent:GetClass() ~= "game_text" then return nil end
  ApplyKeyValue(ent, key, value)
  if key:lower() == "message" then return NativeText(value) end
  return nil
end)
