-- Suppress LuaLS warning. I know what I'm doing.
---@diagnostic disable inject-field, undefined-field
local msgBS = "SCTOOLS_BodyshotEffect"
local msgHS = "SCTOOLS_HeadshotEffect"
util.AddNetworkString(msgBS)
util.AddNetworkString(msgHS)
--
local catAnimal = {
  npc_barnacle = true,
  npc_bullsquid = true,
  npc_crow = true,
  npc_headcrab = true,
  npc_headcrab_black = true,
  npc_headcrab_fast = true,
  npc_headcrab_poison = true,
  npc_ichthyosaur = true,
  npc_pigeon = true,
  npc_seagull = true,
}

local catAntlion = {
  npc_antlion = true,
  npc_antlion_grub = true,
  npc_antlion_worker = true,
  npc_antlionguard = true,
  npc_antlionguardian = true,
}

local catHumanoid = {
  npc_alyx = true,
  npc_barney = true,
  npc_breen = true,
  npc_citizen = true,
  npc_combine_s = true,
  npc_eli = true,
  npc_fastzombie = true,
  npc_fastzombie_torso = true,
  npc_fisherman = true,
  npc_gman = true,
  npc_kleiner = true,
  npc_magnusson = true,
  npc_metropolice = true,
  npc_monk = true,
  npc_mossman = true,
  npc_poisonzombie = true,
  npc_stalker = true,
  npc_vortigaunt = true,
  npc_zombie = true,
  npc_zombie_torso = true,
  npc_zombine = true,
}

local catRobot = {
  npc_clawscanner = true,
  npc_combine_camera = true,
  npc_crabsynth = true,
  npc_cscanner = true,
  npc_manhack = true,
  npc_mortarsynth = true,
  npc_turret_ceiling = true,
}

local catSynth = {
  npc_hunter = true,
}

local hasArmor = {
  npc_combine_s = true,
  npc_metropolice = true,
}

---@param npc NPC
local function _GetNPCType(npc)
  local class = npc:GetClass()
  if catAnimal[class] then
    return 0
  elseif catAntlion[class] then
    return 1
  elseif catHumanoid[class] then
    return 2
  elseif catRobot[class] then
    return 3
  elseif catSynth[class] then
    return 4
  else
    return -1
  end
end

---@param npc NPC
---@param hg HITGROUP
---@param di CTakeDamageInfo
hook.Add("ScaleNPCDamage", "SCTOOLS_ShotEffect_Humanoid", function(npc, hg, _) npc.SCTOOLS_LAST_HITGROUP = hg end)
---@param ent Entity
---@param di CTakeDamageInfo
hook.Add("PostEntityTakeDamage", "SCTOOLS_ShotEffect", function(ent, di, _)
  -- Ignore GodMode NPC or already processing NPC
  if ent.SCTOOLS_GODMODE_ENABLED or ent.SCTOOLS_SHOTEFFECT_CD or ent.SCTOOLS_SHOTEFFECT_DEAD or not ent:IsNPC() then return end
  --
  local class = ent:GetClass()
  local att = di:GetAttacker()
  local hg = ent.SCTOOLS_LAST_HITGROUP
  --
  if att:IsPlayer() then
    ---@cast att Player
    -- Prevent other ShotEffect from processing same damage
    ent.SCTOOLS_SHOTEFFECT_CD = true
    -- 0. Prepare
    local cv = 0
    if hg == HITGROUP_HEAD then
      net.Start(msgHS)
      cv = att:GetInfoNum("sc_hshot_effect", 0)
    else
      net.Start(msgBS)
      cv = att:GetInfoNum("sc_bshot_effect", 0)
    end

    if cv <= 0 then
      net.Abort()
      return
    end

    -- 1. NPC Category (Animal, Antlion, Humanoid, Robot, Synth)
    local type = _GetNPCType(ent)
    if type == -1 then
      net.Abort()
      return
    end

    net.WriteUInt(type, 3)
    -- 2. Client Effect Type
    net.WriteUInt(cv, 3)
    -- 3. Armor/Helmet status
    net.WriteBool(hasArmor[class] and true or false)
    -- 4. NPC Death (Is this NPC dead from this damage?)
    if ent:Health() <= 0 then
      ent.SCTOOLS_SHOTEFFECT_DEAD = true
      net.WriteBool(true)
    else
      net.WriteBool(false)
    end

    -- 5. Volume (CLIENT can't read its own cvar)
    if hg == HITGROUP_HEAD then
      net.WriteFloat(att:GetInfoNum("snd_hshotvolume", 1.0))
    else
      net.WriteFloat(att:GetInfoNum("snd_bshotvolume", 1.0))
    end

    -- 6. NPC Class (for debugging)
    net.WriteString(ent:GetClass())
    -- Send
    net.Send(att)
    timer.Simple(0.1, function() if ent.SCTOOLS_SHOTEFFECT_CD then ent.SCTOOLS_SHOTEFFECT_CD = false end end)
  end
end)
