require("sctools")
local GetPlayerByName = sctools.command.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
--[[
###########################
#     COMMAND EXECUTE     #
###########################
]]
--
---@param ply Player
---@param args table
---@param silent boolean
local function HealPlayer(ply, args, silent)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 and not silent then SendMessage("[SC Heal] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    p:SetHealth(p:GetMaxHealth())
    if not silent then
      if p ~= ply then SendMessage(Format("[SC Heal] Healed %s.", p:Nick()), ply) end
      SendMessage("[SC Heal] You are healed.", p, HUD_PRINTTALK)
    end
  end
end

---@param ply Player
---@param args table
---@param silent boolean
local function OverhealPlayer(ply, args, silent)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 and not silent then SendMessage("[SC Heal] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    local sccm = GetConVar("sk_suitcharger_citadel_maxarmor")
    local ma = sccm ~= nil and sccm:GetInt() or 200 -- 'IsValid(ConVar)' returns 'false' wtf?
    p:SetHealth(p:GetMaxHealth())
    p:SetArmor(ma) -- instead of 'p:GetMaxArmor()' which is limited to 100 by default
    if not silent then
      if p ~= ply then SendMessage(Format("[SC Heal] Overhealed %s.", p:Nick()), ply) end
      SendMessage("[SC Heal] You are overhealed.", p, HUD_PRINTTALK)
    end
  end
end

--[[
#################################
#     COMMAND AUTO COMPLETE     #
#################################
]]
--
---@param args string
---@return table
local function HealComplete(_, args)
  return SuggestPlayer("sc_heal", args)
end

---@param args string
---@return table
local function OverHealComplete(_, args)
  return SuggestPlayer("sc_overheal", args)
end

--
--[[
############################
#     COMMAND REGISTER     #
############################
]]
--
concommand.Add("sc_heal", function(ply, _, args, _) HealPlayer(ply, args, false) end, HealComplete, "Heal player.", {FCVAR_NONE})
concommand.Add("sc_heal_s", function(ply, _, args, _) HealPlayer(ply, args, true) end, HealComplete, "Heal player. (Silent)", {FCVAR_NONE})
--
concommand.Add("sc_overheal", function(ply, _, args, _) OverhealPlayer(ply, args, false) end, OverHealComplete, "Overheal player.", {FCVAR_NONE})
concommand.Add("sc_overheal_s", function(ply, _, args, _) OverhealPlayer(ply, args, true) end, OverHealComplete, "Overheal player. (Silent)", {FCVAR_NONE})
