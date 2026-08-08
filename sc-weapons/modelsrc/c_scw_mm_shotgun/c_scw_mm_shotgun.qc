$modelname "weapons/c_scw_mm_shotgun.mdl"

$bodygroup "studio"
{
	studio "c_scw_mm_shotgun_spas_fix.smd"
}
$bodygroup "studio"
{
	studio "c_scw_mm_shotgun_sling.smd"
}

$surfaceprop "default"

$contents "solid"

$illumposition 1.801 -14.551 -10.564

$cdmaterials "models/weapons/cw_scw_mm_shotgun/"

$attachment "muzzle" "spas_main" -0.2 35.1 -0.9 rotate 0 90 180
$attachment "shel" "spas_main" -1 5 -0.8 rotate 0 160 180

$cbox 0 0 0 0 0 0

$bbox -15.646 -12.466 -20.128 44.747 16.068 -1

$definebone "spas_main" "" -1.882178 -26.531153 -4.863492 0.000115 0 -179.999978 0 0 0 0 0 0
$definebone "pump" "spas_main" 0.073573 17.526917 0.77722 0.000057 0 0 0 0 0 0 0 0
$definebone "slide" "spas_main" -0.226386 4.254942 -0.608961 -0.000057 0 0 0 0 0 0 0 0
$definebone "12g" "spas_main" 3.782254 -4.556396 5.828506 0.000057 0 0 0 0 0 0 0 0
$definebone "trapdoor" "spas_main" -0.045094 3.566423 0.891595 -0.000057 0 0 0 0 0 0 0 0
$definebone "sl_ring1" "spas_main" -0.116185 1.807585 2.464996 0.000115 0 51.647445 0 0 0 0 0 0
$definebone "sl1a" "sl_ring1" 0 1.030615 0.000004 0.000036 -179.999937 -152.654509 0 0 0 0 0 0
$definebone "sl1b" "sl1a" -0.000002 5.179932 -0.000037 -0.401472 1.592536 13.420847 0 0 0 0 0 0
$definebone "sl_ring2" "spas_main" -0.218267 25.777573 2.487072 0.000115 0 146.730591 0 0 0 0 0 0
$definebone "sl2a" "sl_ring2" 0 0.87035 0.000008 0 0 -1.908294 0 0 0 0 0 0
$definebone "sl2b" "sl2a" 0 4.478401 0.000072 -0.167132 0.495838 20.347926 0 0 0 0 0 0
$definebone "sltarget" "spas_main" -0.295221 15.700035 7.049725 0.000115 0 -89.999982 0 0 0 0 0 0
$definebone "l_wrist" "" 8.27366 -22.415352 -8.598783 85.71145 173.777703 -5.562217 0 0 0 0 0 0
$definebone "l_thumb_low" "l_wrist" -1.294654 1.473667 0.640471 -3.164079 -129.327214 152.434536 0 0 0 0 0 0
$definebone "l_thumb_mid" "l_thumb_low" 0.000011 1.832554 0.000004 -17.818015 44.285065 -2.762223 0 0 0 0 0 0
$definebone "l_thumb_tip" "l_thumb_mid" 0 1.003359 0.000001 -3.41007 9.357795 1.868072 0 0 0 0 0 0
$definebone "l_index_low" "l_wrist" -1.632739 4.327644 -0.483953 14.428968 19.358348 -1.261136 0 0 0 0 0 0
$definebone "l_index_mid" "l_index_low" -0.00001 1.637142 0.00001 0.903666 -6.303688 19.674818 0 0 0 0 0 0
$definebone "l_index_tip" "l_index_mid" 0.000007 1.100985 0.000004 4.403912 -3.907008 14.679214 0 0 0 0 0 0
$definebone "l_middle_low" "l_wrist" -0.500328 4.452953 -0.532495 10.102967 8.861995 27.056614 0 0 0 0 0 0
$definebone "l_middle_mid" "l_middle_low" -0.00001 1.442617 -0.00001 5.184134 -2.89716 18.773405 0 0 0 0 0 0
$definebone "l_middle_tip" "l_middle_mid" -0.000003 1.302446 0.000004 -1.849963 3.141424 25.198931 0 0 0 0 0 0
$definebone "l_ring_low" "l_wrist" 0.523221 4.540312 -0.480714 10.363718 -6.000014 32.327719 0 0 0 0 0 0
$definebone "l_ring_mid" "l_ring_low" -0.000001 1.198256 0.000008 -7.656536 2.475736 22.979968 0 0 0 0 0 0
$definebone "l_ring_tip" "l_ring_mid" -0.000012 0.86978 0.000015 3.638624 -1.068464 12.506437 0 0 0 0 0 0
$definebone "l_pinky_low" "l_wrist" 1.354362 4.150681 -0.582655 1.56108 -15.482065 35.698523 0 0 0 0 0 0
$definebone "l_pinky_mid" "l_pinky_low" 0 1.157421 -0.000006 -8.638908 2.788347 27.614064 0 0 0 0 0 0
$definebone "l_pinky_tip" "l_pinky_mid" 0.000001 1.020055 0.000002 0.686387 -3.028137 22.63705 0 0 0 0 0 0
$definebone "l_upperarm" "" 8 4.003187 -6.495371 0.458538 0.639478 -175.416361 0 0 0 0 0 0
$definebone "l_forearm" "l_upperarm" 0.000038 12.695422 -0.000004 4.456638 0.013866 -0.062096 0 0 0 0 0 0
$definebone "r_wrist" "" -8.338264 -22.41535 -8.598783 85.951292 174.737003 -5.970621 0 0 0 0 0 0
$definebone "r_thumb_low" "r_wrist" -1.391397 1.476538 -0.700638 -55.379116 83.341354 -35.647488 0 0 0 0 0 0
$definebone "r_thumb_mid" "r_thumb_low" 0.000002 1.751797 -0.000002 -11.898445 -12.565386 -33.271388 0 0 0 0 0 0
$definebone "r_thumb_tip" "r_thumb_mid" 0.00001 1.122969 0 -3.356362 -9.950615 -11.287093 0 0 0 0 0 0
$definebone "r_index_low" "r_wrist" -1.596883 4.44162 0.70854 -85.604707 36.896129 -17.21418 0 0 0 0 0 0
$definebone "r_index_mid" "r_index_low" -0.000008 1.481951 -0.000008 8.357875 23.732821 -8.154404 0 0 0 0 0 0
$definebone "r_index_tip" "r_index_mid" 0.000002 1.056648 -0.000004 1.464791 9.102851 -8.737765 0 0 0 0 0 0
$definebone "r_middle_low" "r_wrist" -0.470901 4.219486 0.926555 -5.492001 -176.845578 -160.832568 0 0 0 0 0 0
$definebone "r_middle_mid" "r_middle_low" -0.00001 1.609821 0.000004 -6.698744 5.373151 43.625993 0 0 0 0 0 0
$definebone "r_middle_tip" "r_middle_mid" -0.000002 1.562311 0.000013 0.837263 -1.736124 15.712864 0 0 0 0 0 0
$definebone "r_ring_low" "r_wrist" 0.576838 4.298388 0.639431 4.500051 -178.88469 -142.676436 0 0 0 0 0 0
$definebone "r_ring_mid" "r_ring_low" 0.000002 1.553762 -0.000008 2.958636 1.135375 18.950413 0 0 0 0 0 0
$definebone "r_ring_tip" "r_ring_mid" 0.000003 0.874434 -0.000006 0.049444 -3.089093 12.499 0 0 0 0 0 0
$definebone "r_pinky_low" "r_wrist" 1.459885 4.275572 0.219019 -1.195674 177.801681 -142.876342 0 0 0 0 0 0
$definebone "r_pinky_mid" "r_pinky_low" -0.00001 0.973051 -0.000004 -0.313236 -2.198104 7.124266 0 0 0 0 0 0
$definebone "r_pinky_tip" "r_pinky_mid" 0.000007 0.97089 0.000004 5.673856 -8.484498 30.433544 0 0 0 0 0 0
$definebone "r_upperarm" "" -7.009326 4.003187 -6.495371 -1.63293 -2.99995 -175.420541 0 0 0 0 0 0
$definebone "r_forearm" "r_upperarm" 0.000011 12.706367 0.00001 4.620275 0.014095 -0.062107 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "l_upperarm" 0 0 0 -0.000006 90.000003 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "l_forearm" -0.000006 1.500006 0 -0.000001 90.000003 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "l_wrist" 0 -0.299999 0 -0.000001 90.000003 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "l_thumb_low" 0 0 0 -0.00001 90.000003 0.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "l_thumb_mid" 0 0 0 -0.000002 90.000003 0.000004 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "l_thumb_tip" 0 0.000002 0.000001 -0.000003 109.999971 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "l_index_low" 0 0 0 -0.000005 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "l_index_mid" 0 0 0.000002 0.000017 90.000003 -90.000016 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "l_index_tip" -0.000002 -0.000002 0.000004 0.000044 90.000003 -90.000023 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "l_middle_low" 0.000003 0 0 0.000002 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "l_middle_mid" 0.000002 0.000003 0 0.000019 90.000003 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "l_middle_tip" 0 0 0 -0.000024 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "l_ring_low" -0.000001 0.000011 0 -0.000027 90.000003 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "l_ring_mid" 0 0 0 -0.000039 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "l_ring_tip" 0 -0.000001 0 -0.000022 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "l_pinky_low" -0.000002 0.000002 -0.000002 0.000002 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "l_pinky_mid" 0 0 0 0.000012 90.000003 -90.00003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "l_pinky_tip" 0 0 0 0.00002 90.000003 -90.00003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "r_upperarm" 0 0 0 0 90.000003 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "r_forearm" 0 1.5 0 -0.000006 90.000003 90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "r_wrist" 0 0.300001 0 0 90.000003 90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "r_thumb_low" -0.000011 0.000002 -0.000004 0.000029 90.000003 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "r_thumb_mid" 0 0 0 0.000024 90.000003 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "r_thumb_tip" 0.000001 0 0 0.00001 69.999972 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "r_index_low" 0 0 0 0.000005 90.000003 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "r_index_mid" 0 -0.000002 0 -0.000006 90.000003 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "r_index_tip" 0.000004 0 0 -0.000006 90.000016 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "r_middle_low" -0.000004 0 0.000002 0.000003 90.000003 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "r_middle_mid" 0 -0.000001 0.000008 0 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "r_middle_tip" 0.000001 0 0 -0.000003 90.000003 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "r_ring_low" 0.000001 0.000002 0 0.000003 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "r_ring_mid" 0 0 0 0.000003 90.000003 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "r_ring_tip" 0.000001 0 0 0.00001 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "r_pinky_low" 0.000001 0 0 0.000032 90.000003 -90.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "r_pinky_mid" -0.000001 0 0.000002 0.000036 90.000003 -90.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "r_pinky_tip" 0.000001 0 0 -0.000016 90.000003 -90.000009 0 0 0 0 0 0

