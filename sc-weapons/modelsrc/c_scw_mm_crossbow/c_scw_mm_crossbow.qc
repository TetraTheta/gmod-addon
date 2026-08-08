$modelname "weapons/c_scw_mm_crossbow.mdl"

$bodygroup "studio"
{
	studio "c_scw_mm_crossbow_reference.smd"
}

$surfaceprop "default"

$contents "solid"

$illumposition -5.933 -22.845 -13.334

$cdmaterials "models/weapons/cw_scw_mm_crossbow/"

$texturegroup "skinfamilies"
{
	{ "v_crossbow_body"      }
	{ "v_crossbow_body_glow" }
}

$attachment "spark" "crossbow_model.Spark2" 44.5 -65 -35.4 rotate 0 0 0
$attachment "bolt_start" "crossbow_model.bolt" -6 0 0 rotate 0 -180 90
$attachment "bolt_end" "crossbow_model.bolt" 8 0 0 rotate 0 -180 90
$attachment "muzzle" "crossbow_model.weapon_base" 3 16.5 0 rotate 0 90 90
$attachment "bolt_c" "crossbow_model.weapon_base" 2.3 9 0 rotate 0 90 90

$cbox 0 0 0 0 0 0

$bbox 1.012 -23.001 -24.607 44.68 11.127 -2.065

