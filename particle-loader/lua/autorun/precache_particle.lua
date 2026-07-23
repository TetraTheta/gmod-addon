local f_Exists = file.Exists
local g_AddParticles = game.AddParticles

local function AddParticles(pcf)
  if f_Exists(pcf, "GAME") then g_AddParticles(pcf) end
end
--[[
This code just loads particle files, so I don't think '4096 precached particles' limit would be applied here.
So I'll just dump all particle I know.
]]
-- # Garry's Mod
-- ## Source Engine Base
-- AddParticles("particles/antlion_blood.pcf")
-- AddParticles("particles/blood_impact.pcf")
-- AddParticles("particles/burning_fx.pcf")
-- AddParticles("particles/combineball.pcf")
-- AddParticles("particles/error.pcf")
-- AddParticles("particles/fire_01.pcf")
-- AddParticles("particles/rocket_fx.pcf")
-- AddParticles("particles/train_steam.pcf")
-- AddParticles("particles/vortigaunt_fx.pcf")
-- AddParticles("particles/water_impact.pcf")
-- ## GMod Specific
-- AddParticles("particles/gmod_effects.pcf")
-- AddParticles("particles/precipitation.pcf")
-- ## Episodic
-- AddParticles("particles/antlion_gib_01.pcf")
-- AddParticles("particles/antlion_gib_02.pcf")
-- AddParticles("particles/antlion_worker.pcf")
-- AddParticles("particles/grub_blood.pcf")
-- AddParticles("particles/hunter_flechette.pcf")
-- AddParticles("particles/hunter_projectile.pcf")
-- AddParticles("particles/striderbuster.pcf")
-- AddParticles("particles/vehicle.pcf")
-- AddParticles("particles/weapon_fx.pcf")
-- # Half-Life 2
-- # Half-Life 2: Episode 1
AddParticles("particles/ep1_fx.pcf")
-- # Half-Life 2: Episode 2
AddParticles("particles/advisor.pcf")
AddParticles("particles/advisor_fx.pcf")
AddParticles("particles/aurora.pcf")
AddParticles("particles/aurora_sphere2.pcf")
AddParticles("particles/building_explosion.pcf")
AddParticles("particles/choreo_dog_v_strider.pcf")
AddParticles("particles/choreo_extract.pcf")
AddParticles("particles/choreo_gman.pcf")
AddParticles("particles/choreo_launch.pcf")
AddParticles("particles/devtest.pcf")
AddParticles("particles/door_explosion.pcf")
AddParticles("particles/dust_bombdrop.pcf")
AddParticles("particles/dust_rumble.pcf")
AddParticles("particles/electrical_fx.pcf")
AddParticles("particles/explosion.pcf")
AddParticles("particles/grenade_fx.pcf")
AddParticles("particles/hunter_intro.pcf")
AddParticles("particles/hunter_shield_impact.pcf")
AddParticles("particles/impact_fx.pcf")
AddParticles("particles/magnusson_burner.pcf")
AddParticles("particles/rain.pcf")
AddParticles("particles/skybox_smoke.pcf")
AddParticles("particles/stalactite.pcf")
AddParticles("particles/steampuff.pcf")
AddParticles("particles/warpshield.pcf")
AddParticles("particles/water_leaks.pcf")
AddParticles("particles/waterdrips.pcf")
AddParticles("particles/waterfall.pcf")
