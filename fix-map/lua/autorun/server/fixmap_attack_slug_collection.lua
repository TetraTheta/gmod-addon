--[[
Mod: Attack Slug Collection
Map:
- bemusement
]]

hook.Add("InitPostEntity", "FixMap_ASC_InitPostEntity", function()
  if not SERVER then return end
  if game.GetMap() == "profaned_fortress" then
    local cbow = ents.FindByClass("weapon_crossbow")[1]
    ---@cast cbow Weapon
    if not IsValid(cbow) then return end
    hook.Add("Think", "FixMap_AttackSlugCollection_ProfanedFortress_CBowPickup", function()
      if not IsValid(cbow) then
        hook.Remove("Think", "FixMap_AttackSlugCollection_ProfanedFortress_CBowPickup")
      end
      for _, p in ipairs(player.GetAll()) do
        if IsValid(p) and p:Alive() then
          if p:GetPos():DistToSqr(cbow:GetPos()) <= (60 * 60) then
            if not p:HasWeapon("weapon_crossbow") then
              p:PickupWeapon(cbow)
              hook.Remove("Think", "FixMap_AttackSlugCollection_ProfanedFortress_CBowPickup")
            end
          end
        end
      end
    end)
  end
end)

hook.Add("PlayerSpawn", "FixMap_ASC_PlayerSpawn", function(ply, _)
  local c = game.GetMap()
  if c == "bemusement" then
    ply:SetPos(Vector(-544, -272, 0))
    ply:SetEyeAngles(Angle(0, 90, 0))
  end
end)
