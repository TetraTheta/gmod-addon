--[[
Mod: Death Mine Island
Map:
- deadman_island
]]

hook.Add("InitPostEntity", "FixMap_DMI_InitPostEntity", function()
  if not SERVER then return end
  local k1 = ents.FindByName("blackout")[1]
  local k2 = ents.FindByName("startcam")[2]
  if IsValid(k1) then k1:Remove() end
  if IsValid(k2) then k2:Remove() end
end)

hook.Add("PlayerSpawn", "FixMap_DMI_PlayerSpawn", function(ply, _)
  if game.GetMap() == "deadman_island" then
    ply:SetPos(Vector(-7680, 9024, -48))
    ply:SetEyeAngles(Angle(0, 270, 0))
  end
end)
