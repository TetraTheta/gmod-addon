$modelname "weapons/c_scw_mm_smg1.mdl"

$bodygroup "studio"
{
	studio "v_smg1_reference_chonk.smd"
}

$surfaceprop "default"

$contents "solid"

$illumposition -0.374 -11.364 -10.249

$cdmaterials "models/weapons/cw_scw_mm_smg1/"
$cdmaterials "models/weapons/cw_scw_mm_pistol/"

$attachment "muzzle" "smg" 17.15 -1.05 0 rotate 0 0 90
$attachment "shel" "smg" 1 -1.3 -0.5 rotate 80 -90 -90
$attachment "grenade" "smg" 17.1 -0.1 0 rotate 0 0 90

$cbox 0 0 0 0 0 0

$bbox -11.334 -13.906 -19.998 34.062 13.157 -0.5

$definebone "smg" "" 0.006087 -20.654232 7.62108 0 -89.999811 -90.000098 0 0 0 0 0 0
$definebone "smg_magbullet" "smg" -0.613388 4.263741 -0.032694 0.000229 0 0 0 0 0 0 0 0
$definebone "smg_bolt" "smg" -4.612858 -1.361039 0.258725 0.05741 -0.067437 0.000172 0 0 0 0 0 0
$definebone "smg_boltpull" "smg" -4.54924 -1.689358 -0.012529 0 0 0 0 0 0 0 0 0
$definebone "smg_boltrelease" "smg" 4.331499 0.360595 -0.709097 0.000172 3.209824 0.000859 0 0 0 0 0 0
$definebone "smg_trigger" "smg" 3.513922 0.962076 -0.004281 -0.000057 67.380007 0.000229 0 0 0 0 0 0
$definebone "smg_selectfire" "smg" 2.855053 0.477292 0.679213 -0.000229 165.964048 -0.000057 0 0 0 0 0 0
$definebone "smg_mag" "smg" 1.649902 5.87808 0.032496 0.000115 -89.999982 -0.000172 0 0 0 0 0 0
$definebone "smg_magbull2" "smg_mag" 6.587842 -0.691444 0.025964 -0.000057 89.999982 -0.000057 0 0 0 0 0 0
$definebone "smg_magbull1" "smg_magbull2" 0.000002 -0.241401 -0.05269 0.000057 0 0.000057 0 0 0 0 0 0
$definebone "smg_grip" "smg" 10.620066 1.884898 -0.004843 -0.000115 89.999982 -89.999982 0 0 0 0 0 0
$definebone "smg_stock" "smg" -9.087198 1.359573 -0.008167 0.000115 -89.999982 -0.000172 0 0 0 0 0 0
$definebone "l_wrist" "" 8.27366 -15.41854 -0.926869 0.417514 -90.64536 175.772336 0 0 0 0 0 0
$definebone "l_thumb_low" "l_wrist" 1.473659 0.639418 -1.295234 42.064792 38.432371 121.667362 0 0 0 0 0 0
$definebone "l_thumb_mid" "l_thumb_low" 1.832607 0.000002 -0.000008 2.721036 43.434051 178.192491 0 0 0 0 0 0
$definebone "l_thumb_tip" "l_thumb_mid" 1.003335 0.000005 0.000001 -0.824193 -9.61443 -174.182665 0 0 0 0 0 0
$definebone "l_index_low" "l_wrist" 3.823895 -0.419603 -1.41152 20.645299 -2.817172 13.45034 0 0 0 0 0 0
$definebone "l_index_mid" "l_index_low" 2.187956 0.00001 0 -6.804575 21.420315 -1.453778 0 0 0 0 0 0
$definebone "l_index_tip" "l_index_mid" 1.10096 0.000002 0 -4.875247 14.690072 3.264867 0 0 0 0 0 0
$definebone "l_middle_low" "l_wrist" 3.987863 -0.577452 -0.474712 4.546306 21.596672 12.496727 0 0 0 0 0 0
$definebone "l_middle_mid" "l_middle_low" 1.890109 -0.00001 -0.000001 -8.906228 24.700046 4.019388 0 0 0 0 0 0
$definebone "l_middle_tip" "l_middle_mid" 1.310925 0 0 4.391955 23.589359 1.310567 0 0 0 0 0 0
$definebone "l_ring_low" "l_wrist" 4.117986 -0.654534 0.453695 -10.081306 29.583991 6.061263 0 0 0 0 0 0
$definebone "l_ring_mid" "l_ring_low" 1.655294 0.000008 0 5.094466 25.61651 -6.19418 0 0 0 0 0 0
$definebone "l_ring_tip" "l_ring_mid" 0.869582 0.000004 0 -1.823764 12.49015 3.30437 0 0 0 0 0 0
$definebone "l_pinky_low" "l_wrist" 4.15063 -0.581594 1.354863 -13.382899 36.847665 -17.041597 0 0 0 0 0 0
$definebone "l_pinky_mid" "l_pinky_low" 1.157247 -0.00001 -0.000002 2.245143 28.080158 1.996263 0 0 0 0 0 0
$definebone "l_pinky_tip" "l_pinky_mid" 1.019835 -0.000006 0 -2.924943 22.690974 -84.091363 0 0 0 0 0 0
$definebone "l_upperarm" "" 8 11 1.176544 4.722146 -89.35569 -90.447687 0 0 0 0 0 0
$definebone "l_forearm" "l_upperarm" 12.695427 -0.00002 -0.000008 0.102502 -0.334607 4.450049 0 0 0 0 0 0
$definebone "r_wrist" "" -8.338264 -15.418537 -0.926868 0.417572 -89.354891 175.944963 0 0 0 0 0 0
$definebone "r_thumb_low" "r_wrist" 1.474215 -0.497926 -1.376118 46.798137 -31.821841 67.981556 0 0 0 0 0 0
$definebone "r_thumb_mid" "r_thumb_low" 1.832179 -0.00001 -0.000002 -7.471184 41.829291 -146.220089 0 0 0 0 0 0
$definebone "r_thumb_tip" "r_thumb_mid" 1.042025 -0.000004 -0.000009 -18.307525 0.076563 -169.265898 0 0 0 0 0 0
$definebone "r_index_low" "r_wrist" 3.82332 0.664865 -1.331676 20.740902 0.228495 14.011348 0 0 0 0 0 0
$definebone "r_index_mid" "r_index_low" 2.152367 -0.000001 0.000004 -13.265119 -24.688907 7.086326 0 0 0 0 0 0
$definebone "r_index_tip" "r_index_mid" 1.056622 -0.000011 0 -9.796114 -8.175275 12.921261 0 0 0 0 0 0
$definebone "r_middle_low" "r_wrist" 3.985134 0.881805 -0.368986 7.376718 -15.405135 8.319071 0 0 0 0 0 0
$definebone "r_middle_mid" "r_middle_low" 1.830183 0.000015 0 -13.227752 -47.159253 11.201028 0 0 0 0 0 0
$definebone "r_middle_tip" "r_middle_mid" 1.561352 0.000008 -0.000004 -1.596252 -15.763026 0.322568 0 0 0 0 0 0
$definebone "r_ring_low" "r_wrist" 4.116518 0.711272 0.551869 -5.171049 -35.602928 15.913217 0 0 0 0 0 0
$definebone "r_ring_mid" "r_ring_low" 1.752727 0.000006 0 -0.57021 -21.043787 2.263197 0 0 0 0 0 0
$definebone "r_ring_tip" "r_ring_mid" 0.869359 -0.000006 0 -3.773093 -12.054987 -2.094215 0 0 0 0 0 0
$definebone "r_pinky_low" "r_wrist" 4.118826 0.331223 1.419829 -6.565574 -37.015783 17.533138 0 0 0 0 0 0
$definebone "r_pinky_mid" "r_pinky_low" 1.176321 0.000006 0 6.840782 -9.64084 7.092522 0 0 0 0 0 0
$definebone "r_pinky_tip" "r_pinky_mid" 0.970199 -0.000002 -0.000004 -0.116704 -32.870343 97.431474 0 0 0 0 0 0
$definebone "r_upperarm" "" -7.009326 11 1.176544 4.714583 -92.822537 -88.35267 0 0 0 0 0 0
$definebone "r_forearm" "r_upperarm" 12.706336 -0.000035 -0.000009 0.102731 -0.333576 4.620506 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "l_upperarm" 0 0 -0.000003 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "l_forearm" 1.2 0 0.00001 0 0.000001 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "l_wrist" 0.00001 -0.3 0 0 -10.000001 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "l_thumb_low" 0 -0.000001 0 0.000009 0.000003 0.000023 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "l_thumb_mid" -0.000003 0 0.000001 0.000009 0.000025 179.999978 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "l_thumb_tip" 0.000006 0 0.000004 -0.000016 19.999976 -0.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "l_index_low" 0 0 0 -0.000012 0.000001 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "l_index_mid" -0.000008 -0.000006 0 -0.000006 -0.00001 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "l_index_tip" 0.000002 -0.000002 0 -0.000009 -0.000007 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "l_middle_low" 0.000014 -0.000004 0 -0.000011 0.000007 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "l_middle_mid" -0.000001 0 0 -0.000004 -0.000036 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "l_middle_tip" 0 0 0 0.000006 -0.000014 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "l_ring_low" 0.00001 0.000017 0 0.000009 -0.000055 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "l_ring_mid" 0 0.000004 0 0.000017 -0.000046 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "l_ring_tip" 0 0.000006 0 0.00001 -0.000041 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "l_pinky_low" 0.000001 0.000002 0 0.000013 -0.00002 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "l_pinky_mid" 0 0 0 0.00001 0.00001 -179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "l_pinky_tip" 0 0 0 -0.00005 0.000009 -90.000023 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "r_upperarm" 0 0 0 0 -0.000001 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "r_forearm" 1.2 0 0 0 -0.000001 0.00001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "r_wrist" 0.000009 0.299994 0 0 10.000017 0.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "r_thumb_low" -0.000001 -0.000001 -0.000004 -0.000024 -0.000006 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "r_thumb_mid" -0.00001 0 -0.000003 0.000055 0.000016 -179.999978 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "r_thumb_tip" 0 0 0 -0.000042 19.99997 0.000046 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "r_index_low" 0 -0.000003 0 -0.000002 0 -0.000023 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "r_index_mid" 0.000003 0 0 -0.000003 -0.000024 -0.000022 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "r_index_tip" -0.00001 -0.000006 0 0.000022 0.000005 -0.000038 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "r_middle_low" 0.000019 0.000002 0 -0.000009 -0.000015 -0.000006 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "r_middle_mid" 0.000001 0.000004 0 0.000001 -0.000056 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "r_middle_tip" 0 0 0 0.000006 -0.000053 -0.000006 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "r_ring_low" 0.000001 -0.000002 0 -0.000004 -0.000073 0.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "r_ring_mid" 0 0 0 -0.000001 -0.000032 0.000004 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "r_ring_tip" 0.000001 0.000008 0 0.000008 -0.000002 0.000007 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "r_pinky_low" -0.000003 0.000004 0 0.000005 -0.000015 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "r_pinky_mid" -0.000007 -0.000008 0 0.000017 -0.000034 -0.000022 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "r_pinky_tip" 0 0.000002 -0.000002 -0.000013 -0.000015 -90.000009 0 0 0 0 0 0

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