$bonemerge "l_wrist"
$bonemerge "l_thumb_low"
$bonemerge "l_thumb_mid"
$bonemerge "l_thumb_tip"
$bonemerge "l_index_low"
$bonemerge "l_index_mid"
$bonemerge "l_index_tip"
$bonemerge "l_middle_low"
$bonemerge "l_middle_mid"
$bonemerge "l_middle_tip"
$bonemerge "l_ring_low"
$bonemerge "l_ring_mid"
$bonemerge "l_ring_tip"
$bonemerge "l_pinky_low"
$bonemerge "l_pinky_mid"
$bonemerge "l_pinky_tip"
$bonemerge "l_upperarm"
$bonemerge "l_forearm"
$bonemerge "r_wrist"
$bonemerge "r_thumb_low"
$bonemerge "r_thumb_mid"
$bonemerge "r_thumb_tip"
$bonemerge "r_index_low"
$bonemerge "r_index_mid"
$bonemerge "r_index_tip"
$bonemerge "r_middle_low"
$bonemerge "r_middle_mid"
$bonemerge "r_middle_tip"
$bonemerge "r_ring_low"
$bonemerge "r_ring_mid"
$bonemerge "r_ring_tip"
$bonemerge "r_pinky_low"
$bonemerge "r_pinky_mid"
$bonemerge "r_pinky_tip"
$bonemerge "r_upperarm"
$bonemerge "r_forearm"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "ValveBiped.Bip01_L_Finger42"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "ValveBiped.Bip01_R_Finger02"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "ValveBiped.Bip01_R_Finger42"

