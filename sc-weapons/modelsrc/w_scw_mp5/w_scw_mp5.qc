$modelname "weapons/w_scw_mp5.mdl"

$bodygroup "gun"
{
	studio "wpn_t9_smg_standard_view_lod0.smd"
}
$bodygroup "clamped1"
{
	studio "body1_model0.smd"
}

$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "models/weapons/cw_scw_mp5/"
$cdmaterials "models/weapons/mp5_pack/"

$texturegroup "skinfamilies"
{
	{
		"mtl_wpn_t9_smg_standard_receiver"
		"mtl_wpn_t9_smg_standard_receiver_lower"
		"mtl_wpn_t9_smg_standard_handguard"
		"mtl_wpn_t9_smg_standard_sight"
		"mtl_wpn_t9_smg_standard_stock_mount"
		"mtl_wpn_t9_smg_standard_stock"
		"xmaterial_8043352077a10f3"
		"mtl_wpn_t9_smg_standard_mag"
	}
	{
		"pap_rainbow"
		"pap_rainbow"
		"pap_rainbow"
		"pap_rainbow"
		"pap_rainbow"
		"pap_rainbow"
		"pap_rainbow"
		"pap_rainbow"
	}
}

$attachment "1" "tag_flash" 0 0 0 rotate 0 0 0
$attachment "2" "tag_flash" -25.35 -0.5 0 rotate 0 -90 0

$cbox 0 0 0 0 0 0

$bbox -1.6 -21.634 -5.13 1.666 23.097 4.226

$definebone "tag_view" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_weapon_right" "tag_torso" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_weapon" "tag_weapon_right" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_foregrip" "tag_weapon" 7.954 -0.000003 0.000001 0 0 0 0 0 0 0 0 0
$definebone "j_shell" "tag_weapon" -2.283 0.000002 0.425 0 0 0 0 0 0 0 0 0
$definebone "j_shelldoor" "tag_weapon" -3.914001 0.000002 0.093999 0 0 0 0 0 0 0 0 0
$definebone "tag_flash" "tag_weapon" 22.851 -0.001011 1.857002 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on" "tag_weapon" -0.000001 0 2 0 0 0 0 0 0 0 0 0
$definebone "j_ejectport" "tag_weapon" -2.282001 0.000001 1.827 0 0 0 0 0 0 0 0 0

$sequence "idle" {
	"w_scw_mp5_anims/idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 15
	loop
}

$collisionmodel "w_scw_mp5_physics.smd"
{
	$mass 5
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
