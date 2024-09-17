// TODO: Fix c_hand
$modelname "weapons/c_scw_scar20.mdl"

$bodygroup "studio"
{
	studio "c_scw_scar20_model.smd"
}
//$bodygroup "arms"
//{
//	studio "ct_arms.smd"
//}

$surfaceprop "default"

$contents "solid"

$illumposition -1.711 -19.261 -9.464

$cdmaterials "models/weapons/c_scw_scar20/"
$cdmaterials "models/weapons/csgo_scope/"
// $cdmaterials "models/weapons/v_models/arms/"

// This list shows the VMT file names used in the SMD files.
// "snip_scar20.vmt"
// "scope_scar20.vmt"
// "ct_base_glove.vmt"
// "ct_arms.vmt"

$attachment "muzzle" "v_weapon.flash" 0 0 0 rotate 0 0 0
$attachment "eject" "v_weapon.shelleject" 0 0 0 rotate 0 0 0

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -1.954 -8.241 -19.84 45.698 9.006 4.741

// Hitbox info. Used for damage-based collision.
// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "v_weapon.Bip01_R_Hand" -3.720628 -2.539234 -3.040114 13.980813 4.326262 11.985556
// $hbox 0 "v_weapon.SCAR_Parent" -1.299779 -1.542975 -14.742226 1.327495 9.680222 29.309374
// $hbox 0 "v_weapon.Bip01_L_Hand" -3.822108 -2.728088 -2.616061 5.065324 1.490319 2.369468
// $hbox 0 "v_weapon.Bip01_L_Finger0" -2.191889 -0.901597 -1.626706 2.55458 1.697949 1.189886
// $hbox 0 "v_weapon.Bip01_L_Finger01" -0.512 -0.770585 -0.900896 1.898944 0.853515 0.929223
// $hbox 0 "v_weapon.Bip01_L_Finger02" -0.52566 -0.706398 -0.673963 1.469935 0.523173 0.587628
// $hbox 0 "v_weapon.Bip01_L_Finger1" -0.499126 -1.088637 -0.930672 2.000547 0.763181 0.517087
// $hbox 0 "v_weapon.Bip01_L_Finger11" -0.492417 -0.650858 -0.703833 1.664691 0.630153 0.517087
// $hbox 0 "v_weapon.Bip01_L_Finger12" -0.55486 -0.493367 -0.579494 1.392814 0.830815 0.516374
// $hbox 0 "v_weapon.Bip01_L_Finger2" -0.222498 -1.094398 -0.862185 2.403692 0.832788 0.585638
// $hbox 0 "v_weapon.Bip01_L_Finger21" -0.543001 -0.675834 -0.644399 1.523032 0.756809 0.49355
// $hbox 0 "v_weapon.Bip01_L_Finger22" -0.466963 -0.508301 -0.613819 1.200425 0.693183 0.516543
// $hbox 0 "v_weapon.Bip01_L_Finger3" -0.174685 -0.966016 -0.702556 2.09 0.822281 1.108763
// $hbox 0 "v_weapon.Bip01_L_Finger31" -0.802642 -0.657025 -0.517599 1.420446 0.569078 0.571436
// $hbox 0 "v_weapon.Bip01_L_Finger32" -0.371702 -0.497873 -0.522357 1.42596 0.574599 0.511446
// $hbox 0 "v_weapon.Bip01_L_Finger4" -0.488588 -0.731877 -0.421349 1.874877 0.868557 0.853094
// $hbox 0 "v_weapon.Bip01_L_Finger41" -0.50812 -0.586978 -0.40667 1.221548 0.639242 0.689625
// $hbox 0 "v_weapon.Bip01_L_ForeTwist" -10.581546 -3.366006 -2.74667 12.346317 2.929265 3.16102
// $hbox 0 "v_weapon.Bip01_R_Finger0" -2.305665 -0.963416 -2.2623 2.315081 1.977179 1.9011
// $hbox 0 "v_weapon.Bip01_R_Finger01" -0.725313 -0.872398 -1.538748 1.900493 0.615758 0.94364
// $hbox 0 "v_weapon.Bip01_R_Finger02" -0.467052 -0.69404 -0.588704 1.47278 0.529338 0.672528
// $hbox 0 "v_weapon.Bip01_R_Finger1" -0.555542 -1.041459 -0.54505 2.047197 0.74869 0.943993
// $hbox 0 "v_weapon.Bip01_R_Finger11" -0.711369 -0.607444 -0.517203 1.664019 0.693987 0.713997
// $hbox 0 "v_weapon.Bip01_R_Finger12" -0.541101 -0.493999 -0.516374 1.39284 0.835207 0.577743
// $hbox 0 "v_weapon.Bip01_R_Finger2" -0.854934 -0.993318 -0.568245 2.42604 0.758676 0.909258
// $hbox 0 "v_weapon.Bip01_R_Finger21" -0.724669 -0.616556 -0.509771 1.561382 0.607685 0.646867
// $hbox 0 "v_weapon.Bip01_R_Finger22" -0.376222 -0.506418 -0.516543 1.200452 0.716615 0.616881
// $hbox 0 "v_weapon.Bip01_R_Finger3" -0.867257 -0.906769 -1.004575 2.127322 0.623948 0.623177
// $hbox 0 "v_weapon.Bip01_R_Finger31" -0.869882 -0.622595 -0.580213 1.437366 0.569103 0.517605
// $hbox 0 "v_weapon.Bip01_R_Finger32" -0.377508 -0.499375 -0.510801 1.425987 0.578987 0.522123
// $hbox 0 "v_weapon.Bip01_R_Finger4" -0.599456 -0.713129 -0.846794 1.842504 0.576898 0.595726
// $hbox 0 "v_weapon.Bip01_R_Finger41" -0.620699 -0.576799 -0.69567 1.209924 0.632117 0.40256
// $hbox 0 "v_weapon.Bip01_R_ForeTwist" -10.581516 -3.365962 -3.161015 12.161396 2.929307 2.746667

