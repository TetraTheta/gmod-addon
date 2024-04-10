
$modelname "sc_turret_resistance\floor_turret.mdl"

$bodygroup "studio"
{
  studio "floor_reference.smd"
}

$lod 12
{
  replacemodel "floor_reference.smd" "floor_reference_lod1.smd"
  nofacial
}
$lod 15
{
  replacemodel "floor_reference.smd" "floor_reference_lod2.smd"
  nofacial
}
$lod 20
{
  replacemodel "floor_reference.smd" "floor_reference_lod3.smd"
  nofacial
}
$lod 30
{
  replacemodel "floor_reference.smd" "floor_reference_lod4.smd"
  nofacial
}

$surfaceprop "metal"

$contents "solid"

$illumposition 0.805 -1.718 29.958

$eyeposition 0 0 64

$cdmaterials "models\sc_turret_resistance\floor_turret\"

$texturegroup "skinfamilies"
{
  { "default" }
  { "variant1" }
  { "variant2" }
  { "variant3" }
}

// This list shows the VMT file names used in the SMD files.
// "default.vmt"
// "variant1.vmt"
// "variant2.vmt"
// "variant3.vmt"

$attachment "eyes" "Barrel" 0.21 -0.43 6.78 rotate -90 -90 0
$attachment "laser_start" "Barrel" -0.2 0.6 3 rotate -90 -90 0
$attachment "laser_end" "Barrel" -0.2 0.6 28 rotate -90 -90 0
$attachment "light" "Gun" -5.6 7.1 -0.2 rotate -90 -90 0

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -16 -16 0 16 16 64

// Hitbox info. Used for damage-based collision.
// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "Base" -8.540106 -18.061283 -20.117575 8.652205 22.777401 24.030418
// $hbox 0 "Leftright" -2.353752 -6.487332 -1.984419 2.439936 23.105679 11.649864
// $hbox 0 "Gun" -6.985017 -3.83075 -12.860595 3.85078 8.826126 3.726596
// $hbox 0 "Barrel" -0.970022 -2.453441 -2.061847 1.007459 2.001588 6.665434
// $hbox 0 "cover" 0 -2.008429 -3.665741 2.437643 2.421464 6.565827

$definebone "Base" "" 0.748472 0.238418 17.889942 0 0 89.999982 0 0 0 0 0 0
$definebone "Leftright" "Base" 0.332457 15.529396 -0.220379 0 0 0 0 0 0 0 0 0
$definebone "Gun" "Leftright" 2.006938 17.841654 7.452806 0 0 0 0 0 0 0 0 0
$definebone "Barrel" "Gun" 1.671227 1.473717 3.726596 0 0 0 0 0 0 0 0 0
$definebone "cover" "Gun" 2.516212 0.478182 -0.870788 0 0 0 0 0 0 0 0 0

$poseparameter "aim_yaw" -60 60 loop 0
$poseparameter "aim_pitch" -15 15 loop 0

// TODO: Stop the turret being a tumbling doll
$collisionmodel "floor_turret_physics.smd" {
  $masscenter "[0 0 0]"
}

$animation "aim_right_corrective_animation" "floor_turret_anims\aim_right_corrective_animation.smd" {
}

$animation "aim_left_corrective_animation" "floor_turret_anims\aim_left_corrective_animation.smd" {
}

$animation "aim_up_corrective_animation" "floor_turret_anims\aim_up_corrective_animation.smd" {
}

$animation "aim_down_corrective_animation" "floor_turret_anims\aim_down_corrective_animation.smd" {
}

$animation "aim_neutral" "floor_turret_anims\aim_neutral.smd" {
  fps 30
}

$animation "aim_up" "floor_turret_anims\aim_up.smd" {
  fps 30
  // Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
  subtract "aim_up_corrective_animation" 0
}

$animation "aim_down" "floor_turret_anims\aim_down.smd" {
  fps 30
  // Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
  subtract "aim_down_corrective_animation" 0
}

$animation "aim_right" "floor_turret_anims\aim_right.smd" {
  fps 30
  // Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
  subtract "aim_right_corrective_animation" 0
}

$animation "aim_left" "floor_turret_anims\aim_left.smd" {
  fps 30
  // Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
  subtract "aim_left_corrective_animation" 0
}

$sequence "idle" {
  "floor_turret_anims\idle.smd"
  activity "ACT_FLOOR_TURRET_CLOSED_IDLE" 1
  fadein 0.2
  fadeout 0.2
  fps 30
  loop
}

$sequence "deploy" {
  "floor_turret_anims\deploy.smd"
  activity "ACT_FLOOR_TURRET_OPEN" 1
  fadein 0.2
  fadeout 0.2
  fps 30
}

$sequence "idlealert" {
  "floor_turret_anims\idlealert.smd"
  activity "ACT_FLOOR_TURRET_OPEN_IDLE" 1
  fadein 0.2
  fadeout 0.2
  fps 10
  loop
}

$sequence "fire" {
  "floor_turret_anims\fire.smd"
  activity "ACT_FLOOR_TURRET_FIRE" 1
  { event AE_NPC_MUZZLEFLASH 0 "COMBINE eyes" }
  fadein 0.2
  fadeout 0.2
  fps 30
}

$sequence "retract" {
  "floor_turret_anims\retract.smd"
  activity "ACT_FLOOR_TURRET_CLOSE" 1
  fadein 0.2
  fadeout 0.2
  fps 30
}

$sequence "aim_updown" {
  "floor_turret_anims\aim_updown.smd"
  fadein 0.2
  fadeout 0.2
  fps 30
}

$sequence "aim_leftright" {
  "floor_turret_anims\aim_leftright.smd"
  fadein 0.2
  fadeout 0.2
  fps 30
}

$sequence "auto_leftright" {
  // This sequence uses delta
  "aim_right"
  "aim_left"
  autoplay
  blend "aim_yaw" -60 60
  blendwidth 2
  delta
  fadein 0.2
  fadeout 0.2
}

$sequence "auto_updown" {
  // This sequence uses delta
  "aim_up"
  "aim_down"
  autoplay
  blend "aim_pitch" -15 15
  blendwidth 2
  delta
  fadein 0.2
  fadeout 0.2
}

$sequence "carry_pose" {
  "floor_turret_anims\carry_pose.smd"
  fadein 0.2
  fadeout 0.2
  fps 30
}

$collisionmodel "floor_turret_physics.smd"
{
  $mass 100
  $inertia 1
  $damping 0
  $rotdamping 0
  $rootbone " "
  $concave
  $maxconvexpieces 5
}

$collisiontext
{
  break
  {
    "model" "sc_turret_floor_resistance/floor_turret_gib1"
    "health" "0"
    "fadetime" "300"
    "burst" "300"
  }
  break
  {
    "model" "sc_turret_floor_resistance/floor_turret_gib2"
    "health" "0"
    "fadetime" "300"
    "burst" "300"
  }
  break
  {
    "model" "sc_turret_floor_resistance/floor_turret_gib3"
    "health" "0"
    "fadetime" "300"
    "burst" "300"
  }
  break
  {
    "model" "sc_turret_floor_resistance/floor_turret_gib4"
    "health" "0"
    "fadetime" "300"
    "burst" "300"
  }
  break
  {
    "model" "sc_turret_floor_resistance/floor_turret_gib5"
    "health" "0"
    "fadetime" "300"
    "burst" "300"
  }
}

$keyvalues
{
  custom_turret "1"
}
