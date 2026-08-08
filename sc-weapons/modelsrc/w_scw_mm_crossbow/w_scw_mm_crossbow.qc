$modelname "weapons/w_scw_mm_crossbow.mdl"

$bodygroup "studio"
{
	studio "w_scw_mm_crossbow_hl2dm_reference.smd"
}

$surfaceprop "weapon"

$contents "solid"

$illumposition 2.079 -8.815 2.818

$cdmaterials "models/weapons/cw_scw_mm_crossbow/"

$attachment "muzzle" "ValveBiped.bone" 0 4 22 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -10.455 -13.233 -2.965 28.164 17.451 8.6

$definebone "ValveBiped" "" 0 0 0 0 0 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped" 0 0 0 -80.175534 -4.106389 93.445006 0 0 0 0 0 0
$definebone "ValveBiped.bone" "ValveBiped.Bip01_R_Hand" 1.165489 -1.926164 -0.5236 0.712129 -80.313497 -88.476829 0 0 0 0 0 0

$sequence "idle" {
	"w_scw_mm_crossbow_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "attack1" {
	"w_scw_mm_crossbow_anims/attack1.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_scw_mm_crossbow_physics.smd"
{
	$mass 10
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
