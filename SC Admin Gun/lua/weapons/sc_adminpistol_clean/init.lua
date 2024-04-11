-- Send these scripts to client
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
-- Load shared script
include("shared.lua")
-- Register Secondary Fire Mode net message
util.AddNetworkString("SCAPC_ChangeMode")
--
-- Preserve secondary fire mode between map transition
saverestore.AddSaveHook("SCAdminPistolCleanSaveData", function(save)
  local saveData = {}
  for _, v in pairs(player.GetHumans()) do
    local weapon = v:GetWeapon(SCAPCclassName)
    if IsValid(weapon) then saveData[v:SteamID64()] = weapon.Secondary.Mode end
  end

  saverestore.WriteTable(saveData, save)
end)

saverestore.AddRestoreHook("SCAdminPistolCleanSaveData", function(save)
  if game.MapLoadType() ~= "transition" then return end
  local saveData = saverestore.ReadTable(save)
  for k, v in pairs(saveData) do
    local ply = player.GetBySteamID64(k)
    if IsValid(ply) then
      local wpn = ply:GetWeapon(SCAPCclassName)
      if IsValid(wpn) then
        --- It is defined!
        ---@diagnostic disable-next-line: undefined-field
        wpn.Secondary.Mode = v
      end
    end
  end
end)

--
-- Prevent grenade from exploding by BLAST or BURN damage
hook.Add("EntityTakeDamage", "SCAdminPistolCleanGrenadeBehavior", function(target, dmginfo)
  if target:GetClass() == "npc_grenade_frag" and string.StartsWith(target:GetName(), "scapcg_") and (dmginfo:GetDamageType() == DMG_BLAST or dmginfo:GetDamageType() == DMG_BURN) then
    --return true
    dmginfo:SetDamage(0)
  end
end)

PrintTable(SWEP)
