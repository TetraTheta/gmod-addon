$modelname "weapons/c_scw_mp5.mdl"

$bodygroup "gun"
{
	studio "wpn_t9_smg_standard_view_lod0.smd"
}
$bodygroup "clamped1"
{
	studio "body1_model0.smd"
}

$surfaceprop "default"

$contents "solid"

$illumposition -5.001 4.3 -33.5

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

$attachment "1" "tag_flash" -0.17 0 0.17 rotate 0 0 0
$attachment "2" "tag_brass" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -41.277 -17.98 -67 32.667 7.979 0

$definebone "tag_view" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_shoulder_le" "tag_torso" -1.043914 7.978557 -4.272915 43.377261 67.281516 -13.715466 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 10.733722 -0.000888 0.000756 -0.000802 -45.265668 0.000162 0 0 0 0 0 0
$definebone "j_elbow_bulge_le" "j_elbow_le" -0.000001 -0.000005 0 -0.000007 0.000104 -0.000185 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 9.805744 0.000528 -0.000746 -0.000002 0.00006 -0.000183 0 0 0 0 0 0
$definebone "j_indexbase_le" "j_wrist_le" 3.453074 -1.07509 0.07728 -0.000004 0.000176 0.000058 0 0 0 0 0 0
$definebone "j_index_le_1" "j_indexbase_le" 0.000002 -0.000006 0.000003 16.664407 4.680479 -92.315177 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.428391 -0.000034 0.000216 -0.000541 30.135228 -0.000849 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.978601 0.000168 0.000484 0.0012 29.741878 0.001223 0 0 0 0 0 0
$definebone "j_indexretract_le" "j_indexbase_le" 0.000002 -0.000006 0.000003 -0.000012 -0.000061 0.000001 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_wrist_le" 3.433184 0.059025 0.127654 31.79478 0.652604 -96.27653 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 1.789764 -0.000071 -0.000299 -0.000061 46.070107 -0.000563 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.052643 0.000046 0.000067 -0.000213 30.84188 0.000473 0 0 0 0 0 0
$definebone "j_pinkybase_le" "j_wrist_le" 0.621656 1.13537 -0.284691 6.927721 17.122644 -90.800385 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_pinkybase_le" 2.193859 0.000525 -0.000731 9.673081 24.151472 -4.294039 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.143068 -0.00001 -0.000273 -0.000766 44.138089 -0.001067 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.728797 -0.000147 -0.000156 0.000694 47.498969 0.001159 0 0 0 0 0 0
$definebone "j_ringbase_le" "j_wrist_le" 1.077488 0.63172 0.051816 5.303972 11.45101 -91.219642 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_ringbase_le" 2.077618 0.000401 -0.00058 4.144274 27.761768 -7.822679 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.649673 -0.000071 -0.000628 -0.00024 42.454793 -0.001173 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 0.86377 -0.00034 -0.000362 0.000405 37.692624 -0.000774 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.17874 -1.086333 -0.011374 44.424168 -28.327042 9.007513 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.292104 -0.000013 0.000021 0.00001 8.890973 -0.000079 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.162971 0.000051 0.000114 -0.000237 13.993332 0.000216 0 0 0 0 0 0
$definebone "j_wristtwist1_le" "j_elbow_le" 7.354307 0.000397 -0.000564 -0.000002 0.00006 -0.00013 0 0 0 0 0 0
$definebone "j_wristtwist2_le" "j_elbow_le" 6.128592 0.000326 -0.000468 -0.000002 0.00006 -0.000183 0 0 0 0 0 0
$definebone "j_wristtwist3_le" "j_elbow_le" 4.902874 0.000256 -0.000375 -0.000002 0.00006 -0.000183 0 0 0 0 0 0
$definebone "j_wristtwist4_le" "j_elbow_le" 3.677154 0.000196 -0.00028 -0.000002 0.00006 -0.000183 0 0 0 0 0 0
$definebone "j_wristtwist5_le" "j_elbow_le" 2.451434 0.000126 -0.000185 -0.000002 0.00006 -0.000183 0 0 0 0 0 0
$definebone "j_wristtwist6_le" "j_elbow_le" 1.225717 0.000063 -0.00009 -0.000007 0.000104 -0.000185 0 0 0 0 0 0
$definebone "j_wristtwist_le" "j_elbow_le" 8.580023 0.000462 -0.000662 -0.000002 0.00006 -0.00013 0 0 0 0 0 0
$definebone "j_wristcrease_le" "j_wristtwist_le" 0.000002 0.000004 0.000002 -0.000005 0.000055 -0.000073 0 0 0 0 0 0
$definebone "j_shoulder_ri" "tag_torso" -1.043914 -7.978557 -4.272915 -43.377186 112.718653 166.284534 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" -10.734419 0.00087 0.000965 -0.000914 -45.265272 -0.000171 0 0 0 0 0 0
$definebone "j_elbow_bulge_ri" "j_elbow_ri" -0.000002 -0.000012 -0.00001 -0.00001 -0.00007 -0.000105 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" -9.802574 -0.000484 -0.000551 -0.00001 0.000039 0.000138 0 0 0 0 0 0
$definebone "j_indexbase_ri" "j_wrist_ri" -3.45175 1.075108 -0.077471 -0.000013 -0.000248 0.000031 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_indexbase_ri" 0.000011 -0.000005 0.000005 16.664408 4.68076 -92.315163 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" -1.428892 0.000032 0.000169 -0.000183 30.135112 -0.001025 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" -0.97928 -0.000164 0.000485 0.000867 29.742134 0.00127 0 0 0 0 0 0
$definebone "j_indexretract_ri" "j_indexbase_ri" 0.000011 -0.000005 0.000005 -0.000019 0.000094 0.000033 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_wrist_ri" -3.432072 -0.059013 -0.128088 31.794759 0.652327 -96.276489 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" -1.789165 0.000053 -0.000272 -0.000108 46.070196 -0.000611 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" -1.052681 -0.000046 0.00006 -0.000248 30.841873 0.000553 0 0 0 0 0 0
$definebone "j_pinkybase_ri" "j_wrist_ri" -0.621656 -1.135382 0.284288 -6.928806 -162.875 17.200216 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_pinkybase_ri" 2.194126 -0.000123 -0.000212 25.759041 176.992085 -80.644057 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" -1.141918 0.000032 -0.00053 0.001851 44.13743 0.001243 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" -0.728413 0.00028 -0.000319 -0.000044 47.499215 -0.000444 0 0 0 0 0 0
$definebone "j_ringbase_ri" "j_wrist_ri" -1.077244 -0.631712 -0.052075 -5.305506 -168.548769 13.947951 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_ringbase_ri" 2.077568 -0.000457 -0.000648 27.96385 -177.93808 -85.612924 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" -1.649458 0.000034 -0.000234 -0.000224 42.454782 0 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" -0.863912 0.00012 -0.000154 0.000965 37.692857 0.000065 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" -0.178474 1.08633 0.011595 44.424199 -28.327347 9.007584 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" -2.292119 0.000017 -0.00001 0.000017 8.890898 -0.00008 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" -1.163233 -0.00005 0.000118 -0.00021 13.993162 0.000045 0 0 0 0 0 0
$definebone "j_wristtwist1_ri" "j_elbow_ri" -7.351931 -0.00036 -0.000409 -0.00001 -0.000138 0.000195 0 0 0 0 0 0
$definebone "j_wristtwist2_ri" "j_elbow_ri" -6.126616 -0.000299 -0.000346 -0.00001 -0.000138 0.000195 0 0 0 0 0 0
$definebone "j_wristtwist3_ri" "j_elbow_ri" -4.901289 -0.000237 -0.000273 -0.00001 -0.000138 0.000195 0 0 0 0 0 0
$definebone "j_wristtwist4_ri" "j_elbow_ri" -3.675964 -0.000177 -0.000206 -0.00001 -0.000138 0.000195 0 0 0 0 0 0
$definebone "j_wristtwist5_ri" "j_elbow_ri" -2.450644 -0.000122 -0.000138 -0.00001 -0.000138 -0.000095 0 0 0 0 0 0
$definebone "j_wristtwist6_ri" "j_elbow_ri" -1.225322 -0.000058 -0.000072 -0.000008 -0.000038 -0.000094 0 0 0 0 0 0
$definebone "j_wristtwist_ri" "j_elbow_ri" -8.577255 -0.000423 -0.000477 -0.000009 -0.000362 0.000186 0 0 0 0 0 0
$definebone "j_wristcrease2_ri" "j_wristtwist_ri" 0.000002 0 0 -0.000005 0.00014 -0.00005 0 0 0 0 0 0
$definebone "T7:Joints" "" 0 0 0 0 -89.999982 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "j_shoulder_le" 0 1 0 0.000003 -0.000012 -0.000013 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "j_elbow_le" -0.000001 -0.000002 0.000001 -0.000003 0.000053 -0.000019 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "j_wrist_le" 0.000006 0.000001 0.000001 -5.000004 10.000032 69.999993 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "j_thumb_le_1" 0 -0.000004 -0.000001 0.000027 0.000032 0.000027 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "j_thumb_le_2" 0.000002 -0.000006 0 0.000007 0.000028 0.000041 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "j_thumb_le_3" -0.000008 0.000011 0 -0.000014 0.000036 0.000047 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "j_index_le_1" 0.000008 0.000003 0 -0.000036 -0.000042 179.99995 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "j_index_le_2" 0.000004 0 -0.000002 -0.000009 -0.000046 179.999923 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "j_index_le_3" -0.000004 -0.000006 -0.000008 -0.000001 -0.000007 179.99995 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "j_mid_le_1" 0.000004 -0.000004 0.000002 -0.000038 -0.000019 179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "j_mid_le_2" -0.000002 0.000002 0.000003 -0.000011 -0.000019 179.999937 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "j_mid_le_3" -0.000004 0.000006 0 0.000021 0.000012 179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "j_ring_le_1" 0.000004 -0.24999 -0.249994 -0.000026 -0.000034 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "j_ring_le_2" -0.249998 -0.249996 -0.249999 -0.000005 -0.000008 179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "j_ring_le_3" -0.250002 -0.250008 -0.250007 0.000009 0.000017 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "j_pinky_le_1" -0.25 -0.299995 -0.249994 -0.000048 -0.000023 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "j_pinky_le_2" -0.250004 -0.299994 -0.249993 -0.000008 -0.000013 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "j_pinky_le_3" -0.250011 -0.299995 -0.249993 0.000015 0.000025 179.99995 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "j_shoulder_ri" 0 0 0 -0.000007 -180.000005 0.00001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "j_elbow_ri" 0.000001 0.000001 0 0.000006 -180.000005 -0.000028 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "j_wrist_ri" 0.000002 -0.000004 0 5.000019 -174.999979 -90.000043 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "j_thumb_ri_1" 0 0.000006 -0.000001 -0.000014 -180.000005 -0.00003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "j_thumb_ri_2" -0.000002 0.000011 0 -0.000024 -180.000005 -0.000029 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "j_thumb_ri_3" 0.000002 0.000006 0 -0.000019 -180.000005 -0.000032 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "j_index_ri_1" -0.000004 -0.000002 0.000006 0.000032 180.000005 -179.999978 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "j_index_ri_2" 0 -0.000008 -0.000007 0.000012 180.000005 -179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "j_index_ri_3" 0.000001 0.000008 0.000002 -0.000018 180.000005 -179.99995 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "j_mid_ri_1" -0.000006 0.000002 0.000004 0.000022 180.000005 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "j_mid_ri_2" 0 0.000002 -0.000002 -0.000007 -179.99995 -179.99995 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "j_mid_ri_3" 0.000006 0.000004 0.000002 -0.000028 -180.000005 -179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "j_ring_ri_1" 0.249996 0.499998 0.250005 0.000027 -180.000005 -179.999937 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "j_ring_ri_2" 0.25 0.500004 0.24999 -0.000002 180.000005 -180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "j_ring_ri_3" 0.249994 0.499996 0.25 -0.000042 180.000005 -179.99995 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "j_pinky_ri_1" -0.00001 0.300003 0.25 0.000003 -180.000005 -179.999964 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "j_pinky_ri_2" -0.000001 0.299995 0.25 -0.000028 -180.000005 180.000005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "j_pinky_ri_3" 0 0.300003 0.250007 -0.000015 180.000005 -180.000005 0 0 0 0 0 0
$definebone "tag_weapon_right" "tag_torso" 13.873877 -17.980217 -17.371613 0 0 0 0 0 0 0 0 0
$definebone "tag_weapon" "tag_weapon_right" 0 0 0 0 89.999982 0 0 0 0 0 0 0
$definebone "tag_bolt_animate" "tag_weapon" 8.928637 0 4.63865 0 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_weapon" 8.055407 -0.38334 4.071478 0 -89.999982 0 0 0 0 0 0 0
$definebone "tag_mag_release_animate" "tag_weapon" 4.149941 0 1.472458 0 0 0 0 0 0 0 0 0
$definebone "tag_clip" "tag_weapon" 5.875979 0 2.557417 0 0 0 0 0 0 0 0 0
$definebone "j_charginghandle" "tag_weapon" 3.45501 0.000004 2.018 0 0.000401 0.000573 0 0 0 0 0 0
$definebone "j_loose_round" "tag_weapon" -2.088972 -3.614023 0.605963 0 0.000401 0.000573 0 0 0 0 0 0
$definebone "j_mag1" "tag_weapon" -1.971998 -0.00001 -0.796001 -11.730222 0.000344 0.00063 0 0 0 0 0 0
$definebone "j_mag2" "tag_weapon" -1.971998 -0.00001 -0.796001 -11.730222 0.000344 0.00063 0 0 0 0 0 0
$definebone "j_slide" "tag_weapon" -5.858999 0.072452 2.682749 0 0 0 0 0 0 0 0 0
$definebone "tag_flash" "tag_weapon" -1.415401 0 2.94315 0 0 0 0 0 0 0 0 0
$definebone "tag_charging_handle_animate" "tag_weapon" 10.230598 0 4.378193 0 0 0 0 0 0 0 0 0

