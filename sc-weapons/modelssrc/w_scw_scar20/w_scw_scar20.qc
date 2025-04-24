$modelname "weapons/w_scw_scar20.mdl"

$bodygroup "studio"
{
	studio "w_scw_scar20.smd"
}

$surfaceprop "weapon"

$contents "solid"

$illumposition 0.037 -9.187 3.241

$opaque

$cdmaterials "models/weapons/w_scw_scar20/"
$cdmaterials "models/weapons/csgo_scope/"

// This list shows the VMT file names used in the SMD files.
// "snip_scar20.vmt"
// "scope_scar20.vmt"

$attachment "muzzle" "ValveBiped.Bip01_R_Hand" 35 -0.7 -11 rotate 10 0 -90
$attachment "eject" "ValveBiped.Bip01_R_Hand" 6 -0.7 -5 rotate 30 90 -90

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -9.433 -1.439 -2.036 38.362 1.493 10.09

// Hitbox info. Used for damage-based collision.
// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "ValveBiped.Bip01_R_Hand" -11.875229 -2.400962 -12.420822 35.416668 0.545719 2.848474

$definebone "ValveBiped.Bip01_R_Hand" "" -0.878223 3.235967 0.568833 9.99998 -89.982886 -179.811615 0 0 0 0 0 0

$sequence "idle" {
	"w_scw_scar20_anims/idle.smd"
	activity "ACT_VM_IDLE" -1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "attack" {
	"w_scw_scar20_anims/attack.smd"
	activity "ACT_VM_PRIMARYATTACK" -1
	{ event 5003 0 "2" }
	{ event AE_CLIENT_EFFECT_ATTACH 0 "EjectBrass_762Nato 2 100" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_scw_scar20_physics.smd"
{
	$mass 7.711882
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
