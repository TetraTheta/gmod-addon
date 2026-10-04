--[[
Mod: Half-Life 2: Cinematic Mod
]]

hook.Add("PlayerEnteredVehicle", "FixMap_HL2CM_PlayerEnteredVehicle", function(ply, vehicle, role)
  if IsValid(vehicle) and vehicle:GetClass() == "prop_vehicle_jeep" then
    timer.Simple(0, function()
      if IsValid(vehicle) then
        if vehicle.Fire then
          vehicle:Fire("EnableGun", "1", 0)
        end
      end
    end)
    timer.Simple(0.05, function()
      if IsValid(vehicle) then
        vehicle:SetBodygroup(1, 1)
      end
    end)
  end
end)
