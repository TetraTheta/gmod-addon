---@param className string
local function _AddHooks(className)
  if SERVER then
    --[[
    ####################################
    #     SAVE SECONDARY FIRE MODE     #
    ####################################
    ]]
    ---@param save ISave
    saverestore.AddSaveHook(className .. "_SaveData", function(save)
      local saveData = {}
      for _, v in pairs(player.GetHumans()) do ---@cast v Player
        local wep = v:GetWeapon(className)
        if IsValid(wep) then
          ---@diagnostic disable-next-line undefined-field
          saveData[v:SteamID64()] = wep:GetSecondaryMode()
        end
      end

      saverestore.WriteTable(saveData, save)
    end)

    ---@param save IRestore
    saverestore.AddRestoreHook(className .. "_SaveData", function(save)
      if game.MapLoadType() == "transition" then
        local saveData = saverestore.ReadTable(save)
        for k, v in pairs(saveData) do
          local p = player.GetBySteamID64(k)
          if IsValid(p) then
            ---@cast p Player
            local wpn = p:GetWeapon(className)
            if IsValid(wpn) then
              ---@diagnostic disable-next-line undefined-field
              wpn:SetSecondaryMode(v)
            end
          end
        end
      end
    end)

    --[[
    ############################################
    #     PREVENT GRENADE EARLY DETONATION     #
    ############################################
    ]]
    ---@param target Entity
    ---@param dmginfo CTakeDamageInfo
    hook.Add("EntityTakeDamage", className .. "_GrenadeBehavior", function(target, dmginfo)
      if target:GetClass() == "npc_grenade_frag" and target:GetName():StartsWith(className .. "_grenade_") and (dmginfo:GetDamageType() == DMG_BLAST or dmginfo:GetDamageType() == DMG_BURN) then
        --return true
        dmginfo:SetDamage(0)
      end
    end)

    util.AddNetworkString(className .. "_ChangeMode")
  end
end

--
_AddHooks("scaw_mp5")
_AddHooks("scaw_mp5_clean")
_AddHooks("scaw_mp5sd")
_AddHooks("scaw_mp5sd_clean")
_AddHooks("scaw_pistol")
_AddHooks("scaw_pistol_clean")
--[[
##############################################################
#     PREVENT SECONDARY FIRE WHEN CONTEXT MENU IS OPENED     #
##############################################################
]]
if SERVER then
  util.AddNetworkString("SCAW_ContextMenuState")
  net.Receive("SCAW_ContextMenuState", function(_, ply)
    local open = net.ReadBool()
    ply:SetNWBool("SCAW_IsContextMenuOpened", open)
  end)
end

if CLIENT then
  hook.Add("OnContextMenuOpen", "SCAW_ContextMenuOpen", function()
    net.Start("SCAW_ContextMenuState")
    net.WriteBool(true)
    net.SendToServer()
  end)

  hook.Add("OnContextMenuClose", "SCAW_ContextMenuClose", function()
    net.Start("SCAW_ContextMenuState")
    net.WriteBool(false)
    net.SendToServer()
  end)
end