$definebone "crossbow_model.weapon_base" "" -0.010307 -16.465977 3.217293 -89.999982 179.999964 0 0 0 0 0 0 0
$definebone "crossbow_model.bowr1" "crossbow_model.weapon_base" 1.602392 15.810356 -4.239069 83.30182 -89.99975 -89.999695 0 0 0 0 0 0
$definebone "crossbow_model.bowr2" "crossbow_model.bowr1" 2.106979 0.000008 0 0 -16.562946 0 0 0 0 0 0 0
$definebone "crossbow_model.bowr3" "crossbow_model.bowr2" 2.198853 0 0.000001 0.938104 -11.543038 0.300287 0 0 0 0 0 0
$definebone "crossbow_model.bowr4" "crossbow_model.bowr3" 2.200351 -0.000008 0.000008 0.081589 -6.996962 0.026642 0 0 0 0 0 0
$definebone "crossbow_model.bowr5" "crossbow_model.bowr4" 2.258553 -0.000013 -0.000005 -1.066275 -6.482638 -0.408003 0 0 0 0 0 0
$definebone "crossbow_model.bowr6" "crossbow_model.bowr5" 2.304474 -0.000002 0.000001 0.047899 -8.687162 -0.003609 0 0 0 0 0 0
$definebone "crossbow_model.bowr_wheel" "crossbow_model.bowr6" 2.754811 0.166965 -0.73188 -89.682645 -89.991499 146.965795 0 0 0 0 0 0
$definebone "crossbow_model.bowl1" "crossbow_model.weapon_base" 1.602386 15.817284 3.92803 -82.562357 -90.00044 -89.999873 0 0 0 0 0 0
$definebone "crossbow_model.bowl2" "crossbow_model.bowl1" 2.106978 -0.000011 0 -0.000057 14.490791 0.000172 0 0 0 0 0 0
$definebone "crossbow_model.bowl3" "crossbow_model.bowl2" 2.165398 0.000002 -0.000002 0.977924 10.036388 -2.445327 0 0 0 0 0 0
$definebone "crossbow_model.bowl4" "crossbow_model.bowl3" 2.110378 0.000002 -0.000002 -0.310257 9.668093 0.106462 0 0 0 0 0 0
$definebone "crossbow_model.bowl5" "crossbow_model.bowl4" 2.226635 -0.000013 0.000001 -1.330179 7.345075 1.668402 0 0 0 0 0 0
$definebone "crossbow_model.bowl6" "crossbow_model.bowl5" 2.30446 0.000006 -0.000004 -0.03919 7.104637 -0.002634 0 0 0 0 0 0
$definebone "crossbow_model.bowl_wheel" "crossbow_model.bowl6" 2.813987 0.009438 -0.732745 -89.682604 -90.018902 -146.111011 0 0 0 0 0 0
$definebone "crossbow_model.bolt" "crossbow_model.weapon_base" 2.439703 10.75108 -0.10632 0 -89.999982 0.000057 0 0 0 0 0 0
$definebone "crossbow_model.pull" "crossbow_model.weapon_base" 2.040268 -2.875322 -0.052909 0 89.999982 -0.000172 0 0 0 0 0 0
$definebone "crossbow_model.wire" "crossbow_model.weapon_base" -0.51802 2.382971 0.515877 -19.590571 -60.302729 -3.173957 0 0 0 0 0 0
$definebone "crossbow_model.Spark2" "crossbow_model.weapon_base" 2.266786 16.501297 -0.311092 0 -89.999982 0.000057 0 0 0 0 0 0
$definebone "l_wrist" "" -3.016016 -17.464577 -4.982038 -15.72615 -134.444665 75.902239 0 0 0 0 0 0
$definebone "l_thumb_low" "l_wrist" 2.473575 0.628721 -1.303334 21.954496 21.819552 133.136301 0 0 0 0 0 0
$definebone "l_thumb_mid" "l_thumb_low" 1.832617 0 -0.000004 -0.344314 -9.245784 -173.254988 0 0 0 0 0 0
$definebone "l_thumb_tip" "l_thumb_mid" 1.003336 0 0.000003 -1.05583 4.157121 166.359325 0 0 0 0 0 0
$definebone "l_index_low" "l_wrist" 4.823799 -0.430293 -1.419616 -1.150392 -9.544046 6.65737 0 0 0 0 0 0
$definebone "l_index_mid" "l_index_low" 2.18796 0 -0.000011 2.198439 63.902902 2.879266 0 0 0 0 0 0
$definebone "l_index_tip" "l_index_mid" 1.100958 0.000008 0.00001 -4.603311 28.129642 1.846173 0 0 0 0 0 0
$definebone "l_middle_low" "l_wrist" 4.987793 -0.588135 -0.4828 -2.985628 10.208734 13.783983 0 0 0 0 0 0
$definebone "l_middle_mid" "l_middle_low" 1.8901 -0.000006 0.000004 0.229815 72.153149 -4.11952 0 0 0 0 0 0
$definebone "l_middle_tip" "l_middle_mid" 1.310925 -0.000002 0.000001 4.392411 23.589443 1.309263 0 0 0 0 0 0
$definebone "l_ring_low" "l_wrist" 5.117876 -0.665211 0.445601 -10.587398 34.83738 5.119035 0 0 0 0 0 0
$definebone "l_ring_mid" "l_ring_low" 1.655293 0 0.000001 7.68927 59.849212 -2.266736 0 0 0 0 0 0
$definebone "l_ring_tip" "l_ring_mid" 0.869586 0.000004 0.000006 -1.82362 12.490308 3.304032 0 0 0 0 0 0
$definebone "l_pinky_low" "l_wrist" 5.15056 -0.592267 1.346776 -1.600962 69.845562 -21.488328 0 0 0 0 0 0
$definebone "l_pinky_mid" "l_pinky_low" 1.157244 0.000004 0.000011 2.245351 28.080491 1.995593 0 0 0 0 0 0
$definebone "l_pinky_tip" "l_pinky_mid" 1.019835 0.000004 0.000011 -2.925017 22.690899 -84.090926 0 0 0 0 0 0
$definebone "l_upperarm" "" 5.183345 2.588341 -4.658316 31.378835 -101.91927 -87.292352 0 0 0 0 0 0
$definebone "l_forearm" "l_upperarm" 12.695432 -0.000005 0.000001 15.221654 -62.714011 -4.860859 0 0 0 0 0 0
$definebone "r_wrist" "" -6.602579 -3.041941 -3.560534 0.764211 -85.518538 174.990826 0 0 0 0 0 0
$definebone "r_thumb_low" "r_wrist" 2.474129 -0.485417 -1.382847 21.279437 -29.985285 77.298535 0 0 0 0 0 0
$definebone "r_thumb_mid" "r_thumb_low" 1.832172 -0.000001 0.000001 1.244125 35.016215 -151.16031 0 0 0 0 0 0
$definebone "r_thumb_tip" "r_thumb_mid" 1.042032 0 0 -10.735977 -5.393427 -166.096759 0 0 0 0 0 0
$definebone "r_index_low" "r_wrist" 4.823236 0.677341 -1.337761 9.507949 -6.845802 11.168551 0 0 0 0 0 0
$definebone "r_index_mid" "r_index_low" 2.152369 -0.000003 0 -3.311344 -32.955683 3.11106 0 0 0 0 0 0
$definebone "r_index_tip" "r_index_mid" 1.056617 0.000002 0 -3.326473 -30.890111 12.834427 0 0 0 0 0 0
$definebone "r_middle_low" "r_wrist" 4.985044 0.893762 -0.374954 1.513869 -27.116829 3.020289 0 0 0 0 0 0
$definebone "r_middle_mid" "r_middle_low" 1.83018 0.00001 -0.000001 -0.181177 -83.868207 22.344496 0 0 0 0 0 0
$definebone "r_middle_tip" "r_middle_mid" 1.561353 0.000001 0 -2.87644 -64.964709 5.772669 0 0 0 0 0 0
$definebone "r_ring_low" "r_wrist" 5.116426 0.72272 0.545802 0.560003 -53.024541 14.513192 0 0 0 0 0 0
$definebone "r_ring_mid" "r_ring_low" 1.75273 -0.000005 0 1.412124 -54.336125 -11.5624 0 0 0 0 0 0
$definebone "r_ring_tip" "r_ring_mid" 0.869359 -0.000001 0 8.63786 -61.912844 2.07684 0 0 0 0 0 0
$definebone "r_pinky_low" "r_wrist" 5.118731 0.342195 1.41355 8.862223 -66.992797 -2.387578 0 0 0 0 0 0
$definebone "r_pinky_mid" "r_pinky_low" 1.176319 0.000005 0.000001 3.58151 -15.206013 -32.518128 0 0 0 0 0 0
$definebone "r_pinky_tip" "r_pinky_mid" 0.970203 0 0.000002 58.209126 -83.568772 123.573244 0 0 0 0 0 0
$definebone "r_upperarm" "" -7.009326 11 1.176544 60.968529 -138.442689 -169.710079 0 0 0 0 0 0
$definebone "r_forearm" "r_upperarm" 12.70635 -0.000002 -0.000004 16.119774 -109.860936 -18.188032 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "l_upperarm" 0 0 0 -0.000005 -0.000005 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "l_forearm" 1.200003 -0.000001 0 0 -0.000001 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "l_wrist" -0.000002 -0.3 -0.000002 -0.00001 -10.000001 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "l_thumb_low" 0 0 0 -0.000006 0.000001 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "l_thumb_mid" 0 0 0 0.000008 0.000005 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "l_thumb_tip" 0 0 -0.000001 -0.000011 20.000032 0.000013 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "l_index_low" -0.000002 0 -0.000001 -0.000014 0.000003 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "l_index_mid" 0 -0.000002 -0.000003 0.000003 0.000003 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "l_index_tip" 0 0.000002 0.000001 0.000002 -0.000003 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "l_middle_low" -0.000002 -0.000002 0 -0.00001 0.000003 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "l_middle_mid" 0 0.000002 -0.000001 0 0.000004 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "l_middle_tip" 0.000002 0.000002 0.000001 -0.000002 0.000012 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "l_ring_low" -0.000003 0 0.000006 0.000002 -0.000012 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "l_ring_mid" 0 0 0 0.000001 0.000012 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "l_ring_tip" 0 0.000001 0 -0.000007 -0.000002 -179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "l_pinky_low" 0.000001 0 0.000008 -0.000009 0.000002 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "l_pinky_mid" 0 0 0.000004 -0.000009 -0.000017 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "l_pinky_tip" 0 -0.000001 0 0.000007 -0.000009 -89.999968 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "r_upperarm" 0 0 0 0.000003 -0.000001 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "r_forearm" 1.200001 -0.000001 0 0.00001 0.000007 -0.000022 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "r_wrist" 0 0.3 0 0 10 -0.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "r_thumb_low" 0 0 0 0.000002 -0.000001 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "r_thumb_mid" 0 0 0 -0.000009 -0.000011 -179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "r_thumb_tip" 0 0 0 -0.000005 20.000003 0.000023 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "r_index_low" 0 0 0 0.000003 0.000007 0.00001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "r_index_mid" 0 -0.000001 0 0.000003 0.000022 0.000012 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "r_index_tip" 0 0 0 0.000015 0.00002 0.000018 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "r_middle_low" 0 0 0 0 0.000017 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "r_middle_mid" -0.000002 0 0 -0.000004 -0.000007 -0.00002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "r_middle_tip" 0.000001 0 0 -0.000025 -0.000034 0.000017 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "r_ring_low" 0 -0.000002 0 -0.000004 0.000003 0.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "r_ring_mid" -0.000001 0 0 0.000006 -0.000014 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "r_ring_tip" -0.000001 0 0 0.000001 0.000002 -0.000006 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "r_pinky_low" 0 0.000003 0 0.000002 0.000017 0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "r_pinky_mid" 0 0 0 0.000007 -0.000001 0.000011 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "r_pinky_tip" -0.000001 0 0 0.000014 0.000024 -90.000023 0 0 0 0 0 0

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

