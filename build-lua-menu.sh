#!/bin/bash
addon() {
  local gmad
  if [ -f '.bin/fastgmad.exe' ]; then
    gmad=".bin/fastgmad.exe"
  else
    gmad="E:/Program Files/Steam/steamapps/common/GarrysMod/bin/gmad.exe"
  fi
  local dest="E:/Program Files/Steam/steamapps/common/GarrysMod/garrysmod/addons/test/"

  mkdir -p "$dest"

  local small="$1"
  small="${small// /_}"
  small="${small,,}"
  small="${small//[^a-zA-Z0-9_]/}"

  "$gmad" create -folder "$1" -out ".build/${small}.gma"
  cp -fv ".build/${small}.gma" "$dest" 2>/dev/null
}
lua_menu() {
  local dest="E:/Program Files/Steam/steamapps/common/GarrysMod/garrysmod/addons/"
  cp -frv "Lua Menu" "$dest" 2>/dev/null
}
rm -rf ".build"
mkdir -p ".build"
# Create and copy addons
lua_menu
read -r -s -n 1 -p "Press any key to continue..."
