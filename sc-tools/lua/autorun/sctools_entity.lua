local CATEGORY = "SC Entity"

list.Set("NPC", "npc_lost_soul", {
  Category = CATEGORY,
  Class = "npc_lost_soul",
  Health = 40,
  Model = "models/skeleton/skeleton_torso3.mdl",
  Name = "Lost Soul",
  NoDrop = true,
  Offset = 24
})

list.Set("NPC", "npc_shadow_walker", {
  Category = CATEGORY,
  Class = "npc_shadow_walker",
  Health = 75,
  Model = "models/monster/subject.mdl",
  Name = "Shadow Walker",
  Offset = 8,
  OnFloor = true
})