$sectionframes 30 120

$sequence "idle" {
	"c_scw_mm_crossbow_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	node "Ready"
	fps 30
	loop
}

// $sequence "idle_is" {
// 	"c_scw_mm_crossbow_anims/idle_is.smd"
// 	activity "ACT_VM_IDLE_SILENCED" 1
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Ready"
// 	fps 4
// 	loop
// }

// $sequence "idle_empty" {
// 	"c_scw_mm_crossbow_anims/idle_empty.smd"
// 	activity "ACT_VM_FIDGET" 1
// 	{ event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Ready"
// 	fps 30
// 	loop
// }

$sequence "draw" {
	"c_scw_mm_crossbow_anims/draw.smd"
	activity "ACT_VM_DRAW" 1
	{ event 5004 0 "SCW.MM.Crossbow.Draw" }
	{ event 3013 14 "" }
	{ event 3016 28 "" }
	// { event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
	fadein 0.2
	fadeout 0.2
	node "Ready"
	snap
	fps 45
}

// $sequence "draw_empty" {
// 	"c_scw_mm_crossbow_anims/draw_empty.smd"
// 	activity "ACT_CROSSBOW_DRAW_UNLOADED" 1
// 	{ event 5004 0 "SCW.MM.Crossbow.Draw" }
// 	{ event 3013 14 "" }
// 	{ event 3016 28 "" }
// 	// { event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Ready"
// 	snap
// 	fps 45
// }

