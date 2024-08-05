
$modelname "weapons/c_scaw_mp5sd.mdl"

$bodygroup "studio"
{
	studio "mp5-ref-p1.smd"
}
$bodygroup "studio"
{
	studio "mp5-ref-p2.smd"
}
$bodygroup "studio"
{
	studio "mp5-mag.smd"
}
$bodygroup "studio"
{
	studio "mp5-m203.smd"
}
$bodygroup "arms"
{
	studio "c_arms_hev.smd"
}

$surfaceprop "default"

$contents "solid"

$illumposition 2.822 -1.758 -12.756

$cdmaterials "models/weapons/cw_scaw_mp5sd/"
//$cdmaterials "models\Weapons\V_hand\"

// This list shows the VMT file names used in the SMD files.
// "smg_mp5sd.vmt"
// "mp5.vmt"

$attachment "muzzle" "ValveBiped.Muzzle" 4.3 0 0 rotate 0 0 0
$attachment "1" "ValveBiped.Eject" 0 0 0 rotate 0 0 0

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -14.501 -12.513 -20.019 30.026 22.302 4.361

// Hitbox info. Used for damage-based collision.
// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "ValveBiped.Bip01_Spine4" 0 0 -1.937608 2.033356 1.000775 1.937662
// $hbox 0 "mp5sd-bolt" 0 -9.859279 0 1.014441 0 4.361215
// $hbox 0 "MP5_New" -1.092263 -16.619255 -8.826021 17.268572 0 0
// $hbox 0 "v_weapon.mp7_parent" 0 0 -16.824747 3.900003 7.266023 0
// $hbox 0 "v_weapon.mp5sd_parent" -1.094407 -13.08941 -2.906272 1.09441 4.035177 5.143456
// $hbox 0 "v_weapon.bolt" -1.025441 -10.253046 -1.949843 0.494935 0 0