$sectionframes 30 128

$sequence "idle" {
	"c_scw_mm_shotgun_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	{ event 5004 255 "SCW.MM.Shotgun.Sling4" }
	{ event 5004 280 "SCW.MM.Shotgun.Sling3" }
	fadein 0.2
	fadeout 0.2
	node "0"
	fps 50
	loop
}

// $sequence "idle_sighted" {
// 	"c_scw_mm_shotgun_anims/idle_sighted.smd"
// 	activity "ACT_VM_IDLE_SILENCED" 1
// 	fadein 0.2
// 	fadeout 0.2
// 	node "0"
// 	fps 4
// }

$sequence "draw" {
	"c_scw_mm_shotgun_anims/draw.smd"
	activity "ACT_VM_DRAW" 1
	{ event 5004 1 "SCW.MM.Shotgun.Draw" }
	{ event 5004 10 "SCW.MM.Shotgun.Sling3" }
	{ event 5004 18 "SCW.MM.Shotgun.Sling4" }
	fadein 0.2
	fadeout 0.2
	node "0"
	snap
	fps 50
}

$sequence "fire" {
	"c_scw_mm_shotgun_anims/fire.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_shotgun follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_shotgun_smokesprite follow_attachment 1" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_shotgun_trailswithdots follow_attachment 1" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 11 "hl2mmod_muzzleflash_shotgun_dotswithtrails_child follow_origin " }
	fadein 0.2
	fadeout 0.2
	node "2"
	snap
	// fps 45
	fps 60
}

