--[[
Mod: Unexpected Escape
Map:
- prisoncellep2_1
]]
hook.Add("InitPostEntity", "FixMap_UE_prisoncellep2_1", function()
  if SERVER and game.GetMap() == "prisoncellep2_1" then
    local equip = ents.Create("game_player_equip")
    equip:SetPos(Vector(1144, 944, -1015))
    equip:Spawn()
    equip:Activate()
    equip:SetSpawnFlags(1)
    equip:SetKeyValue("targetname", "givepistolandammo")
    equip:SetKeyValue("weapon_pistol", "1")
    equip:SetKeyValue("item_ammo_pistol_large", "2")
    --
    local pistol = ents.Create("weapon_pistol")
    pistol:SetPos(Vector(1185, 944, -1009))
    pistol:Spawn()
    pistol:Activate()
    pistol:Input("AddOutput", pistol, nil, "OnPlayerPickup givepistolandammo,Use,0,-1")
    --
    local drum1 = ents.Create("prop_physics")
    drum1:SetModel("models/props_c17/oildrum001.mdl")
    drum1:SetPos(Vector(3924, 1072, -886))
    drum1:Spawn()
    drum1:Activate()
    drum1:PhysicsInit(SOLID_VPHYSICS)
  end
end)
