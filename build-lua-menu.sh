#!/bin/bash
lua_menu() {
  local dest="E:/Program Files/Steam/steamapps/common/GarrysMod/garrysmod/"
  cp -frv "Lua Menu/." "$dest" 2>/dev/null
}
# Create and copy addons
lua_menu
read -r -s -n 1 -p "Press any key to continue..."