// $sequence "fire_ironsights" {
// 	"c_scw_mm_shotgun_anims/fire_ironsights.smd"
// 	activity "ACT_VM_PRIMARYATTACK_IRONSIGHTED1" 1
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_shotgun follow_attachment muzzle" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_shotgun_smokesprite follow_attachment 1" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_shotgun_trailswithdots follow_attachment 1" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 11 "hl2mmod_muzzleflash_shotgun_dotswithtrails_child follow_origin " }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "2"
// 	snap
// 	fps 50
// }

$sequence "altfire" {
	"c_scw_mm_shotgun_anims/altfire.smd"
	activity "ACT_VM_SECONDARYATTACK" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_shotgun_alt follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_shotgun_smokesprite follow_attachment 1" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_shotgun_trailswithdots follow_attachment 1" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 11 "hl2mmod_muzzleflash_shotgun_dotswithtrails_child follow_origin " }
	fadein 0.2
	fadeout 0.2
	node "2"
	snap
	// fps 55
	fps 73
}

$sequence "holster" {
	"c_scw_mm_shotgun_anims/holster.smd"
	activity "ACT_VM_HOLSTER" 1
	fadein 0.2
	fadeout 0.2
	node "0"
	fps 50
}

$sequence "reload1" {
	"c_scw_mm_shotgun_anims/reload1.smd"
	activity "ACT_SHOTGUN_RELOAD_START" 1
	{ event 5004 0 "SCW.MM.Generic.Movement2" }
	{ event 5004 14 "SCW.MM.Shotgun.Sling4" }
	fadein 0.2
	fadeout 0.2
	node "0"
	// fps 50
	fps 75
}

