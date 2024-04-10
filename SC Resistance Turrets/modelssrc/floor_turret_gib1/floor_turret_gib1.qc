
$modelname "sc_turret_resistance\floor_turret_gib1.mdl"

$staticprop

$bodygroup "body"
{
  studio "floor_turret_gib1.smd"
}

$lod 15
{
  replacemodel "floor_turret_gib1.smd" "floor_turret_gib1_lod1.smd"
  nofacial
}

$surfaceprop "metal"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "models\sc_turret_resistance\floor_turret\"

// This list shows the VMT file names used in the SMD files.
// "default.vmt"

$attachment "placementOrigin" "static_prop" -1.16 -0.37 -35.84 rotate 0 0 0

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -10.268 -3.383 -10.561 10.268 3.299 10.329

// Hitbox info. Used for damage-based collision.
// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "static_prop" -10.018297 -3.132584 -10.328917 10.018297 3.132584 10.328915

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0

$sequence "idle" {
  "floor_turret_gib1_anims\idle.smd"
  fadein 0.2
  fadeout 0.2
  fps 30
}

$collisionmodel "floor_turret_gib1_physics.smd"
{
  $mass 75
  $inertia 1
  $damping 0
  $rotdamping 0
  $rootbone " "
  $concave
  $maxconvexpieces 4
}

$keyvalues
{
  prop_data
  {
    "base" "Metal.Medium"
  }
}