$definebone "v_weapon" "" 0 0 0 0 0 89.999982 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Forearm" "" -6.240802 4.326526 -12.220002 -35.225789 -73.720704 -118.956583 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Hand" "v_weapon.Bip01_R_Forearm" 10.295582 -0.000001 0 5.472148 32.455368 110.869912 0 0 0 0 0 0
$definebone "v_weapon.SCAR_Parent" "v_weapon.Bip01_R_Hand" 13.980813 4.326262 11.985556 -2.488299 93.897186 97.919231 0 0 0 0 0 0
$definebone "v_weapon.SCAR_Bolt" "v_weapon.SCAR_Parent" 0 5.677064 8.070999 0.000001 0.000001 -89.999982 0 0 0 0 0 0
$definebone "v_weapon.flash" "v_weapon.SCAR_Parent" 0.029222 4.525314 27.60607 -89.999982 -89.999982 0 0 0 0 0 0 0
$definebone "v_weapon.shelleject" "v_weapon.SCAR_Parent" -0.442677 4.649899 3.998964 -0.000001 -179.999964 -0.000001 0 0 0 0 0 0
$definebone "v_weapon.stattrack" "v_weapon.SCAR_Parent" 0.670862 4.287477 -1.530492 0.000001 0.000001 -89.999982 0 0 0 0 0 0
$definebone "v_weapon.uid" "v_weapon.SCAR_Parent" 0.689322 5.004891 -0.949094 0.000001 0.000001 -89.999982 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Forearm" "" 3.392379 -8.645586 -7.338794 -23.368027 -122.501751 -84.609938 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Hand" "v_weapon.Bip01_L_Forearm" 10.29558 0 0.000002 -13.353471 21.59707 -150.192172 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger0" "v_weapon.Bip01_L_Hand" 1.149519 0.416497 -1.414117 21.852842 17.469653 132.445783 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger01" "v_weapon.Bip01_L_Finger0" 1.26388 0.000002 0.000001 -6.87154 13.791723 -46.867494 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger02" "v_weapon.Bip01_L_Finger01" 1.18895 0 0 0.114364 14.40227 -0.564652 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger1" "v_weapon.Bip01_L_Hand" 3.773754 0.133215 -0.970575 -13.985845 -3.626136 5.558491 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger11" "v_weapon.Bip01_L_Finger1" 1.433455 0 0 0 11.623136 -0.000003 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger12" "v_weapon.Bip01_L_Finger11" 1.019167 0 -0.000001 0.000002 41.210049 -0.000003 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger2" "v_weapon.Bip01_L_Hand" 3.799515 0.014953 -0.039958 -12.335497 17.720381 -2.537976 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger21" "v_weapon.Bip01_L_Finger2" 1.774878 -0.000002 0 0.563961 34.753331 -0.924183 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger22" "v_weapon.Bip01_L_Finger21" 1.008844 -0.000006 0.000001 0.525288 32.383177 -0.94664 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger3" "v_weapon.Bip01_L_Hand" 3.632763 0.059048 0.757492 -6.842723 25.077157 -13.663556 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger31" "v_weapon.Bip01_L_Finger3" 1.500136 0.000001 0.000001 1.877754 41.612439 -3.914907 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger32" "v_weapon.Bip01_L_Finger31" 0.905665 0.000004 0 1.804015 40.538371 -3.949453 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger4" "v_weapon.Bip01_L_Hand" 3.323332 0.233746 1.479075 7.198642 40.280996 -15.063002 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger41" "v_weapon.Bip01_L_Finger4" 0.963099 -0.000004 -0.000001 0.506494 30.977363 -5.497072 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Finger42" "v_weapon.Bip01_L_Finger41" 0.682894 -0.000002 0 0.506553 30.978402 -5.49707 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_ForeTwist" "" 3.392379 -8.645586 -7.338794 -23.368027 -122.50182 -138.601463 0 0 0 0 0 0
$definebone "v_weapon.SCAR_Trigger" "v_weapon.SCAR_Parent" 0 2.726756 0.722448 0.000001 0.000001 -89.999982 0 0 0 0 0 0
$definebone "v_weapon.SCAR_Clip" "v_weapon.SCAR_Parent" 0 3.084624 4.107859 0.000001 0.000001 -89.999982 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger0" "v_weapon.Bip01_R_Hand" 1.149522 0.416497 1.414115 -11.599356 45.391777 -101.413413 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger01" "v_weapon.Bip01_R_Finger0" 1.263878 0 0 10.86236 31.816285 -1.964215 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger02" "v_weapon.Bip01_R_Finger01" 1.188944 0.000001 0 -0.000058 16.914393 -0.000003 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger1" "v_weapon.Bip01_R_Hand" 3.773755 0.133215 0.970572 -1.459207 -6.952613 -0.024178 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger11" "v_weapon.Bip01_R_Finger1" 1.433458 0 0 -0.562071 48.56774 0.831593 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger12" "v_weapon.Bip01_R_Finger11" 1.019161 0.000001 0 -0.506324 47.88913 0.82953 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger2" "v_weapon.Bip01_R_Hand" 3.799516 0.014953 0.039958 9.828857 63.222396 16.023624 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger21" "v_weapon.Bip01_R_Finger2" 1.774881 -0.000001 0 -2.296529 79.017885 0.890086 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger22" "v_weapon.Bip01_R_Finger21" 1.008848 0 0 -1.529395 48.580004 1.930751 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger3" "v_weapon.Bip01_R_Hand" 3.632766 0.059047 -0.757494 3.758946 79.46753 21.166893 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger31" "v_weapon.Bip01_R_Finger3" 1.500138 0.000001 0 -3.188049 64.471214 3.503519 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger32" "v_weapon.Bip01_R_Finger31" 0.905663 0 0 -1.326277 38.449761 4.546421 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger4" "v_weapon.Bip01_R_Hand" 3.323332 0.233745 -1.479077 -1.044675 81.405213 25.961578 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger41" "v_weapon.Bip01_R_Finger4" 0.963099 0 0 -0.354142 37.605584 3.224773 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Finger42" "v_weapon.Bip01_R_Finger41" 0.682894 0 0 -1.323527 55.400207 2.962135 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_ForeTwist" "" -6.240802 4.326526 -12.220002 -35.225789 -73.720704 -96.709031 0 0 0 0 0 0
$definebone "Bip01" "v_weapon" 0 0 0 -89.999982 -89.999982 0 0 0 0 0 0 0
$definebone "v_weapon.Bip01_Pelvis" "Bip01" 0 0 0 -89.999982 -89.999927 0 0 0 0 0 0 0
$definebone "v_weapon.Bip01_Spine" "v_weapon.Bip01_Pelvis" 3.562428 -0.816635 0.000007 -0.000057 0.045607 -0.000229 0 0 0 0 0 0
$definebone "v_weapon.Bip01_Spine1" "v_weapon.Bip01_Spine" 4.003749 -0.003188 0 0 0 0 0 0 0 0 0 0
$definebone "v_weapon.Bip01_Spine2" "v_weapon.Bip01_Spine1" 4.003752 -0.003188 0 0 0 0 0 0 0 0 0 0
$definebone "v_weapon.Bip01_Spine3" "v_weapon.Bip01_Spine2" 4.003755 -0.003188 0 0 0 0 0 0 0 0 0 0
$definebone "v_weapon.Bip01_Neck" "v_weapon.Bip01_Spine3" 5.028769 -0.763714 -0.000001 -0.000057 15.961344 0 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_Clavicle" "v_weapon.Bip01_Neck" -0.99964 0.234795 1.2233 -69.622919 163.993006 0.000057 0 0 0 0 0 0
$definebone "v_weapon.Bip01_L_UpperArm" "v_weapon.Bip01_L_Clavicle" 5.773739 0 0.000002 22.643457 0.384684 0.597538 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_Clavicle" "v_weapon.Bip01_Neck" -0.999638 0.234802 -1.2233 69.622796 163.992323 -0.000745 0 0 0 0 0 0
$definebone "v_weapon.Bip01_R_UpperArm" "v_weapon.Bip01_R_Clavicle" 5.773737 0 0.000002 -22.643409 0.384683 -0.597539 0 0 0 0 0 0

