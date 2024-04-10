
$modelname "sc_turret_resistance\floor_turret_gib5.mdl"

$staticprop

$bodygroup "body"
{
  studio "floor_turret_gib5.smd"
}

$lod 15
{
  replacemodel "floor_turret_gib5.smd" "floor_turret_gib5_lod1.smd"
  nofacial
}

$surfaceprop "metal"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "models\sc_turret_resistance\floor_turret\"

// This list shows the VMT file names used in the SMD files.
// "default.vmt"

$attachment "placementOrigin" "static_prop" 14.14 -0.28 -12.29 rotate 0 0 0

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -6.504 -2.573 -12.246 6.454 2.479 11.809

// Hitbox info. Used for damage-based collision.
// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "static_prop" -6.184247 -2.268299 -11.809277 6.184247 2.268299 11.809277

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0

$sequence "idle" {
  "floor_turret_gib5_anims\idle.smd"
  fadein 0.2
  fadeout 0.2
  fps 30
}

$collisionmodel "floor_turret_gib5_physics.smd"
{
  $mass 50
  $inertia 1
  $damping 0
  $rotdamping 0
  $rootbone " "
  $concave
  $maxconvexpieces 3

}

$keyvalues
{
  prop_data
  {
    "base" "Metal.Medium"
  }
}