$sequence "reload2" {
	"c_scw_mm_shotgun_anims/reload2.smd"
	activity "ACT_VM_RELOAD" 1
	{ event 5004 0 "SCW.MM.Generic.Movement6" }
	{ event 5004 9 "SCW.MM.Shotgun.Sling3" }
	fadein 0.2
	fadeout 0.2
	node "0"
	// fps 50
	fps 75
}

$sequence "reload3" {
	"c_scw_mm_shotgun_anims/reload3.smd"
	activity "ACT_SHOTGUN_RELOAD_FINISH" 1
	{ event 5004 1 "SCW.MM.Generic.Movement4" }
	{ event 5004 12 "SCW.MM.Shotgun.Sling2" }
	fadein 0.2
	fadeout 0.2
	node "0"
	// fps 50
	fps 75
}

$sequence "pump" {
	"c_scw_mm_shotgun_anims/pump.smd"
	activity "ACT_SHOTGUN_PUMP" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 10 "hl2mmod_misc_temp_shellexhaust_sidesmoke follow_attachment shel" }
	{ event 6001 5 "2" }
	{ event 5004 4 "SCW.MM.Shotgun.CockBack" }
	{ event 5004 15 "SCW.MM.Shotgun.CockForward" }
	fadein 0.2
	fadeout 0.2
	node "0"
	snap
	// fps 50
	fps 75
}

// $sequence "pump2_sighted" {
// 	"c_scw_mm_shotgun_anims/pump2_sighted.smd"
// 	activity "ACT_SMG2_DRYFIRE2" 1
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 13 "hl2mmod_misc_temp_shellexhaust_sidesmoke follow_attachment shel" }
// 	{ event 5004 11 "SCW.MM.Shotgun.CockBack" }
// 	{ event 5004 20 "SCW.MM.Shotgun.CockForward" }
// 	{ event 5004 2 "SCW.MM.Generic.Movement1" }
// 	{ event 5004 30 "SCW.MM.Generic.Movement4" }
// 	{ event 5004 19 "SCW.MM.Shotgun.Sling2" }
// 	{ event 5004 39 "SCW.MM.Shotgun.Sling3" }
// 	{ event 6001 15 "2" }
// 	{ event 6001 16 "2" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "0"
// 	snap
// 	fps 60
// }

$sequence "lowidle" {
	"c_scw_mm_shotgun_anims/lowidle.smd"
	activity "ACT_VM_IDLE_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	node "1"
	fps 30
	loop
}

$sequence "lowtoidle" {
	"c_scw_mm_shotgun_anims/lowtoidle.smd"
	activity "ACT_VM_LOWERED_TO_IDLE" 1
	{ event 5004 4 "SCW.MM.Shotgun.Sling1" }
	fadein 0.2
	fadeout 0.2
	transition "1" "0"
	fps 50
}

$sequence "idletolow" {
	"c_scw_mm_shotgun_anims/idletolow.smd"
	activity "ACT_VM_IDLE_TO_LOWERED" 1
	{ event 5004 8 "SCW.MM.Shotgun.Sling3" }
	fadein 0.2
	fadeout 0.2
	transition "0" "1"
	fps 50
}