$bonemerge "tag_view"
$bonemerge "tag_ads"
$bonemerge "tag_torso"
$bonemerge "j_shoulder_le"
$bonemerge "j_elbow_le"
$bonemerge "j_wrist_le"
$bonemerge "j_indexbase_le"
$bonemerge "j_index_le_1"
$bonemerge "j_index_le_2"
$bonemerge "j_index_le_3"
$bonemerge "j_mid_le_1"
$bonemerge "j_mid_le_2"
$bonemerge "j_mid_le_3"
$bonemerge "j_pinkybase_le"
$bonemerge "j_pinky_le_1"
$bonemerge "j_pinky_le_2"
$bonemerge "j_pinky_le_3"
$bonemerge "j_ringbase_le"
$bonemerge "j_ring_le_1"
$bonemerge "j_ring_le_2"
$bonemerge "j_ring_le_3"
$bonemerge "j_thumb_le_1"
$bonemerge "j_thumb_le_2"
$bonemerge "j_thumb_le_3"
$bonemerge "j_wristtwist1_le"
$bonemerge "j_wristtwist2_le"
$bonemerge "j_wristtwist3_le"
$bonemerge "j_wristtwist4_le"
$bonemerge "j_wristtwist5_le"
$bonemerge "j_wristtwist_le"
$bonemerge "j_shoulder_ri"
$bonemerge "j_elbow_ri"
$bonemerge "j_wrist_ri"
$bonemerge "j_indexbase_ri"
$bonemerge "j_index_ri_1"
$bonemerge "j_index_ri_2"
$bonemerge "j_index_ri_3"
$bonemerge "j_mid_ri_1"
$bonemerge "j_mid_ri_2"
$bonemerge "j_mid_ri_3"
$bonemerge "j_pinkybase_ri"
$bonemerge "j_pinky_ri_1"
$bonemerge "j_pinky_ri_2"
$bonemerge "j_pinky_ri_3"
$bonemerge "j_ringbase_ri"
$bonemerge "j_ring_ri_1"
$bonemerge "j_ring_ri_2"
$bonemerge "j_ring_ri_3"
$bonemerge "j_thumb_ri_1"
$bonemerge "j_thumb_ri_2"
$bonemerge "j_thumb_ri_3"
$bonemerge "j_wristtwist1_ri"
$bonemerge "j_wristtwist2_ri"
$bonemerge "j_wristtwist3_ri"
$bonemerge "j_wristtwist4_ri"
$bonemerge "j_wristtwist5_ri"
$bonemerge "j_wristtwist_ri"
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

