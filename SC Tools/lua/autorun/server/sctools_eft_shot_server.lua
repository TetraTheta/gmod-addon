-- Suppress LuaLS warning. I know what I'm doing.
---@diagnostic disable inject-field, undefined-field
local msgBS = "SCTOOLS_BodyshotEffect"
local msgHS = "SCTOOLS_HeadshotEffect"
util.AddNetworkString(msgBS)
util.AddNetworkString(msgHS)
--
--
-- For humanoid NPC
local armor = {
  npc_metropolice = true,
  npc_combine_s = true
}

-- Order: effectSnd, effectUI, isArmor, isDead, vol
---@param npc NPC
---@param hg HITGROUP
---@param di CTakeDamageInfo
hook.Add("ScaleNPCDamage", "SCTOOLS_ShotEffect", function(npc, hg, di)
  -- Ignore GodMode NPC
  ---@diagnostic disable-next-line: undefined-field
  if npc.SCTOOLS_GODMODE_ENABLED then return true end
  local att = di:GetAttacker()
  if hg ~= HITGROUP_GEAR and hg ~= HITGROUP_GENERIC and att:IsPlayer() then
    -- Prevent other ShotEffect from processing same damage
    if npc.SCTOOLS_GODMODE_ENABLED then
      return
    else
      npc.SCTOOLS_SHOTEFFECT_CD = true
    end

    ---@cast att Player
    -- 1. Should play sound effect? (CLIENT can't read its own cvar)
    -- 2. Should show UI effect? (CLIENT can't read its own cvar)
    if hg == HITGROUP_HEAD then
      net.Start(msgHS)
      local cv = att:GetInfoNum("sc_hshot_effect", 0)
      if cv == 0 then
        return
      elseif cv == 1 then
        net.WriteBool(true) -- effectSnd
        net.WriteBool(false) -- effectUI
      elseif cv == 2 then
        net.WriteBool(false) -- effectSnd
        net.WriteBool(true) -- effectUI
      elseif cv == 3 then
        net.WriteBool(true) -- effectSnd
        net.WriteBool(true) -- effectUI
      else
        net.WriteBool(false) -- effectSnd
        net.WriteBool(false) -- effectUI
      end
    else
      net.Start(msgBS)
      local cv = att:GetInfoNum("sc_bshot_effect", 0)
      if cv == 0 then
        return
      elseif cv == 1 then
        net.WriteBool(true) -- effectSnd
        net.WriteBool(false) -- effectUI
      elseif cv == 2 then
        net.WriteBool(false) -- effectSnd
        net.WriteBool(true) -- effectUI
      elseif cv == 3 then
        net.WriteBool(true) -- effectSnd
        net.WriteBool(true) -- effectUI
      else
        net.WriteBool(false) -- effectSnd
        net.WriteBool(false) -- effectUI
      end
    end

    -- 3. Is the NPC wearing an armor(helmet)?
    if armor[npc:GetClass()] then
      net.WriteBool(true)
    else
      net.WriteBool(false)
    end

    -- 4. Do the NPC die from the damage?
    if npc:Health() - di:GetDamage() <= 0 then
      net.WriteBool(true)
    else
      net.WriteBool(false)
    end

    -- 5. Volume (CLIENT can't read its own cvar)
    net.WriteFloat(att:GetInfoNum("snd_hshotvolume", 1.0))

    net.Send(att)
    timer.Simple(0.1, function()
      if npc.SCTOOLS_SHOTEFFECT_CD then npc.SCTOOLS_SHOTEFFECT_CD = false end
    end)
  end
end)
