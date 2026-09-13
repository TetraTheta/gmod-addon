--[[
Mod: Map Labs #02: Episode One
Map:
- ep1_eeh
- outland_resistance
]]

hook.Add("PlayerSpawn", "FixMap_ML02_PlayerSpawn", function(ply, _)
  local c = game.GetMap()
  if c == "ep1_eeh" then
    ply:Give("item_suit", false)
    ply:Give("weapon_pistol", false)
    ply:Give("weapon_smg1", false)
    ply:Give("weapon_stunstick", false)
    ply:Give("weapon_physcannon", false)
  elseif c == "outland_resistance" then
    ply:SetPos(Vector(230, -770, -60))
    ply:SetEyeAngles(Angle(0, -180, 0))
  end
end)
