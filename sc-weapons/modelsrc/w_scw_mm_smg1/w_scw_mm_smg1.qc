$modelname "weapons/w_scw_mm_smg1.mdl"

$bodygroup "studio"
{
	studio "w_smg1_reference_new.smd"
}

$surfaceprop "weapon"

$contents "solid"

$illumposition 0.436 -0.386 -1.853

$mostlyopaque

$cdmaterials "models/weapons/cw_scw_mm_smg1/"
$cdmaterials "models/weapons/cw_scw_mm_pistol/"

$attachment "muzzle" "ValveBiped.Weapon_bone" 15 -0.1 -3.65 rotate 9 0 -92
$attachment "1" "ValveBiped.Weapon_bone" -1.7 1 0.7 rotate 2 90 -81

$cbox 0 0 0 0 0 0

$bbox -14.684 -2.814 -10.197 15.457 3.686 6.492

$definebone "ValveBiped" "" 0 0 0 0 0 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped" 0.267086 -2.58952 10.171795 78.841058 -102.775277 -9.263639 0 0 0 0 0 0
$definebone "ValveBiped.Weapon_bone" "ValveBiped.Bip01_R_Hand" 4.999995 -1.499978 -5.000006 0.000228 0 0 0 0 0 0 0 0


$sequence "idle" {
	"w_scw_mm_smg1_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "attack1" {
	"w_scw_mm_smg1_anims/attack1.smd"
	activity "ACT_RANGE_ATTACK_SMG1" 1
	{ event AE_NPC_MUZZLEFLASH 0 "SMG1 MUZZLE" }
	{ event 3002 0 "" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	fps 20
}

$sequence "attackoffcenter" {
	"w_scw_mm_smg1_anims/attackoffcenter.smd"
	{ event AE_NPC_MUZZLEFLASH 0 "SMG1 MUZZLE" }
	{ event 3002 0 "lefthand" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	fps 20
}

$collisionmodel "w_smg1_physics.smd"
{
	$mass 8
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
