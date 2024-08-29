
$modelname "weapons/w_scaw_mp5sd.mdl"

$bodygroup "studio"
{
	studio "wmp5-ref-p1.smd"
}
$bodygroup "studio"
{
	studio "wmp5-ref-p2.smd"
}
$bodygroup "studio"
{
	studio "wmp5-m203.smd"
}

$surfaceprop "weapon"

$contents "solid"

$illumposition -1.976 1.162 -1.269

$cdmaterials "models/weapons/cw_scaw_mp5sd/"

// This list shows the VMT file names used in the SMD files.
// "smg_mp5sd.vmt"
// "mp5.vmt"

$attachment "muzzle" "ValveBiped.Weapon_bone" 17.8 0.2 -2.4 rotate 9 0 -92
$attachment "1" "ValveBiped.Weapon_bone" 2 0.8 0 rotate 2 90 -81

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -15.176 -0.553 -8.471 13.364 5.596 5.932

// Hitbox info. Used for damage-based collision.
$hboxset "default"
$hbox 0 "ValveBiped.Bip01_R_Hand" 0 -1.5 -5 5 0 0
$hbox 0 "ValveBiped.Weapon_bone" -6.236 -0.766 -3.31 11.949 1.111 7.763

$definebone "ValveBiped" "" 0 0 0 0 0 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped" 0.267086 -2.58952 10.171795 78.841283 -102.773508 -9.262035 0 0 0 0 0 0
$definebone "ValveBiped.Weapon_bone" "ValveBiped.Bip01_R_Hand" 4.999999 -1.5 -4.999998 0.000002 0 0 0 0 0 0 0 0
$definebone "v_smg_mp5sd_smg_mp5sd_ref" "ValveBiped.Weapon_bone" -1.526246 0.342619 4.248839 -3.586085 -89.151433 169.066552 0 0 0 0 0 0
$definebone "c_bms_mp5_reference" "ValveBiped.Weapon_bone" -11.144035 -5.009563 -1.419485 -3.414026 -88.261166 169.01217 0 0 0 0 0 0

$sequence "idle" {
	"w_scaw_mp5sd_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "attack1" {
	"w_scaw_mp5sd_anims/attack1.smd"
	activity "ACT_RANGE_ATTACK_SMG1" 1
	{ event AE_NPC_MUZZLEFLASH 0 "SMG1 MUZZLE" }
	{ event 3002 0 "" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	fps 20
}

$sequence "attackoffcenter" {
	"w_scaw_mp5sd_anims/attackoffcenter.smd"
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