$bonemerge "v_weapon"
$bonemerge "v_weapon.Bip01_R_Forearm"
$bonemerge "v_weapon.Bip01_R_Hand"
$bonemerge "v_weapon.SCAR_Parent"
$bonemerge "v_weapon.stattrack"
$bonemerge "v_weapon.uid"
$bonemerge "v_weapon.Bip01_L_Forearm"
$bonemerge "v_weapon.Bip01_L_Hand"
$bonemerge "v_weapon.Bip01_L_Finger0"
$bonemerge "v_weapon.Bip01_L_Finger01"
$bonemerge "v_weapon.Bip01_L_Finger02"
$bonemerge "v_weapon.Bip01_L_Finger1"
$bonemerge "v_weapon.Bip01_L_Finger11"
$bonemerge "v_weapon.Bip01_L_Finger12"
$bonemerge "v_weapon.Bip01_L_Finger2"
$bonemerge "v_weapon.Bip01_L_Finger21"
$bonemerge "v_weapon.Bip01_L_Finger22"
$bonemerge "v_weapon.Bip01_L_Finger3"
$bonemerge "v_weapon.Bip01_L_Finger31"
$bonemerge "v_weapon.Bip01_L_Finger32"
$bonemerge "v_weapon.Bip01_L_Finger4"
$bonemerge "v_weapon.Bip01_L_Finger41"
$bonemerge "v_weapon.Bip01_L_Finger42"
$bonemerge "v_weapon.Bip01_L_ForeTwist"
$bonemerge "v_weapon.Bip01_R_Finger0"
$bonemerge "v_weapon.Bip01_R_Finger01"
$bonemerge "v_weapon.Bip01_R_Finger02"
$bonemerge "v_weapon.Bip01_R_Finger1"
$bonemerge "v_weapon.Bip01_R_Finger11"
$bonemerge "v_weapon.Bip01_R_Finger12"
$bonemerge "v_weapon.Bip01_R_Finger2"
$bonemerge "v_weapon.Bip01_R_Finger21"
$bonemerge "v_weapon.Bip01_R_Finger22"
$bonemerge "v_weapon.Bip01_R_Finger3"
$bonemerge "v_weapon.Bip01_R_Finger31"
$bonemerge "v_weapon.Bip01_R_Finger32"
$bonemerge "v_weapon.Bip01_R_Finger4"
$bonemerge "v_weapon.Bip01_R_Finger41"
$bonemerge "v_weapon.Bip01_R_Finger42"
$bonemerge "v_weapon.Bip01_R_ForeTwist"

$sectionframes 30 29

$sequence "idle" {
	"c_scw_scar20_anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "shoot1" {
	"c_scw_scar20_anims/shoot1.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	{ event AE_MUZZLEFLASH 0 "Pistol muzzle" }
	{ event AE_CLIENT_EFFECT_ATTACH 0 "EjectBrass_762Nato 2 100" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "reload" {
	"c_scw_scar20_anims/reload.smd"
	activity "ACT_VM_RELOAD" 1
	{ event 5004 13 "SCW.SCAR20.ClipOut" }
	{ event 5004 38 "SCW.SCAR20.ClipIn" }
	{ event 5004 58 "SCW.SCAR20.BoltForward" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "draw" {
	"c_scw_scar20_anims/draw.smd"
	activity "ACT_VM_DRAW" 1
	{ event 5004 0 "SCW.SCAR20.Draw" }
	{ event 5004 14 "SCW.SCAR20.BoltBack" }
	{ event 5004 18 "SCW.SCAR20.BoltForward" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}
