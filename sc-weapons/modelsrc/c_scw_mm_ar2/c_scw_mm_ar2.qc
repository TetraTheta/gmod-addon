$modelname "weapons/c_scw_mm_ar2.mdl"

$bodygroup "studio"
{
	studio "v_irifle_reference.smd"
}
$bodygroup "core_in_barrel"
{
	studio "v_irifle_reference_core1.smd"
	blank
}
$bodygroup "core_in_mag"
{
	studio "v_irifle_reference_core2.smd"
	blank
}
$bodygroup "core_in_mag_clone"
{
	studio "v_irifle_reference_core2_2.smd"
	blank
}

$surfaceprop "default"

$contents "solid"

$illumposition -1.736 -11.656 -9.388

$cdmaterials "models/weapons/cw_scw_mm_ar2/"

$texturegroup "skinfamilies"
{
	{ "v_ar2_body"          "v_ar2_pulse"          }
	{ "v_ar2_body_charging" "v_ar2_pulse_charging" }
}

$attachment "muzzle" "ar2_weapon" 25 -1 0 rotate 0 0 90
$attachment "1" "ar2_weapon" 11.3 -1 0 rotate 65 -180 -40
$attachment "secondary" "ar2_weapon" 22 2.5 -0.2 rotate 0 0 90
$attachment "punch" "ar2_weapon" 11.9 -1.2 0.25 rotate 0 0 90

$cbox 0 0 0 0 0 0

$bbox -13.2 -13.913 -19.907 36.513 10.441 1.131

