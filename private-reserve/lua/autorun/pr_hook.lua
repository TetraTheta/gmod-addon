--[[
############################################################
#    PREVENT SECONDARY FIRE WHEN CONTEXT MENU IS OPENED    #
############################################################
]]
local context_menu_weapons = {
  scw_colt_saa = true,
  weapon_smg2 = true,
}

if SERVER then
  util.AddNetworkString("PR_ContextMenuState")
  net.Receive("PR_ContextMenuState", function(_, ply)
    local open = net.ReadBool()
    ply:SetNWBool("PR_IsContextMenuOpened", open)
  end)

  ---@param ply any
  ---@param cmd any
  hook.Add("StartCommand", "PR_ContextMenuSecondaryFire", function(ply, cmd)
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and context_menu_weapons[wep:GetClass()] and ply:GetNWBool("PR_IsContextMenuOpened", false) then cmd:RemoveKey(IN_ATTACK2) end
  end)
end

if CLIENT then
  hook.Add("OnContextMenuOpen", "PR_ContextMenuOpen", function()
    net.Start("PR_ContextMenuState")
    net.WriteBool(true)
    net.SendToServer()
  end)

  hook.Add("OnContextMenuClose", "PR_ContextMenuClose", function()
    net.Start("PR_ContextMenuState")
    net.WriteBool(false)
    net.SendToServer()
  end)
end
