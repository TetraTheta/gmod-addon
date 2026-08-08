--[[
Mod: Attack Slug Collection
Map:
- bemusement
]]

-- local maps = {
--   bemusement = true,
--   beyond_the_fortress = true,
--   crosscastle = true,
--   profaned_fortress = true,
--   sacrificial_chamber = true,
--   snowy_castle = true,
--   talisman = true,
--   temple = true,
--   unlikely_friends = true
-- }

hook.Add("PlayerSpawn", "FixMap_AttackSlugCollection_PlayerSpawn", function(ply, _)
  if SERVER then
    local cm = game.GetMap()
    if cm == "bemusement" then
      -- set location
      ply:SetPos(Vector(-544, -272, 0))
      ply:SetEyeAngles(Angle(0, 90, 0))
    end
  end
end)

-- hook.Add("PlayerLoadout", "FixMap_AttackSlugCollection_PlayerLoadout", function(ply)
--   if SERVER then
--     local cm = game.GetMap()
--     -- strip weapons first
--     if maps[cm] then
--       ply:StripWeapons()
--       timer.Simple(0.1, function() ply:StripWeapons() end)
--       ---@diagnostic disable-next-line: redundant-return-value -- this is valid return that prevents default loadout
--       return true
--     end
--   end
-- end)

hook.Add("InitPostEntity", "FixMap_AttackSlugCollection_InitPostEntity", function()
  if SERVER then
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
  end
end)
