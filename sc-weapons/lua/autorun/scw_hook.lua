---@param className string
local function _AddHooks(className)
  if SERVER then
    --[[
    ##################################
    #    SAVE SECONDARY FIRE MODE    #
    ##################################
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
    ##########################################
    #    PREVENT GRENADE EARLY DETONATION    #
    ##########################################
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
############################################################
#    PREVENT SECONDARY FIRE WHEN CONTEXT MENU IS OPENED    #
############################################################
]]
local context_menu_weapons = {
  scaw_mp5 = true,
  scaw_mp5_clean = true,
  scaw_mp5sd = true,
  scaw_mp5sd_clean = true,
  scaw_pistol = true,
  scaw_pistol_clean = true,
  scw_empty = true,
  scw_fastcrowbar = true,
  scw_mm_ar2 = true,
  scw_mm_shotgun = true,
  scw_mm_smg1 = true,
  scw_mp5sd = true,
  scw_scar20 = true,
}

if SERVER then
  util.AddNetworkString("SCW_ContextMenuState")
  net.Receive("SCW_ContextMenuState", function(_, ply)
    local open = net.ReadBool()
    ply:SetNWBool("SCW_IsContextMenuOpened", open)
  end)

  ---@param ply any
  ---@param cmd any
  hook.Add("StartCommand", "SCW_ContextMenuSecondaryFire", function(ply, cmd)
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and context_menu_weapons[wep:GetClass()] and ply:GetNWBool("SCW_IsContextMenuOpened", false) then cmd:RemoveKey(IN_ATTACK2) end
  end)
end

if CLIENT then
  hook.Add("OnContextMenuOpen", "SCW_ContextMenuOpen", function()
    net.Start("SCW_ContextMenuState")
    net.WriteBool(true)
    net.SendToServer()
  end)

  hook.Add("OnContextMenuClose", "SCW_ContextMenuClose", function()
    net.Start("SCW_ContextMenuState")
    net.WriteBool(false)
    net.SendToServer()
  end)
end
