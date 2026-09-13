--[[
Mod: RaiseTheBarVille
Map:
- delayed_rtbv
]]

hook.Add("PlayerSpawn", "FixMap_RTBV_PlayerSpawn", function(ply, _)
  if game.GetMap() == "delayed_rtbv" then
    ply:SetPos(Vector(-6909, 13232, 11448))
    ply:SetEyeAngles(Angle(0, 175, 0))
  end
end)