$definebone "ar2_weapon" "" -3.558143 -5.275417 0.014885 0 -89.999982 -89.999982 0 0 0 0 0 0
$definebone "ar2_mag" "ar2_weapon" 9.243773 6.139962 1.326173 0.000057 -89.999982 -0.000057 0 0 0 0 0 0
$definebone "ar2_big_hammer" "ar2_weapon" 3.442229 -1.240687 -0.005672 -0.000172 0 -0.000115 0 0 0 0 0 0
$definebone "ar2_vent" "ar2_weapon" 17.667921 -1.384574 1.233112 -0.000172 -179.999964 0 0 0 0 0 0 0
$definebone "ar2_arm1" "ar2_weapon" 13.081079 -1.084008 0.792839 -50.390363 -180.000005 90.000016 0 0 0 0 0 0
$definebone "ar2_arm1_tip" "ar2_arm1" 0.758741 0.00001 -0.000001 0 -64.441701 -89.999982 0 0 0 0 0 0
$definebone "ar2_arm2" "ar2_weapon" 12.977262 -1.858502 0.676013 -24.541035 -144.179529 29.697205 0 0 0 0 0 0
$definebone "ar2_arm2_tip" "ar2_arm2" 0.562688 -0.000006 -0.000004 -0.462253 -54.973177 -0.745654 0 0 0 0 0 0
$definebone "ar2_mag_loader2" "" -1.947611 -14.498632 -1.747319 -60.941851 0.001203 -179.999964 0 0 0 0 0 0
$definebone "ar2_mag_loader1" "ar2_mag_loader2" 2.341381 0.000021 0.000003 71.179867 -0.002636 89.996656 0 0 0 0 0 0
$definebone "l_wrist" "" 8.27366 -15.41854 -0.926869 0.417457 -90.645189 175.772336 0 0 0 0 0 0
$definebone "l_thumb_low" "l_wrist" 1.473635 0.639422 -1.295233 42.064837 38.432641 121.667539 0 0 0 0 0 0
$definebone "l_thumb_mid" "l_thumb_low" 1.832607 -0.000004 0.000007 2.720887 43.433945 178.192477 0 0 0 0 0 0
$definebone "l_thumb_tip" "l_thumb_mid" 1.003331 0 0 -0.825332 -9.614555 -174.182596 0 0 0 0 0 0
$definebone "l_index_low" "l_wrist" 3.823887 -0.419591 -1.411516 20.64521 -2.816771 13.450294 0 0 0 0 0 0
$definebone "l_index_mid" "l_index_low" 2.187963 0 0 -6.804632 21.420052 -1.453653 0 0 0 0 0 0
$definebone "l_index_tip" "l_index_mid" 1.100958 -0.000014 0 -4.875306 14.690289 3.264761 0 0 0 0 0 0
$definebone "l_middle_low" "l_wrist" 3.987879 -0.577435 -0.474708 4.546369 21.596604 12.496722 0 0 0 0 0 0
$definebone "l_middle_mid" "l_middle_low" 1.8901 -0.000008 0 -8.906195 24.700276 4.019491 0 0 0 0 0 0
$definebone "l_middle_tip" "l_middle_mid" 1.310926 0.000015 0 4.391931 23.589518 1.310349 0 0 0 0 0 0
$definebone "l_ring_low" "l_wrist" 4.117973 -0.654501 0.453699 -10.081302 29.584186 6.061203 0 0 0 0 0 0
$definebone "l_ring_mid" "l_ring_low" 1.655293 0.000002 0 5.094451 25.616421 -6.194244 0 0 0 0 0 0
$definebone "l_ring_tip" "l_ring_mid" 0.869586 0.000011 0 -1.823791 12.490267 3.304421 0 0 0 0 0 0
$definebone "l_pinky_low" "l_wrist" 4.150639 -0.58158 1.354867 -13.383028 36.84744 -17.041773 0 0 0 0 0 0
$definebone "l_pinky_mid" "l_pinky_low" 1.157248 -0.000013 -0.000002 2.24504 28.080496 1.996271 0 0 0 0 0 0
$definebone "l_pinky_tip" "l_pinky_mid" 1.019835 0.000002 0.000002 -2.924933 22.690971 -84.090919 0 0 0 0 0 0
$definebone "l_upperarm" "" 8 11 1.176544 4.722032 -89.355745 -90.447633 0 0 0 0 0 0
$definebone "l_forearm" "l_upperarm" 12.695436 0.000001 0.000018 0.102445 -0.334665 4.449991 0 0 0 0 0 0
$definebone "r_wrist" "" -8.338264 -15.418537 -0.926868 0.417457 -89.35483 175.944853 0 0 0 0 0 0
$definebone "r_thumb_low" "r_wrist" 1.474217 -0.497913 -1.376119 46.798455 -31.821793 67.981385 0 0 0 0 0 0
$definebone "r_thumb_mid" "r_thumb_low" 1.832175 -0.000001 0.000001 -7.47143 41.829707 -146.219911 0 0 0 0 0 0
$definebone "r_thumb_tip" "r_thumb_mid" 1.042012 0 -0.000006 -18.307784 0.076884 -169.265994 0 0 0 0 0 0
$definebone "r_index_low" "r_wrist" 3.823319 0.66487 -1.331676 20.74087 0.228495 14.011167 0 0 0 0 0 0
$definebone "r_index_mid" "r_index_low" 2.152367 0.00001 0 -13.26498 -24.689281 7.086632 0 0 0 0 0 0
$definebone "r_index_tip" "r_index_mid" 1.056626 -0.00001 0 -9.796137 -8.174983 12.921255 0 0 0 0 0 0
$definebone "r_middle_low" "r_wrist" 3.985126 0.881823 -0.368987 7.376714 -15.404715 8.319061 0 0 0 0 0 0
$definebone "r_middle_mid" "r_middle_low" 1.830173 0 0 -13.227589 -47.15968 11.201029 0 0 0 0 0 0
$definebone "r_middle_tip" "r_middle_mid" 1.561352 0.000013 0 -1.596203 -15.762572 0.322776 0 0 0 0 0 0
$definebone "r_ring_low" "r_wrist" 4.116548 0.711289 0.551868 -5.170945 -35.602918 15.913207 0 0 0 0 0 0
$definebone "r_ring_mid" "r_ring_low" 1.752729 -0.000006 0 -0.570261 -21.043509 2.263241 0 0 0 0 0 0
$definebone "r_ring_tip" "r_ring_mid" 0.869356 0.000002 0 -3.773229 -12.055032 -2.094278 0 0 0 0 0 0
$definebone "r_pinky_low" "r_wrist" 4.118825 0.331244 1.419828 -6.565752 -37.015251 17.533087 0 0 0 0 0 0
$definebone "r_pinky_mid" "r_pinky_low" 1.176325 -0.000002 0 6.841119 -9.641196 7.09261 0 0 0 0 0 0
$definebone "r_pinky_tip" "r_pinky_mid" 0.970213 0 0 -0.117119 -32.870244 97.431692 0 0 0 0 0 0
$definebone "r_upperarm" "" -7.009326 11 1.176544 4.714413 -92.822599 -88.352616 0 0 0 0 0 0
$definebone "r_forearm" "r_upperarm" 12.706341 0.000001 0 0.102731 -0.334206 4.620451 0 0 0 0 0 0
$definebone "ar2_core" "ar2_weapon" 11.809021 -1.206475 0.191726 -0.000172 0 -0.000115 0 0 0 0 0 0
$definebone "ar2_mag_core" "ar2_mag_loader1" 0.598399 -0.643255 -0.162013 -89.999982 -47.878359 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "l_upperarm" 0.00001 0 0.000011 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "l_forearm" 1.2 0 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "l_wrist" 0.00001 -0.3 0 0 -9.999999 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "l_thumb_low" 0 -0.000001 0.000003 -0.000041 0.00002 0.000034 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "l_thumb_mid" 0.000002 0 -0.000002 0.00005 -0.000019 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "l_thumb_tip" 0.000002 0 0.000002 -0.000027 20.00003 -0.000022 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "l_index_low" 0 0 0 -0.000004 0.000001 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "l_index_mid" 0.000002 -0.000002 0 -0.000003 -0.000031 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "l_index_tip" 0.000007 0.000004 0 -0.000015 -0.000034 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "l_middle_low" 0.000001 -0.000004 0 -0.000003 0 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "l_middle_mid" 0.000002 0.00001 0 -0.000022 0.000017 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "l_middle_tip" 0 0 0 -0.000016 0.000026 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "l_ring_low" -0.000001 -0.000004 0 0.000004 -0.000002 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "l_ring_mid" 0 -0.000004 0 -0.000008 0.000007 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "l_ring_tip" 0.000001 -0.000002 0 -0.000003 0.000039 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "l_pinky_low" 0.000001 -0.000002 0 0 -0.000041 179.999978 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "l_pinky_mid" 0 0 0 0.000018 0.000005 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "l_pinky_tip" 0 0 0 -0.000051 0.000016 -90.000016 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "r_upperarm" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "r_forearm" 1.200001 0 0 0 0 0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "r_wrist" 0 0.3 0 0 10.000001 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "r_thumb_low" 0 0 -0.000001 0.00002 -0.000014 -0.000017 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "r_thumb_mid" 0 0 -0.000001 -0.00002 -0.000001 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "r_thumb_tip" 0 0 0 0.000005 19.99995 0.000029 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "r_index_low" -0.000004 0.000003 0 -0.000009 0.000003 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "r_index_mid" 0.000009 -0.000006 0 -0.000021 -0.000036 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "r_index_tip" 0 -0.000002 -0.000001 -0.00004 -0.000043 0.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "r_middle_low" 0 0 0 -0.000006 0.000022 -0.000007 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "r_middle_mid" 0 0 0 0.000003 0.000036 -0.000022 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "r_middle_tip" 0 0.000002 0 -0.000003 0.000021 -0.000016 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "r_ring_low" -0.000007 -0.000013 0 0.000001 0.000041 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "r_ring_mid" 0 0 0 -0.000007 0.000002 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "r_ring_tip" 0 0 0 -0.000011 -0.000002 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "r_pinky_low" 0 0 0 0.000001 0.000002 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "r_pinky_mid" 0 0 0 -0.000003 0.000019 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "r_pinky_tip" 0 0 0.000004 0.000075 0 -90.000023 0 0 0 0 0 0

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