$definebone "ValveBiped.Bip01_Spine4" "" 0.000006 0 0 -79.749938 -89.999873 -90.000153 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Clavicle" "ValveBiped.Bip01_Spine4" 2.033349 1.000765 1.937662 -73.711859 168.619503 91.480309 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "ValveBiped.Bip01_L_Clavicle" 6.028142 0.000001 0 2.738853 -33.527947 -90.505156 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "ValveBiped.Bip01_L_UpperArm" 11.692554 0.000001 0 -0.000003 -3.459059 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "ValveBiped.Bip01_L_Forearm" 11.48167 0 -0.000025 -6.108486 2.532073 90.136743 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "ValveBiped.Bip01_L_Hand" 3.85972 -0.142404 -1.191975 8.682204 -50.431559 -26.82204 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "ValveBiped.Bip01_L_Finger4" 1.31255 -0.000002 0 0.000001 -25.194099 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "ValveBiped.Bip01_L_Finger41" 0.729361 -0.000002 -0.000002 0.000003 -13.997302 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "ValveBiped.Bip01_L_Hand" 3.942343 0.046766 -0.431443 4.194396 -46.466016 -8.696353 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "ValveBiped.Bip01_L_Finger3" 1.539093 0 0 0.000001 -14.197717 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "ValveBiped.Bip01_L_Finger31" 1.196321 -0.000006 0 0.000001 -24.683136 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "ValveBiped.Bip01_L_Hand" 3.883703 -0.046762 0.431443 1.250769 -33.682286 4.921823 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "ValveBiped.Bip01_L_Finger2" 1.719564 0.000002 -0.000001 0.316048 -20.99762 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "ValveBiped.Bip01_L_Finger21" 1.209171 -0.000004 0 0.176705 -12.398786 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "ValveBiped.Bip01_L_Hand" 3.859869 -0.137939 1.332466 -2.449394 -30.465185 20.308435 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "ValveBiped.Bip01_L_Finger1" 1.719427 0.000006 0 0.233429 -20.798881 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "ValveBiped.Bip01_L_Finger11" 1.099661 0.000006 -0.000001 0.148743 -13.999131 -0.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "ValveBiped.Bip01_L_Hand" 0.806061 -0.348927 1.321258 -38.916031 -45.19599 -70.054231 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "ValveBiped.Bip01_L_Finger0" 1.78978 -0.000004 -0.000004 -0.000017 13.093409 0.000012 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "ValveBiped.Bip01_L_Finger01" 1.207008 0.000001 0 -0.00002 20.790345 0.000007 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Clavicle" "ValveBiped.Bip01_Spine4" 2.033356 1.000775 -1.937608 73.712037 168.618547 -95.596776 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "ValveBiped.Bip01_R_Clavicle" 6.028143 0.000001 0 -0.46209 -33.623816 93.935243 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "ValveBiped.Bip01_R_UpperArm" 11.692556 0 0.000004 -0.000026 -3.459059 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped.Bip01_R_Forearm" 11.48171 0 0.000007 6.108052 2.532073 -89.664285 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "ValveBiped.Bip01_R_Hand" 3.859684 -0.132568 1.193109 -9.056511 -50.352957 26.71335 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "ValveBiped.Bip01_R_Finger4" 1.312563 -0.000008 0.000001 0.000006 -25.191333 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "ValveBiped.Bip01_R_Finger41" 0.729365 0 -0.000003 0.000007 -13.995683 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "ValveBiped.Bip01_R_Hand" 3.94231 0.050329 0.431044 -4.537308 -46.421323 8.598835 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "ValveBiped.Bip01_R_Finger3" 1.539095 -0.000002 0.000001 0.000003 -14.196212 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "ValveBiped.Bip01_R_Finger31" 1.196321 0.000011 0 0.000001 -24.680769 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "ValveBiped.Bip01_R_Hand" 3.883659 -0.05032 -0.431042 -1.512839 -33.67245 -4.921996 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "ValveBiped.Bip01_R_Finger2" 1.719582 0.000002 0 -0.456875 -20.995235 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "ValveBiped.Bip01_R_Finger21" 1.209183 -0.000006 0 -0.255595 -12.397419 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "ValveBiped.Bip01_R_Hand" 3.859844 -0.148932 -1.331282 2.209725 -30.481413 -20.306712 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "ValveBiped.Bip01_R_Finger1" 1.719423 0 -0.000001 -0.378897 -20.796652 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "ValveBiped.Bip01_R_Finger11" 1.099672 0.000011 0 -0.241274 -13.998045 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "ValveBiped.Bip01_R_Hand" 0.806026 -0.359837 -1.318334 38.596422 -45.467517 69.98164 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "ValveBiped.Bip01_R_Finger0" 1.789782 0.000004 -0.000002 -0.000006 13.095249 0.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "ValveBiped.Bip01_R_Finger01" 1.207003 0.000008 0.000008 -0.000007 20.792926 0.000007 0 0 0 0 0 0
$definebone "ValveBiped.Eject" "" -5.14268 -14.322638 -3.720817 0.602007 -178.754807 89.198241 0 0 0 0 0 0
$definebone "ValveBiped.Muzzle" "" -4.222328 -29.715271 -5.071053 0.80174 -88.746355 90.602849 0 0 0 0 0 0
$definebone "Bolt_New" "" -4.708097 -7.527452 -4.797627 -0.580005 1.151932 0.818012 0 0 0 0 0 0
$definebone "mp5sd-bolt" "Bolt_New" -0.051742 -0.901916 -3.071959 0.576396 -0.255138 -0.820533 0 0 0 0 0 0
$definebone "ClipRelease_New" "" -4.708098 -7.109372 -6.818066 -0.234741 1.268127 -15.41835 0 0 0 0 0 0
$definebone "mp5sd-release" "ClipRelease_New" -0.037313 -0.797713 -1.819803 0.322804 -0.287567 15.416813 0 0 0 0 0 0
$definebone "MP5_New" "" -4.708097 -7.527447 -4.797627 -0.580005 1.151932 0.818012 0 0 0 0 0 0
$definebone "v_weapon.mp7_parent" "MP5_New" 17.268572 -4.899109 -8.826021 0.320513 89.748112 85.17642 0 0 0 0 0 0
$definebone "v_weapon.mp5sd_parent" "v_weapon.mp7_parent" 3.900003 7.266023 -16.824747 -85.000017 -90.000153 0.00006 0 0 0 0 0 0
$definebone "v_weapon.trigger" "v_weapon.mp5sd_parent" 0.000001 -1.971148 0.841605 -0.000002 0 0.000057 0 0 0 0 0 0
$definebone "v_weapon.bolt" "v_weapon.mp5sd_parent" 0.26526 -9.592839 4.013939 -0.000002 0 0.000057 0 0 0 0 0 0
$definebone "Shell_New" "" -4.767184 -5.990303 -3.656682 -0.263847 1.262398 -14.101352 0 0 0 0 0 0
$definebone "mp5sd-bullets" "Shell_New" -0.014133 -1.113792 -4.821301 0.342915 -0.282296 14.099692 0 0 0 0 0 0
$definebone "Clip_New" "" -4.767308 -5.849318 -3.126938 -0.263847 1.262455 -14.101352 0 0 0 0 0 0
$definebone "mp5sd-mag" "Clip_New" -0.019557 -1.121441 -5.369407 0.342973 -0.282354 14.099697 0 0 0 0 0 0
$definebone "Trigger_Grenade_New" "" -4.708097 -7.527446 -4.797627 -0.580005 1.151932 0.818012 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_Spine4"
$bonemerge "ValveBiped.Bip01_L_Clavicle"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "ValveBiped.Bip01_L_Finger42"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "ValveBiped.Bip01_R_Clavicle"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "ValveBiped.Bip01_R_Finger42"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "ValveBiped.Bip01_R_Finger02"