$sectionframes 30 66

$sequence "idle" {
	"c_scw_mp5_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "idle_inspect" {
	"c_scw_mp5_anims/idle_inspect.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "pullout" {
	"c_scw_mp5_anims/pullout.smd"
	activity "ACT_VM_DRAW" 1
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "pullout_first" {
	"c_scw_mp5_anims/pullout_first.smd"
	activity "ACT_VM_DRAW_DEPLOYED" 1
	{ event 5004 24 "SCW.MP5.FirstRaise" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "putaway" {
	"c_scw_mp5_anims/putaway.smd"
	activity "ACT_VM_HOLSTER" 1
	fadein 0.2
	fadeout 0.2
	fps 100
}

$sequence "fire" {
	"c_scw_mp5_anims/fire.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "reload" {
	"c_scw_mp5_anims/reload.smd"
	activity "ACT_VM_RELOAD" 1
	{ event 5004 14 "SCW.MP5.BoltGrab" }
	{ event 5004 17 "SCW.MP5.BoltBack" }
	{ event 5004 46 "SCW.MP5.MagOut" }
	{ event 5004 115 "SCW.MP5.MagIn" }
	{ event 5004 131 "SCW.MP5.BoltRelease" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "reload_empty" {
	"c_scw_mp5_anims/reload_empty.smd"
	activity "ACT_VM_RELOAD_EMPTY" 1
	{ event 5004 15 "SCW.MP5.BoltGrab" }
	{ event 5004 18 "SCW.MP5.BoltBack" }
	{ event 5004 63 "SCW.MP5.MagOut" }
	{ event 5004 137 "SCW.MP5.MagIn" }
	{ event 5004 170 "SCW.MP5.BoltRelease" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "base_sprint_in" {
	"c_scw_mp5_anims/base_sprint_in.smd"
	activity "ACT_VM_SPRINT_IN" 1
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "base_sprint_loop" {
	"c_scw_mp5_anims/base_sprint_loop.smd"
	activity "ACT_VM_SPRINT_LOOP" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "base_sprint_out" {
	"c_scw_mp5_anims/base_sprint_out.smd"
	activity "ACT_VM_SPRINT_OUT" 1
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "inspect" {
	"c_scw_mp5_anims/inspect.smd"
	activity "ACT_VM_FIDGET" 1
	{ event 5004 84 "SCW.MP5.MagOut" }
	{ event 5004 127 "SCW.MP5.MagIn" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "inspect_in" {
	"c_scw_mp5_anims/inspect_in.smd"
	activity "ACT_VM_FIDGET" 1
	{ event 5004 84 "SCW.MP5.MagOut" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}

$sequence "inspect_out" {
	"c_scw_mp5_anims/inspect_out.smd"
	activity "ACT_VM_FIDGET" 1
	{ event 5004 30 "SCW.MP5.MagIn" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 100
}
