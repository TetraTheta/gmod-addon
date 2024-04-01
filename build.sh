#!/bin/bash
gmad="E:/Program Files/Steam/steamapps/common/GarrysMod/bin/gmad.exe"
dest="E:/Program Files/Steam/steamapps/common/GarrysMod/garrysmod/addons/test"
rm -rf ".build"
mkdir -p ".build"
mkdir -p "$dest"
#"$gmad" create -folder "Decrease Sound" -out ".build/decrease_sound.gma"; cp -fv ".build/decrease_sound.gma" "$dest" 2>/dev/null
"$gmad" create -folder "Fix Map" -out ".build/fixmap.gma"; cp -fv ".build/fixmap.gma" "$dest" 2>/dev/null
#"$gmad" create -folder "SC Admin Gun" -out ".build/sc_admin_gun.gma"; cp -fv ".build/sc_admin_gun.gma" "$dest" 2>/dev/null
#"$gmad" create -folder "NPC Invasion" -out ".build/npc_invasion.gma"; cp -fv ".build/npc_invasion.gma" "$dest" 2>/dev/null
#"$gmad" create -folder "Sandbox Map Sort" -out ".build/sandbox_map_sort.gma"; cp -fv ".build/sandbox_map_sort.gma" "$dest" 2>/dev/null
"$gmad" create -folder "SC Tools" -out ".build/sc_tools.gma"; cp -fv ".build/sc_tools.gma" "$dest" 2>/dev/null
read -r -s -n 1 -p "Press any key to continue..."