$sequence "fire" {
	"c_scw_mm_crossbow_anims/fire.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	{ event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
	{ event AE_CL_CREATE_PARTICLE_EFFECT 1 "hl2mmod_weapon_crossbow_boltrelease follow_attachment bolt_c" }
	fadein 0.2
	fadeout 0.2
	node "Ready"
	snap
	fps 30
}

$sequence "reload" {
	"c_scw_mm_crossbow_anims/reload.smd"
	activity "ACT_VM_RELOAD" 1
	{ event 3005 122 "" }
	{ event 3013 127 "" }
	{ event 3016 135 "" }
	{ event 5004 40 "SCW.MM.Crossbow.DrawBack" }
	{ event 5004 8 "SCW.MM.Generic.Movement2" }
	{ event 5004 37 "SCW.MM.Generic.Movement5" }
	{ event 5004 84 "SCW.MM.Generic.Movement1" }
	{ event 5004 147 "SCW.MM.Generic.Movement4" }
	{ event 5004 123 "SCW.MM.Crossbow.BoltElectrify" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 124 "hl2mmod_weapon_crossbow_chargespark follow_attachment bolt_end" }
	// { event AE_CL_CREATE_PARTICLE_EFFECT 125 "hl2mmod_weapon_crossbow_boltidle follow_attachment bolt_c" }
	// { event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
	fadein 0.2
	fadeout 0.2
	node "Fire"
	// fps 65
	fps 80
}

