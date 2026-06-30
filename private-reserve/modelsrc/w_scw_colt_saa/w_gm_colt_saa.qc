$modelname "weapons/w_scw_colt_saa.mdl"

$bodygroup "studio"
{
	studio "w_colt_saa_ref.smd"
}

$surfaceprop "weapon"

$contents "solid"

$illumposition 0.503 -6.301 0.137

$cdmaterials "models/weapons/v_colt_saa/"

$attachment "muzzle" "ValveBiped.Muzzle" 0 0 0 rotate -90 -90 0

$cbox 0 0 0 0 0 0

$bbox -1.597 -1.487 -4.264 14.199 2.493 4.581

$definebone "ValveBiped" "" 0 0 0 0 0 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped" -1.040719 -1.86425 -1.514839 -89.294157 46.302037 39.750724 0 0 0 0 0 0
$definebone "ValveBiped.bone" "ValveBiped.Bip01_R_Hand" 2.361367 -2.987601 -2.56965 3.639313 -89.621712 -89.53193 0 0 0 0 0 0
$definebone "ValveBiped.Muzzle" "ValveBiped.bone" -1.904834 2.566494 13.397079 -0.113216 0.002578 -2.112094 0 0 0 0 0 0

$sequence "idle" {
	"w_gm_colt_saa_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 1
	loop
}

$sequence "attack_player" {
	"w_gm_colt_saa_anims\attack_player.smd"
	activity "ACT_VM_PRIMARYATTACK" -1
	{ event AE_NPC_MUZZLEFLASH 0 "PISTOL muzzle" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 5
}

$sequence "attack_npc" {
	"w_gm_colt_saa_anims\attack_npc.smd"
	activity "ACT_RANGE_ATTACK_PISTOL" -1
	{ event AE_NPC_MUZZLEFLASH 0 "PISTOL muzzle" }
	{ event 3014 0 "" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 5
}

$sequence "attack_hl2mp" {
	"w_gm_colt_saa_anims\attack_hl2mp.smd"
	activity "ACT_HL2MP_RANGE_ATTACK_REVOLVER" -1
	{ event AE_NPC_MUZZLEFLASH 0 "357 muzzle" }
	{ event CL_EVENT_EJECTBRASS1 0 "2" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 5
}

$sequence "attack2" {
	"w_gm_colt_saa_anims\attack2.smd"
	activity "ACT_RANGE_REVOLVER" -1
	{ event AE_NPC_MUZZLEFLASH 0 "357 muzzle" }
	{ event CL_EVENT_EJECTBRASS1 0 "2" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 5
}

$collisionmodel "w_gm_colt_saa_physics.smd"
{
	$mass 2
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
