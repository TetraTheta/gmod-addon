
$modelname "sc_turret_resistance\floor_turret_gib3.mdl"

$staticprop

$bodygroup "body"
{
  studio "floor_turret_gib3.smd"
}

$lod 15
{
  replacemodel "floor_turret_gib3.smd" "floor_turret_gib3_lod1.smd"
  nofacial
}

$surfaceprop "metal"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "models\sc_turret_resistance\floor_turret\"

// This list shows the VMT file names used in the SMD files.
// "default.vmt"

$attachment "placementOrigin" "static_prop" -6.33 -2.12 -54.13 rotate 0 0 0

// Clipping box or view bounding box.
$cbox 0 0 0 0 0 0

// Bounding box or hull. Used for collision with a world object.
$bbox -11.061 -4.824 -6.306 11.172 4.808 6.114

// Hitbox info. Used for damage-based collision.
// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "static_prop" -10.84132 -4.58533 -6.02993 10.84132 4.58533 6.029934

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0

$sequence "idle" {
  "floor_turret_gib3_anims\idle.smd"
  fadein 0.2
  fadeout 0.2
  fps 30
}

$collisionmodel "floor_turret_gib3_physics.smd"
{
  $mass 50
  $inertia 1
  $damping 0
  $rotdamping 0
  $rootbone " "
  $concave
  $maxconvexpieces 6

}

$keyvalues
{
  prop_data
  {
    "base" "Metal.Medium"
  }
}