$sequence "idle" {
	"c_scw_mm_ar2_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	fps 18
	loop
}

$sequence "fire1" {
	"c_scw_mm_ar2_anims/fire1.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2 follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2_punch follow_attachment punch" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_muzzleflash_ar2_dist follow_attachment muzzle" }
	{ event 6001 1 "1" }
	{ event 3101 0 "" }
	{ event 3102 5 "" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "fire2" {
	"c_scw_mm_ar2_anims/fire2.smd"
	activity "ACT_VM_RECOIL1" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2 follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2_punch follow_attachment punch" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_muzzleflash_ar2_dist follow_attachment muzzle" }
	{ event 6001 1 "1" }
	{ event 3101 0 "" }
	{ event 3102 5 "" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "fire3" {
	"c_scw_mm_ar2_anims/fire3.smd"
	activity "ACT_VM_RECOIL2" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2 follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2_punch follow_attachment punch" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_muzzleflash_ar2_dist follow_attachment muzzle" }
	{ event 6001 1 "1" }
	{ event 3101 0 "" }
	{ event 3102 5 "" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "fire4" {
	"c_scw_mm_ar2_anims/fire4.smd"
	activity "ACT_VM_RECOIL3" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2 follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2_punch follow_attachment punch" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_muzzleflash_ar2_dist follow_attachment muzzle" }
	{ event 6001 1 "1" }
	{ event 3101 0 "" }
	{ event 3102 5 "" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

// It seems 'ACT_VM_PRIMARYATTACK_MIDEMPTY' isn't registered. Maybe MMod exclusive?
// ACT_VM_PRIMARYATTACK_MIDEMPTY: Fire and Put last bullet in the Magazine (Magazine becomes empty)
// This doesn't work well, so I'll comment it.
// $sequence "fire_midempty" {
// 	"c_scw_mm_ar2_anims/fire_midempty.smd"
// 	activity "ACT_VM_PRIMARYATTACK_MIDEMPTY" 1
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2 follow_attachment muzzle" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2_punch follow_attachment punch" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_muzzleflash_ar2_dist follow_attachment muzzle" }
// 	{ event 3101 0 "" }
// 	{ event 3102 5 "" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Fire"
// 	snap
// 	fps 30
// }

// It seems 'ACT_VM_SHOOTLAST' isn't registered. Maybe MMod exclusive?
// ACT_VM_SHOOTLAST: Fire last bullet in the Chamber (Magazine is already empty)
// This doesn't work well, so I'll comment it.
// $sequence "fire_last" {
// 	"c_scw_mm_ar2_anims/fire_last.smd"
// 	activity "ACT_VM_SHOOTLAST" 1
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2 follow_attachment muzzle" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2_punch follow_attachment punch" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_muzzleflash_ar2_dist follow_attachment muzzle" }
// 	{ event 3101 0 "" }
// 	{ event 3102 5 "" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Fire"
// 	snap
// 	fps 30
// }

// shake: Shake AR2 before firing Combine Ball (Charging)
$sequence "shake" {
	"c_scw_mm_ar2_anims/shake.smd"
	activity "ACT_VM_FIDGET" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2_alt_charge follow_attachment secondary" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	// fps 30
	fps 45
	loop
}

$sequence "fire_alt" {
	"c_scw_mm_ar2_anims/fire_alt.smd"
	activity "ACT_VM_SECONDARYATTACK" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_ar2_alt follow_attachment secondary" }
	{ event AE_CL_PLAYSOUND 26 "SCW.MM.AR2.BoltPull" }
	{ event AE_CL_PLAYSOUND 27 "SCW.MM.AR2.ReloadPush" }
	{ event AE_CL_PLAYSOUND 13 "SCW.MM.Generic.Movement3" }
	{ event AE_CL_PLAYSOUND 28 "SCW.MM.Generic.Movement2" }
	fadein 0.2
	fadeout 0.2
	snap
	// fps 30
	fps 45
}

$sequence "reload" {
	"c_scw_mm_ar2_anims/reload.smd"
	activity "ACT_VM_RELOAD" 1
	{ event AE_CL_PLAYSOUND 3 "SCW.MM.AR2.ReloadRotate" }
	{ event AE_CL_PLAYSOUND 10 "SCW.MM.AR2.MagOut" }
	{ event AE_CL_PLAYSOUND 39 "SCW.MM.AR2.MagIn" }
	{ event AE_CL_PLAYSOUND 40 "SCW.MM.AR2.ReloadPush" }
	{ event AE_CL_PLAYSOUND 11 "SCW.MM.Generic.Movement2" }
	{ event AE_CL_PLAYSOUND 25 "SCW.MM.Generic.Movement5" }
	{ event 3015 20 "muzzle" }
	{ event 3102 0 "" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	// fps 30
	fps 45
}

// It seems 'ACT_VM_RELOADMIDEMPTY' isn't registered. Maybe MMod exclusive?
// ACT_VM_RELOADMIDEMPTY: Reload while Magazine is empty but Chamber has a bullet
// This doesn't work well, so I'll comment it.
// $sequence "reload_midempty" {
// 	"c_scw_mm_ar2_anims/reload_midempty.smd"
// 	activity "ACT_VM_RELOADMIDEMPTY" 1
// 	{ event AE_CL_PLAYSOUND 3 "SCW.MM.AR2.ReloadRotate" }
// 	{ event AE_CL_PLAYSOUND 10 "SCW.MM.AR2.MagOut" }
// 	{ event AE_CL_PLAYSOUND 39 "SCW.MM.AR2.MagIn" }
// 	{ event AE_CL_PLAYSOUND 40 "SCW.MM.AR2.ReloadPush" }
// 	{ event AE_CL_PLAYSOUND 11 "SCW.MM.Generic.Movement2" }
// 	{ event AE_CL_PLAYSOUND 25 "SCW.MM.Generic.Movement5" }
// 	{ event 3015 20 "muzzle" }
// 	{ event 3102 0 "" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Fire"
// 	fps 30
// }

// It seems 'ACT_VM_RELOADEMPTY' isn't registered. Maybe MMod exclusive?
// ACT_VM_RELOADEMPTY: Reload while both Chamber and Magazine is empty
// This doesn't work well, so I'll comment it.
// $sequence "reload_empty" {
// 	"c_scw_mm_ar2_anims/reload_empty.smd"
// 	activity "ACT_VM_RELOADEMPTY" 1
// 	{ event AE_CL_PLAYSOUND 3 "SCW.MM.AR2.ReloadRotate" }
// 	{ event AE_CL_PLAYSOUND 10 "SCW.MM.AR2.MagOut" }
// 	{ event AE_CL_PLAYSOUND 39 "SCW.MM.AR2.MagIn" }
// 	{ event AE_CL_PLAYSOUND 40 "SCW.MM.AR2.ReloadPush" }
// 	{ event AE_CL_PLAYSOUND 11 "SCW.MM.Generic.Movement2" }
// 	{ event AE_CL_PLAYSOUND 25 "SCW.MM.Generic.Movement5" }
// 	{ event 3015 20 "muzzle" }
// 	{ event 3102 0 "" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Fire"
// 	fps 30
// }

$sequence "draw" {
	"c_scw_mm_ar2_anims/draw.smd"
	activity "ACT_VM_DRAW" 1
	{ event 5004 0 "SCW.MM.AR2.Draw" }
	{ event AE_CL_PLAYSOUND 13 "SCW.MM.AR2.FidgetPush" }
	fadein 0.2
	fadeout 0.2
	node "Ready"
	snap
	fps 30
}

// 'ACT_VM_DRAW_EMPTY' is Day of Defeat activity, not Half-Life 2.
// This doesn't work well, so I'll comment it.
// $sequence "draw_empty" {
// 	"c_scw_mm_ar2_anims/draw_empty.smd"
// 	activity "ACT_VM_DRAW_EMPTY" 1
// 	{ event 5004 0 "SCW.MM.AR2.Draw" }
// 	{ event AE_CL_PLAYSOUND 13 "SCW.MM.AR2.FidgetPush" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Ready"
// 	snap
// 	fps 30
// }

$sequence "holster" {
	"c_scw_mm_ar2_anims/holster.smd"
	activity "ACT_VM_HOLSTER" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	fps 45
}

$sequence "idletolow" {
	"c_scw_mm_ar2_anims/idletolow.smd"
	activity "ACT_VM_LOWERED_TO_IDLE" 1
	fadein 0.2
	fadeout 0.2
	transition "Ready" "Low"
	fps 30
}

$sequence "lowtoidle" {
	"c_scw_mm_ar2_anims/lowtoidle.smd"
	activity "ACT_VM_IDLE_TO_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	transition "Low" "Ready"
	fps 30
}

$sequence "lowidle" {
	"c_scw_mm_ar2_anims/lowidle.smd"
	activity "ACT_VM_IDLE_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	node "Low"
	fps 30
	loop
}

// It seems 'ACT_VM_WALK' isn't registered. Maybe MMod exclusive?
$sequence "walk" {
	"c_scw_mm_ar2_anims/walk.smd"
	activity "ACT_VM_WALK" 1
	{ event AE_CL_PLAYSOUND 1 "SCW.MM.Generic.Walk1" }
	{ event AE_CL_PLAYSOUND 13 "SCW.MM.Generic.Walk2" }
	fadein 0.4
	fadeout 0.4
	transition "Ready" "Motion"
	fps 30
	loop
}

// It seems 'ACT_VM_SPRINT' isn't registered. Maybe MMod exclusive?
$sequence "sprint" {
	"c_scw_mm_ar2_anims/sprint.smd"
	activity "ACT_VM_SPRINT" 1
	{ event AE_CL_PLAYSOUND 1 "SCW.MM.Generic.Sprint1" }
	{ event AE_CL_PLAYSOUND 16 "SCW.MM.Generic.Sprint2" }
	fadein 0.4
	fadeout 0.4
	transition "Ready" "Motion"
	fps 50
	loop
}

// It seems 'ACT_VM_INSPECT' isn't registered. Maybe MMod exclusive?
// $sequence "inspect1" {
// 	"c_scw_mm_ar2_anims/inspect1.smd"
// 	activity "ACT_VM_INSPECT" 1
// 	{ event AE_CL_PLAYSOUND 8 "SCW.MM.AR2.FidgetRotate" }
// 	{ event AE_CL_PLAYSOUND 60 "SCW.MM.AR2.FidgetPush" }
// 	{ event AE_CL_PLAYSOUND 1 "SCW.MM.Generic.Movement1" }
// 	{ event AE_CL_PLAYSOUND 55 "SCW.MM.Generic.Movement4" }
// 	fadein 0.2
// 	fadeout 0.2
// 	fps 30
// }

// It seems 'ACT_VM_INSPECT_ALT' isn't registered. Maybe MMod exclusive?
// $sequence "inspect2" {
// 	"c_scw_mm_ar2_anims/inspect2.smd"
// 	activity "ACT_VM_INSPECT_ALT" 1
// 	{ event AE_CL_PLAYSOUND 30 "SCW.MM.AR2.FidgetRotate" }
// 	{ event AE_CL_PLAYSOUND 37 "SCW.MM.AR2.FidgetPush" }
// 	{ event AE_CL_PLAYSOUND 1 "SCW.MM.Generic.Movement2" }
// 	{ event AE_CL_PLAYSOUND 40 "SCW.MM.Generic.Movement3" }
// 	fadein 0.2
// 	fadeout 0.2
// 	fps 30
// }
