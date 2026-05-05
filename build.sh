#!/usr/bin/env bash
set -euo pipefail

ROOT_WIN="E:/Program Files/Steam/steamapps/common/GarrysMod"
BUILD_DIR=".build"

# ----------
# Utilities
# ----------
log() {
  local header="${1:-INFO}"
  local message="${2:-}"
  printf "%s %s\n" "$header" "$message"
}

to_unix_path() {
  local p="$1"
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -u "$p"
  else
    printf '%s\n' "$p"
  fi
}

sanitize_name() {
  local input="$1"
  local lower
  lower="$(printf '%s' "$input" | tr '[:upper:]' '[:lower:]')"
  lower="$(printf '%s' "$lower" | sed -E 's/[[:space:]-]+/_/g; s/[^a-z0-9_]//g')"
  printf '%s\n' "$lower"
}

resolve_target() {
  local arg="${1:-}"
  local lower
  lower="$(printf '%s' "$arg" | tr '[:upper:]' '[:lower:]')"

  case "$lower" in
    1|cheat-map|cheat_map) echo "cheat-map" ;;
    2|dark-mode|dark_mode) echo "dark-mode" ;;
    3|fix-map|fix_map) echo "fix-map" ;;
    4|more-properties|more_properties) echo "more-properties" ;;
    5|private-reserve|private_reserve) echo "private-reserve" ;;
    6|sc-resistance-turrets|sc_resistance_turrets) echo "sc-resistance-turrets" ;;
    7|sc-tools|sc_tools) echo "sc-tools" ;;
    8|sc-weapons|sc_weapons) echo "sc-weapons" ;;
    *) echo "" ;;
  esac
}

show_target_prompt() {
  {
    echo "What do you want to build?"
    echo "[1] Cheat Map"
    echo "[2] Dark Mode"
    echo "[3] Fix Map"
    echo "[4] More Properties"
    echo "[5] Private Reserve"
    echo "[6] SC Resistance Turrets"
    echo "[7] SC Tools"
    echo "[8] SC Weapons"
  } >&2
  read -r -p "Choice: " choice >&2
  resolve_target "$choice"
}

show_post_build_prompt() {
  {
    echo
    echo "Build finished. What do you want to do next?"
    echo "[1] Copy to default destination"
    echo "[2] Copy to custom destination"
    echo "[3] Do not copy"
  } >&2
  read -r -p "Choice: " post_choice >&2
  echo "$post_choice"
}

copy_recursive() {
  local src="$1"
  local dst="$2"

  if [[ ! -d "$src" ]]; then
    log "ERROR" "Source directory does not exist: $src"
    return 1
  fi

  mkdir -p "$dst"
  cp -rf "$src"/* "$dst"/
  log "INFO" "Copied contents of '$src' to '$dst'"
}

copy_artifact() {
  local src_file="$1"
  local dst_dir="$2"

  mkdir -p "$dst_dir"
  cp -f "$src_file" "$dst_dir"/
  log "INFO" "Copied '$src_file' to '$dst_dir'"
}

build_gma() {
  local addon_dir="$1"
  local lower
  lower="$(sanitize_name "$addon_dir")"

  mkdir -p "$BUILD_DIR"

  local out_gma="$BUILD_DIR/$lower.gma"
  # Keep gmad log output on stderr so command substitution captures only the artifact path.
  "$GMAD" create -folder "$addon_dir" -out "$out_gma" >&2
  echo "$out_gma"
}

# ----------
# Main
# ----------
ROOT="$(to_unix_path "$ROOT_WIN")"
ADDONS="$ROOT/garrysmod/addons"
ADDONS_TEST="$ADDONS/test"
ADDONS_PRIVATE="$ADDONS/private"

if [[ ! -d "$ROOT" ]]; then
  log "ERROR" "GMod is not installed. (missing: $ROOT)"
  exit 1
fi

GMAD_64="$ROOT/bin/win64/gmad.exe"
GMAD_32="$ROOT/bin/gmad.exe"

if [[ -f "$GMAD_64" ]]; then
  GMAD="$GMAD_64"
  log "INFO" "Using 64bit gmad.exe"
elif [[ -f "$GMAD_32" ]]; then
  GMAD="$GMAD_32"
  log "INFO" "Using 32bit gmad.exe"
else
  log "ERROR" "gmad.exe not found."
  exit 1
fi

arg="${1:-}"
if [[ -z "$arg" ]]; then
  target="$(show_target_prompt)"
else
  target="$(resolve_target "$arg")"
fi

if [[ -z "$target" ]]; then
  log "ERROR" "Invalid choice or argument."
  exit 1
fi

log "INFO" "target: $target"

artifact_path=""
default_copy_dst=""
source_copy_dir=""
copy_mode=""

case "$target" in
  dark-mode)
    source_copy_dir="dark-mode"
    default_copy_dst="$ADDONS/DarkMode"
    copy_mode="directory"
    ;;
  private-reserve)
    artifact_path="$(build_gma "private-reserve")"
    default_copy_dst="$ADDONS_PRIVATE"
    copy_mode="file"
    ;;
  *)
    artifact_path="$(build_gma "$target")"
    default_copy_dst="$ADDONS_TEST"
    copy_mode="file"
    ;;
esac

post_choice="$(show_post_build_prompt)"
case "$post_choice" in
  1)
    if [[ "$copy_mode" == "directory" ]]; then
      copy_recursive "$source_copy_dir" "$default_copy_dst"
    else
      copy_artifact "$artifact_path" "$default_copy_dst"
    fi
    ;;
  2)
    read -r -p "Enter custom destination path: " custom_dst
    if [[ -z "$custom_dst" ]]; then
      log "ERROR" "Destination path is empty."
      exit 1
    fi

    custom_dst="$(to_unix_path "$custom_dst")"
    if [[ "$copy_mode" == "directory" ]]; then
      copy_recursive "$source_copy_dir" "$custom_dst"
    else
      copy_artifact "$artifact_path" "$custom_dst"
    fi
    ;;
  3)
    if [[ "$copy_mode" == "directory" ]]; then
      log "INFO" "Skipped copy for '$source_copy_dir'."
    else
      log "INFO" "Skipped copy. Built artifact remains at '$artifact_path'."
    fi
    ;;
  *)
    log "ERROR" "Invalid post-build choice."
    exit 1
    ;;
esac

read -r -n 1 -s -p "Press any key to continue..."
echo