// $sequence "reload_zoomed" {
// 	"c_scw_mm_crossbow_anims/reload_zoomed.smd"
// 	activity "ACT_VM_RELOAD_FINISH" 1
// 	{ event 3005 122 "" }
// 	{ event 3013 127 "" }
// 	{ event 3016 135 "" }
// 	{ event 5004 40 "SCW.MM.Crossbow.DrawBack" }
// 	{ event 5004 8 "SCW.MM.Generic.Movement2" }
// 	{ event 5004 37 "SCW.MM.Generic.Movement5" }
// 	{ event 5004 84 "SCW.MM.Generic.Movement1" }
// 	{ event 5004 147 "SCW.MM.Generic.Movement4" }
// 	{ event 5004 123 "SCW.MM.Crossbow.BoltElectrify" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 124 "hl2mmod_weapon_crossbow_chargespark follow_attachment bolt_end" }
// 	// { event AE_CL_CREATE_PARTICLE_EFFECT 125 "hl2mmod_weapon_crossbow_boltidle follow_attachment bolt_c" }
// 	// { event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Fire"
// 	fps 65
// }

$sequence "holster" {
	"c_scw_mm_crossbow_anims/holster.smd"
	activity "ACT_VM_HOLSTER" 1
	{ event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
	fadein 0.2
	fadeout 0.2
	node "Ready"
	fps 37
}

// $sequence "holster_empty" {
// 	"c_scw_mm_crossbow_anims/holster_empty.smd"
// 	activity "ACT_VM_HOLSTER_SPECIAL" 1
// 	// { event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
// 	fadein 0.2
// 	fadeout 0.2
// 	node "Ready"
// 	fps 37
// }

$sequence "idletolow" {
	"c_scw_mm_crossbow_anims/idletolow.smd"
	activity "ACT_VM_LOWERED_TO_IDLE" 1
	fadein 0.2
	fadeout 0.2
	transition "Ready" "Low"
	fps 30
}

$sequence "lowidle" {
	"c_scw_mm_crossbow_anims/lowidle.smd"
	activity "ACT_VM_IDLE_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	node "Low"
	fps 30
	loop
}

$sequence "lowtoidle" {
	"c_scw_mm_crossbow_anims/lowtoidle.smd"
	activity "ACT_VM_IDLE_TO_LOWERED" 1
	fadein 0.2
	fadeout 0.2
	transition "Low" "Ready"
	fps 30
}

$sequence "sprint" {
	"c_scw_mm_crossbow_anims/sprint.smd"
	activity "ACT_VM_SPRINT" 1
	{ event 5004 0 "SCW.MM.Generic.Sprint1" }
	{ event 5004 9 "SCW.MM.Generic.Sprint2" }
	fadein 0.5
	fadeout 0.35
	transition "Ready" "Motion"
	fps 31
	loop
}

$sequence "walk" {
	"c_scw_mm_crossbow_anims/walk.smd"
	activity "ACT_VM_WALK" 1
	{ event 5004 0 "SCW.MM.Generic.Walk1" }
	{ event 5004 10 "SCW.MM.Generic.Walk2" }
	fadein 0.5
	fadeout 0.35
	transition "Ready" "Motion"
	fps 24
	loop
}

// $sequence "inspect1" {
// 	"c_scw_mm_crossbow_anims/inspect1.smd"
// 	activity "ACT_VM_INSPECT" 1
// 	{ event 5004 22 "SCW.MM.Crossbow.String" }
// 	{ event 5004 3 "SCW.MM.Generic.Movement4" }
// 	{ event 5004 19 "SCW.MM.Generic.Movement6" }
// 	fadein 0.6
// 	fadeout 0.6
// 	fps 30
// }

// $sequence "inspect2" {
// 	"c_scw_mm_crossbow_anims/inspect2.smd"
// 	activity "ACT_VM_INSPECT_ALT" 1
// 	{ event 5004 16 "SCW.MM.Crossbow.Lens" }
// 	{ event 5004 0 "SCW.MM.Generic.Movement1" }
// 	{ event 5004 44 "SCW.MM.Generic.Movement5" }
// 	// { event AE_CL_STOP_PARTICLE_EFFECT 0 "hl2mmod_weapon_crossbow_boltidle instantly" }
// 	fadein 0.6
// 	fadeout 0.6
// 	fps 30
// }
