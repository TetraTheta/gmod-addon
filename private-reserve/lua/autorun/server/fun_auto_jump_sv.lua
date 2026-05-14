local cv_autojump = GetConVar("pr_autojump")
local spam_interval = math.max(0.01, engine.TickInterval())
local spam_next_flip_time = {}
local spam_is_key_down = {}
local spam_announced_state = {}

local autojump_state_key = "pr_autojump_server_spam"
local autojump_reason_key = "pr_autojump_server_spam_reason"
local autojump_reason_value = "server_allowed"

local function can_use_autojump(ply)
  if not IsValid(ply) then return false end
  if not ply:Alive() then return false end
  if ply:InVehicle() then return false end
  if ply:WaterLevel() >= 2 then return false end
  if ply:GetMoveType() ~= MOVETYPE_WALK then return false end

  return true
end

---@param ply Player
---@param is_active boolean
local function set_server_spam_state(ply, is_active)
  if ply:GetNW2Bool(autojump_state_key, false) == is_active then return end

  ply:SetNW2Bool(autojump_state_key, is_active)
  ply:SetNW2String(autojump_reason_key, is_active and autojump_reason_value or "")

  local steam_id = ply:SteamID64()
  if spam_announced_state[steam_id] == is_active then return end
  spam_announced_state[steam_id] = is_active

  local player_name = ply:Nick()
  local state_text = is_active and "enabled" or "disabled"
  ServerLog(string.format("[AutoJump] Server-managed jump spam %s for %s (%s)\n", state_text, player_name, steam_id))
end

hook.Add("StartCommand", "PR_AutoJump_ServerSpam", function(ply, cmd)
  local steam_id = ply:SteamID64()
  local autojump_mode = cv_autojump:GetInt()
  if autojump_mode <= 0 then
    set_server_spam_state(ply, false)
    spam_next_flip_time[steam_id] = nil
    spam_is_key_down[steam_id] = nil
    return
  end

  if not can_use_autojump(ply) or not cmd:KeyDown(IN_JUMP) then
    set_server_spam_state(ply, false)
    spam_next_flip_time[steam_id] = nil
    spam_is_key_down[steam_id] = nil
    return
  end

  set_server_spam_state(ply, true)

  local now = CurTime()
  local next_flip_time = spam_next_flip_time[steam_id] or 0
  local is_key_down = spam_is_key_down[steam_id]
  if is_key_down == nil then
    is_key_down = true
    spam_is_key_down[steam_id] = true
    spam_next_flip_time[steam_id] = now + spam_interval
  elseif now >= next_flip_time then
    is_key_down = not is_key_down
    spam_is_key_down[steam_id] = is_key_down
    spam_next_flip_time[steam_id] = now + spam_interval
  end

  if is_key_down then
    cmd:AddKey(IN_JUMP)
    return
  end

  cmd:RemoveKey(IN_JUMP)
end)

hook.Add("PlayerInitialSpawn", "PR_AutoJump_ServerSpamInit", function(ply)
  ply:SetNW2Bool(autojump_state_key, false)
  ply:SetNW2String(autojump_reason_key, "")
end)

hook.Add("PlayerDisconnected", "PR_AutoJump_ServerSpamCleanup", function(ply)
  local steam_id = ply:SteamID64()
  spam_next_flip_time[steam_id] = nil
  spam_is_key_down[steam_id] = nil
  spam_announced_state[steam_id] = nil
end)
