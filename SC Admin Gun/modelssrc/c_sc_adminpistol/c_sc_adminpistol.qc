
$modelname "weapons/c_sc_adminpistol.mdl"

$bodygroup "studio"
{
	studio "v_pistol_reference.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 1.284 -13.309 -15.132

$cdmaterials "models\weapons\v_sc_adminpistol\"

// This list shows the VMT file names used in the SMD files.
// "v_pistol_sheet.vmt"

$attachment "muzzle" "ValveBiped.Bip01_R_Hand" 12.06 -1.53 -3.42 rotate -0.38 -0.61 -90.67
$attachment "1" "ValveBiped.Bip01_R_Hand" 4.27 -1.51 -4.06 rotate 45.67 89.01 -90.54

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -6.097 -7.915 -27.204 32.714 10.483 -3.061

// Hitbox info. Used for damage-based collision.
// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "ValveBiped.Bip01_Spine4" 0 0 -1.93761 2.033356 1.000772 1.93766
// $hbox 0 "ValveBiped.Bip01_R_Hand" 0 -2.215301 -4.243275 11.779617 0.050327 1.693259
// $hbox 0 "ValveBiped.square" -0.703591 -0.635412 -4.286886 0.671641 1.017382 4.029089
// $hbox 0 "ValveBiped.clip" -0.71126 -2.508824 -1.419627 0.517027 2.634278 1.138558

$definebone "ValveBiped.Bip01_Spine4" "" 0.000006 0 0 -79.749938 -89.999873 -90.000098 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Clavicle" "ValveBiped.Bip01_Spine4" 2.033349 1.000767 1.93766 -73.711859 168.619271 91.480542 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "ValveBiped.Bip01_L_Clavicle" 6.028141 0 0 2.738853 -33.527944 -90.505156 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "ValveBiped.Bip01_L_UpperArm" 11.692554 0.000001 0 -0.000002 -3.459061 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "ValveBiped.Bip01_L_Forearm" 11.48167 0.000001 -0.000031 -6.108474 2.532073 90.136743 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "ValveBiped.Bip01_L_Hand" 3.859711 -0.142405 -1.191975 8.682205 -50.431559 -26.82204 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "ValveBiped.Bip01_L_Finger4" 1.312555 -0.000002 0 0.000001 -25.194097 0.000007 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "ValveBiped.Bip01_L_Finger41" 0.729363 -0.000002 -0.000002 0.000003 -13.997299 0.000012 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "ValveBiped.Bip01_L_Hand" 3.942337 0.046767 -0.431443 4.194397 -46.465995 -8.696351 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "ValveBiped.Bip01_L_Finger3" 1.539097 0 0 0 -14.197712 0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "ValveBiped.Bip01_L_Finger31" 1.196325 -0.000002 -0.000001 0 -24.683136 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "ValveBiped.Bip01_L_Hand" 3.883698 -0.046765 0.431443 1.250768 -33.682282 4.921822 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "ValveBiped.Bip01_L_Finger2" 1.71957 -0.000004 -0.000001 0.316048 -20.997622 0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "ValveBiped.Bip01_L_Finger21" 1.209169 -0.000004 0 0.176704 -12.398786 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "ValveBiped.Bip01_L_Hand" 3.859863 -0.137946 1.332466 -2.449394 -30.465185 20.308439 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "ValveBiped.Bip01_L_Finger1" 1.719431 0.000002 0 0.233433 -20.798875 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "ValveBiped.Bip01_L_Finger11" 1.099667 0 -0.000001 0.148751 -13.999135 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "ValveBiped.Bip01_L_Hand" 0.806053 -0.348926 1.321258 -38.916041 -45.19599 -70.054231 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "ValveBiped.Bip01_L_Finger0" 1.789778 -0.000002 0.000002 -0.000012 13.09341 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "ValveBiped.Bip01_L_Finger01" 1.207005 0 0.000002 -0.000015 20.790351 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Clavicle" "ValveBiped.Bip01_Spine4" 2.033356 1.000772 -1.93761 73.712037 168.618779 -95.596496 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "ValveBiped.Bip01_R_Clavicle" 6.028145 0 0 -0.462089 -33.623802 93.935243 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "ValveBiped.Bip01_R_UpperArm" 11.692554 0.000001 0.000002 -0.000003 -3.459063 0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped.Bip01_R_Forearm" 11.481699 0.000001 0.000001 6.108076 2.532071 -89.664285 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "ValveBiped.Bip01_R_Hand" 3.85968 -0.132567 1.193109 -9.056512 -50.352984 26.713351 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "ValveBiped.Bip01_R_Finger4" 1.312555 -0.000002 0.000002 -0.000008 -25.191368 -0.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "ValveBiped.Bip01_R_Finger41" 0.729365 0 -0.000001 -0.000005 -13.995701 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "ValveBiped.Bip01_R_Hand" 3.942307 0.050327 0.431044 -4.537308 -46.42134 8.598833 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "ValveBiped.Bip01_R_Finger3" 1.539099 -0.000002 0 -0.000002 -14.196243 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "ValveBiped.Bip01_R_Finger31" 1.196321 0.00001 0 0 -24.680793 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "ValveBiped.Bip01_R_Hand" 3.883659 -0.050321 -0.431042 -1.512837 -33.672467 -4.921997 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "ValveBiped.Bip01_R_Finger2" 1.719578 0.000002 0 -0.456875 -20.995266 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "ValveBiped.Bip01_R_Finger21" 1.209185 0.000002 0 -0.255595 -12.397452 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "ValveBiped.Bip01_R_Hand" 3.85984 -0.148937 -1.331282 2.209728 -30.481423 -20.306718 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "ValveBiped.Bip01_R_Finger1" 1.719421 0.000002 0 -0.378888 -20.796659 0.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "ValveBiped.Bip01_R_Finger11" 1.099669 0.000002 -0.000001 -0.241264 -13.998063 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "ValveBiped.Bip01_R_Hand" 0.806023 -0.359837 -1.318334 38.596446 -45.467541 69.98164 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "ValveBiped.Bip01_R_Finger0" 1.789782 0 -0.000004 -0.000014 13.095232 0.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "ValveBiped.Bip01_R_Finger01" 1.206999 0.000002 0 -0.000014 20.792928 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.square" "ValveBiped.Bip01_R_Hand" 6.104527 -1.468679 -3.530282 -0.669732 -90.60985 -89.621938 0 0 0 0 0 0
$definebone "ValveBiped.clip" "ValveBiped.Bip01_R_Hand" 3.82074 -1.409995 -0.589409 -0.669732 -90.60985 -89.621938 0 0 0 0 0 0

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


$animation "a_adjustment_corrective_animation" "c_sc_adminpistol_anims\a_adjustment_corrective_animation.smd" {
}

$animation "a_adjustment_corrective_animation" "c_sc_adminpistol_anims\a_adjustment_corrective_animation.smd" {
	fps 30
}

$animation "a_adjustment_ref" "c_sc_adminpistol_anims\a_adjustment_ref.smd" {
	fps 30
}

$animation "a_adjustment" "c_sc_adminpistol_anims\a_adjustment.smd" {
	fps 1
	loop
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_adjustment_corrective_animation" 0
}

$sequence "idle01" {
	"c_sc_adminpistol_anims\idle01.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	node "0"
	fps 30
	loop
}

$sequence "idle01empty" {
	"c_sc_adminpistol_anims\idle01empty.smd"
	activity "ACT_VM_IDLE_EMPTY" 1
	fadein 0.2
	fadeout 0.2
	node "0"
	fps 30
	loop
}

$sequence "fire" {
	"c_sc_adminpistol_anims\fire.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	{ event AE_MUZZLEFLASH 0 "PISTOL MUZZLE" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	node "2"
	snap
	fps 30
}

$sequence "fire1" {
	"c_sc_adminpistol_anims\fire1.smd"
	activity "ACT_VM_RECOIL1" 1
	{ event AE_MUZZLEFLASH 0 "PISTOL MUZZLE" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	node "2"
	snap
	fps 30
}

$sequence "fire2" {
	"c_sc_adminpistol_anims\fire2.smd"
	activity "ACT_VM_RECOIL2" 1
	{ event AE_MUZZLEFLASH 0 "PISTOL MUZZLE" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	node "2"
	snap
	fps 30
}

$sequence "fire3" {
	"c_sc_adminpistol_anims\fire3.smd"
	activity "ACT_VM_RECOIL3" 1
	{ event AE_MUZZLEFLASH 0 "PISTOL MUZZLE" }
	{ event 6001 0 "0" }
	fadein 0.2
	fadeout 0.2
	node "2"
	snap
	fps 30
}

$sequence "fireempty" {
	"c_sc_adminpistol_anims\fireempty.smd"
	activity "ACT_VM_DRYFIRE" 1
	fadein 0.2
	fadeout 0.2
	node "2"
	fps 30
}

$sequence "draw" {
	"c_sc_adminpistol_anims\draw.smd"
	activity "ACT_VM_DRAW" 1
	fadein 0.2
	fadeout 0.2
	node "0"
	snap
	fps 30
}

$sequence "drawempty" {
	"c_sc_adminpistol_anims\drawempty.smd"
	fadein 0.2
	fadeout 0.2
	node "0"
	fps 30
}

$sequence "reload" {
	"c_sc_adminpistol_anims\reload.smd"
	activity "ACT_VM_RELOAD" 1
	fadein 0.2
	fadeout 0.2
	node "0"
	fps 30
}

$sequence "holster" {
	"c_sc_adminpistol_anims\holster.smd"
	activity "ACT_VM_HOLSTER" 1
	fadein 0.2
	fadeout 0.2
	node "0"
	fps 30
}

$sequence "holsterempty" {
	"c_sc_adminpistol_anims\holsterempty.smd"
	activity "ACT_VM_HOLSTER" 1
	fadein 0.2
	fadeout 0.2
	node "0"
	fps 30
}

$sequence "idletolow" {
	"c_sc_adminpistol_anims\idletolow.smd"
	activity "ACT_VM_LOWERED_TO_IDLE" 1
	fadein 0.2
	fadeout 0.2
	transition "0" "1"
	fps 30
}

$sequence "lowtoidle" {
	"c_sc_adminpistol_anims\lowtoidle.smd"
	activity "ACT_VM_IDLE_TO_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	transition "1" "0"
	fps 30
}

$sequence "lowidle" {
	"c_sc_adminpistol_anims\lowidle.smd"
	activity "ACT_VM_IDLE_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	node "1"
	fps 30
	loop
}

$sequence "adjustment" {
	"a_adjustment"
	autoplay
	delta
	fadein 0.2
	fadeout 0.2
	hidden
}
