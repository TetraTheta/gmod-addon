#!/bin/bash

set -euo pipefail

# 0. 스크립트가 위치한 경로로 cwd 변경
cd -- "$(dirname -- "$0")"

# 대상 디렉토리 경로 설정
TARGET_DIR=".luals/addons/garrysmod"
GLOBALS_FILE="$TARGET_DIR/library/_globals.lua"
REPO_DIR="glua-api-snippets-lua-language-server-addon"
REPO_URL="https://github.com/luttje/glua-api-snippets/archive/refs/heads/lua-language-server-addon.zip"

# 1. 검증이 끝날 때까지 기존 정의를 보존할 임시 디렉토리 생성
mkdir -p "$(dirname "$TARGET_DIR")"
TEMP_DIR="$(mktemp -d "$(dirname "$TARGET_DIR")/.garrysmod-update.XXXXXX")"
trap 'rm -rf "$TEMP_DIR"' EXIT
ZIP_FILE="$TEMP_DIR/addon.zip"

# 2. git 없이 lua-language-server-addon 브랜치 다운로드 및 압축 해제
echo "GitHub에서 브랜치(lua-language-server-addon) 다운로드 중..."
curl --fail --location --show-error "$REPO_URL" --output "$ZIP_FILE"

echo "압축 해제 및 파일 이동 중..."
unzip -q "$ZIP_FILE" -d "$TEMP_DIR"

# GitHub zip은 압축 해제 시 '저장소명-브랜치명' 형태의 폴더가 생성되므로,
# 새 정의가 온전할 때만 기존 디렉토리를 교체합니다.
if [ ! -f "$TEMP_DIR/$REPO_DIR/library/_globals.lua" ]; then
  echo "오류: 내려받은 정의에 library/_globals.lua가 없습니다. 작업 실패." >&2
  exit 1
fi

rm -rf "$TARGET_DIR"
mv "$TEMP_DIR/$REPO_DIR" "$TARGET_DIR"

if [ ! -f "$GLOBALS_FILE" ]; then
  echo "오류: $GLOBALS_FILE가 없습니다. 작업 실패." >&2
  exit 1
fi

echo "작업이 성공적으로 완료되었습니다!"
if [ -t 0 ]; then
  read -r -n 1 -s -p "Press any key to continue..."
  echo
fi