$sequence "walk" {
	"c_scw_mm_shotgun_anims/walk.smd"
	activity "ACT_VM_WALK" 1
	{ event 5004 12 "SCW.MM.Generic.Walk1" }
	{ event 5004 40 "SCW.MM.Generic.Walk2" }
	{ event 5004 65 "SCW.MM.Generic.Walk1" }
	{ event 5004 91 "SCW.MM.Generic.Walk2" }
	{ event 5004 117 "SCW.MM.Generic.Walk1" }
	{ event 5004 143 "SCW.MM.Generic.Walk2" }
	{ event 5004 10 "SCW.MM.Shotgun.SlingWalk1" }
	{ event 5004 38 "SCW.MM.Shotgun.SlingWalk2" }
	{ event 5004 63 "SCW.MM.Shotgun.SlingWalk1" }
	{ event 5004 89 "SCW.MM.Shotgun.SlingWalk2" }
	{ event 5004 115 "SCW.MM.Shotgun.SlingWalk1" }
	{ event 5004 141 "SCW.MM.Shotgun.SlingWalk2" }
	fadein 0.6
	fadeout 0.6
	transition "Ready" "Motion"
	fps 60
	loop
}

$sequence "sprint" {
	"c_scw_mm_shotgun_anims/sprint.smd"
	activity "ACT_VM_SPRINT" 1
	{ event 5004 8 "SCW.MM.Generic.Sprint1" }
	{ event 5004 24 "SCW.MM.Generic.Sprint2" }
	{ event 5004 40 "SCW.MM.Generic.Sprint1" }
	{ event 5004 56 "SCW.MM.Generic.Sprint2" }
	{ event 5004 72 "SCW.MM.Generic.Sprint1" }
	{ event 5004 88 "SCW.MM.Generic.Sprint2" }
	{ event 5004 104 "SCW.MM.Generic.Sprint1" }
	{ event 5004 120 "SCW.MM.Generic.Sprint2" }
	{ event 5004 6 "SCW.MM.Shotgun.SlingRun1" }
	{ event 5004 22 "SCW.MM.Shotgun.SlingRun2" }
	{ event 5004 38 "SCW.MM.Shotgun.SlingRun1" }
	{ event 5004 54 "SCW.MM.Shotgun.SlingRun2" }
	{ event 5004 70 "SCW.MM.Shotgun.SlingRun1" }
	{ event 5004 88 "SCW.MM.Shotgun.SlingRun2" }
	{ event 5004 102 "SCW.MM.Shotgun.SlingRun1" }
	{ event 5004 118 "SCW.MM.Shotgun.SlingRun2" }
	fadein 0.6
	fadeout 0.6
	transition "Ready" "Motion"
	fps 50
	loop
}

// $sequence "inspect1" {
// 	"c_scw_mm_shotgun_anims/inspect1.smd"
// 	activity "ACT_VM_INSPECT" 1
// 	{ event 5004 3 "SCW.MM.Generic.Movement1" }
// 	{ event 5004 60 "SCW.MM.Generic.Movement2" }
// 	{ event 5004 110 "SCW.MM.Generic.Movement5" }
// 	{ event 5004 16 "SCW.MM.Shotgun.Sling1" }
// 	{ event 5004 80 "SCW.MM.Shotgun.Sling2" }
// 	{ event 5004 125 "SCW.MM.Shotgun.Sling4" }
// 	fadein 0.6
// 	fadeout 0.6
// 	fps 50
// }

// $sequence "inspect2" {
// 	"c_scw_mm_shotgun_anims/inspect2.smd"
// 	activity "ACT_VM_INSPECT_ALT" 1
// 	{ event 5004 33 "SCW.MM.Shotgun.CockBack" }
// 	{ event 5004 103 "SCW.MM.Shotgun.CockForward" }
// 	{ event 5004 3 "SCW.MM.Generic.Movement1" }
// 	{ event 5004 111 "SCW.MM.Generic.Movement5" }
// 	{ event 5004 17 "SCW.MM.Shotgun.Sling2" }
// 	{ event 5004 44 "SCW.MM.Shotgun.Sling3" }
// 	{ event 5004 111 "SCW.MM.Shotgun.Sling1" }
// 	fadein 0.6
// 	fadeout 0.6
// 	fps 50
// }