$sectionframes 30 181

$sequence "idle" {
	"c_scw_mm_smg1_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	fps 14
	loop
}

$sequence "fire1" {
	"c_scw_mm_smg1_anims/fire1.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_smg1 follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_misc_temp_shellexhaust_sidesmoke follow_attachment shel" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_smg1_smokesprite follow_attachment muzzle" }
	{ event 6001 1 "0" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "fire2" {
	"c_scw_mm_smg1_anims/fire2.smd"
	activity "ACT_VM_RECOIL1" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_smg1 follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_misc_temp_shellexhaust_sidesmoke follow_attachment shel" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_smg1_smokesprite follow_attachment muzzle" }
	{ event 6001 1 "0" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "fire3" {
	"c_scw_mm_smg1_anims/fire3.smd"
	activity "ACT_VM_RECOIL2" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_smg1 follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_misc_temp_shellexhaust_sidesmoke follow_attachment shel" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_smg1_smokesprite follow_attachment muzzle" }
	{ event 6001 1 "0" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "fire4" {
	"c_scw_mm_smg1_anims/fire4.smd"
	activity "ACT_VM_RECOIL3" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_smg1 follow_attachment muzzle" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_misc_temp_shellexhaust_sidesmoke follow_attachment shel" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_smg1_smokesprite follow_attachment muzzle" }
	{ event 6001 1 "0" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "fire_alt" {
	"c_scw_mm_smg1_anims/fire_alt.smd"
	activity "ACT_VM_SECONDARYATTACK" 1
	// { event AE_CL_CREATE_PARTICLE_EFFECT 0 "hl2mmod_muzzleflash_smg1_grenade follow_attachment grenade" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 2 "hl2mmod_muzzleflash_smg1_grenade_smokesprite follow_attachment " }
	{ event 5004 9 "SCW.MM.SMG1.GLBack" }
	{ event 5004 15 "SCW.MM.SMG1.GLForward" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	snap
	fps 30
}

$sequence "draw" {
	"c_scw_mm_smg1_anims/draw.smd"
	activity "ACT_VM_DRAW" 1
	{ event 5004 1 "SCW.MM.SMG1.Draw" }
	{ event 5004 1 "SCW.MM.Generic.Movement1" }
	fadein 0.2
	fadeout 0.2
	node "Ready"
	snap
	fps 30
}

$sequence "reload" {
	"c_scw_mm_smg1_anims/reload.smd"
	activity "ACT_VM_RELOAD" 1
	{ event 3015 7 "muzzle" }
	{ event 5004 10 "SCW.MM.SMG1.ClipOut" }
	{ event 5004 25 "SCW.MM.SMG1.ClipIn" }
	{ event 5004 39 "SCW.MM.SMG1.BoltRelease" }
	{ event 5004 1 "SCW.MM.Generic.Movement1" }
	{ event 5004 22 "SCW.MM.Generic.Movement5" }
	{ event 5004 33 "SCW.MM.Generic.Movement2" }
	{ event 5004 44 "SCW.MM.Generic.Movement4" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	fps 28
}

$sequence "idletolow" {
	"c_scw_mm_smg1_anims/idletolow.smd"
	activity "ACT_VM_LOWERED_TO_IDLE" 1
	fadein 0.2
	fadeout 0.2
	transition "Ready" "Low"
	fps 30
}

$sequence "lowtoidle" {
	"c_scw_mm_smg1_anims/lowtoidle.smd"
	activity "ACT_VM_IDLE_TO_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	transition "Low" "Ready"
	fps 30
}

$sequence "lowidle" {
	"c_scw_mm_smg1_anims/lowidle.smd"
	activity "ACT_VM_IDLE_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	node "Low"
	fps 30
	loop
}

$sequence "holster" {
	"c_scw_mm_smg1_anims/holster.smd"
	activity "ACT_VM_HOLSTER" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	fps 35
}

// It seems 'ACT_VM_WALK' isn't registered. Maybe MMod exclusive?
$sequence "walk" {
	"c_scw_mm_smg1_anims/walk.smd"
	activity "ACT_VM_WALK" 1
	{ event 5004 1 "SCW.MM.Generic.Walk1" }
	{ event 5004 17 "SCW.MM.Generic.Walk2" }
	fadein 0.5
	fadeout 0.35
	transition "Ready" "Motion"
	fps 30
	loop
}

// It seems 'ACT_VM_SPRINT' isn't registered. Maybe MMod exclusive?
$sequence "sprint" {
	"c_scw_mm_smg1_anims/sprint.smd"
	activity "ACT_VM_SPRINT" 1
	{ event 5004 1 "SCW.MM.Generic.Sprint1" }
	{ event 5004 18 "SCW.MM.Generic.Sprint2" }
	fadein 0.5
	fadeout 0.35
	transition "Ready" "Motion"
	fps 48
	loop
}

// It seems 'ACT_VM_INSPECT' isn't registered. Maybe MMod exclusive?
// $sequence "inspect1" {
// 	"c_scw_mm_smg1_anims/inspect1.smd"
// 	activity "ACT_VM_INSPECT" 1
// 	{ event 5004 17 "MMOD_Weapon_SMG1.GripFold" }
// 	{ event 5004 153 "MMOD_Weapon_SMG1.GripUnfold" }
// 	{ event 5004 1 "SCW.MM.Generic.Movement2" }
// 	{ event 5004 25 "SCW.MM.Generic.Movement1" }
// 	{ event 5004 85 "SCW.MM.Generic.Movement2" }
// 	{ event 5004 146 "SCW.MM.Generic.Movement5" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Ready"
// 	fps 30
// }

// It seems 'ACT_VM_INSPECT_ALT' isn't registered. Maybe MMod exclusive?
// $sequence "inspect2" {
// 	"c_scw_mm_smg1_anims/inspect2.smd"
// 	activity "ACT_VM_INSPECT_ALT" 1
// 	{ event 5004 23 "MMOD_Weapon_SMG1.BoltBack" }
// 	{ event 5004 30 "MMOD_Weapon_SMG1.BoltForward" }
// 	{ event 5004 66 "SCW.MM.SMG1.BoltRelease" }
// 	{ event 5004 1 "SCW.MM.Generic.Movement1" }
// 	{ event 5004 34 "SCW.MM.Generic.Movement5" }
// 	{ event 5004 70 "SCW.MM.Generic.Movement4" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Ready"
// 	fps 30
// }