$sequence "idle1" {
	"c_scaw_mp5sd_anims/idle1.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	fps 30
	loop
}

$sequence "idle2" {
	"c_scaw_mp5sd_anims/idle2.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	fps 30
	loop
}

$sequence "grenade" {
	"c_scaw_mp5sd_anims/grenade.smd"
	activity "ACT_VM_SECONDARYATTACK" 1
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "reload" {
	"c_scaw_mp5sd_anims/reload.smd"
	activity "ACT_VM_RELOAD" 1
	{ event AE_CL_PLAYSOUND 0 "weapon_mp5sdm203.Reload" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "shoot" {
	"c_scaw_mp5sd_anims/shoot.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	{ event AE_MUZZLEFLASH 0 "SMG1 MUZZLE" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "shoot2" {
	"c_scaw_mp5sd_anims/shoot2.smd"
	activity "ACT_VM_RECOIL1" 1
	{ event AE_MUZZLEFLASH 0 "SMG1 MUZZLE" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "shoot3" {
	"c_scaw_mp5sd_anims/shoot3.smd"
	activity "ACT_VM_RECOIL2" 1
	{ event AE_MUZZLEFLASH 0 "SMG1 MUZZLE" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 40
}

$sequence "shoot4" {
	"c_scaw_mp5sd_anims/shoot4.smd"
	activity "ACT_VM_RECOIL3" 1
	{ event AE_MUZZLEFLASH 0 "SMG1 MUZZLE" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 40
}

$sequence "draw" {
	"c_scaw_mp5sd_anims/draw.smd"
	activity "ACT_VM_DRAW" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	snap
	fps 30
}

$sequence "draw2" {
	"c_scaw_mp5sd_anims/draw2.smd"
	activity "ACT_VM_DRAW" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	snap
	fps 30
}

$sequence "holster" {
	"c_scaw_mp5sd_anims/holster.smd"
	activity "ACT_VM_HOLSTER" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}
