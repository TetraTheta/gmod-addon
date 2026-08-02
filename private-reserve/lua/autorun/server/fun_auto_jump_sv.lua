local cv_aj = GetConVar("pr_autojump")
local cv_ajd = GetConVar("pr_autojump_delay")
local def_act_delay = 0.75
local interval = math.max(0.01, engine.TickInterval())
local jump_held_since = {}
local spam_next_flip_time = {}
local spam_is_key_down = {}

local AUTOJUMP_STATE_KEY = "pr_autojump_server_spam"
local AUTOJUMP_REASON_KEY = "pr_autojump_server_spam_reason"
local AUTOJUMP_REASON_VALUE = "server_allowed"

local function GetAutojumpDelay()
  if not cv_ajd then cv_ajd = GetConVar("pr_autojump_delay") end
  if not cv_ajd then return def_act_delay end
  return cv_ajd:GetFloat()
end

local function ClearPlayerState(steam_id)
  jump_held_since[steam_id], spam_next_flip_time[steam_id], spam_is_key_down[steam_id] = nil, nil, nil
end

local function CanUseAutojump(ply)
  if not IsValid(ply) or not ply:Alive() or ply:InVehicle() or ply:WaterLevel() >= 2 or ply:GetMoveType() ~= MOVETYPE_WALK then return false end
  return true
end

---@param ply Player
---@param is_active boolean
local function SetServerSpamState(ply, is_active)
  if ply:GetNW2Bool(AUTOJUMP_STATE_KEY, false) == is_active then return end
  ply:SetNW2Bool(AUTOJUMP_STATE_KEY, is_active)
  ply:SetNW2String(AUTOJUMP_REASON_KEY, is_active and AUTOJUMP_REASON_VALUE or "")
end

--[[
################
#     HOOK     #
################
]]

hook.Add("StartCommand", "PR_AutoJump_ServerSpam", function(ply, cmd)
  local sid = ply:SteamID64()
  if not cv_aj then cv_aj = GetConVar("pr_autojump") end
  if not cv_aj or cv_aj:GetInt() <= 0 or not CanUseAutojump(ply) or not cmd:KeyDown(IN_JUMP) then
    SetServerSpamState(ply, false)
    ClearPlayerState(sid)
    return
  end
  local now = CurTime()
  jump_held_since[sid] = jump_held_since[sid] or now
  if now - jump_held_since[sid] < GetAutojumpDelay() then
    SetServerSpamState(ply, false)
    return
  end
  SetServerSpamState(ply, true)
  local next_flip_time = spam_next_flip_time[sid] or 0
  local is_key_down = spam_is_key_down[sid]
  if is_key_down == nil then
    is_key_down = true
    spam_is_key_down[sid] = true
    spam_next_flip_time[sid] = now + interval
  elseif now >= next_flip_time then
    is_key_down = not is_key_down
    spam_is_key_down[sid] = is_key_down
    spam_next_flip_time[sid] = now + interval
  end
  if is_key_down then
    cmd:AddKey(IN_JUMP)
    return
  end
  cmd:RemoveKey(IN_JUMP)
end)

hook.Add("PlayerInitialSpawn", "PR_AutoJump_ServerSpamInit", function(ply)
  ply:SetNW2Bool(AUTOJUMP_STATE_KEY, false)
  ply:SetNW2String(AUTOJUMP_REASON_KEY, "")
end)

hook.Add("PlayerDisconnected", "PR_AutoJump_ServerSpamCleanup", function(ply)
  ClearPlayerState(ply:SteamID64())
end)
