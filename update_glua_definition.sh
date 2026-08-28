#!/bin/bash

# 0. 스크립트가 위치한 경로로 cwd 변경
cd "$(dirname "$0")"

# 대상 디렉토리 경로 설정
TARGET_DIR=".luals/addons/garrysmod"

# 1. 폴더가 없으면 만들고, 있으면 안의 내용물 모두 지우기
if [ -d "$TARGET_DIR" ]; then
  echo "기존 디렉토리가 존재합니다. 내용물을 비웁니다: $TARGET_DIR"
  rm -rf "$TARGET_DIR"/* "$TARGET_DIR"/.[!.]* "$TARGET_DIR"/..?* 2>/dev/null || true
else
  echo "디렉토리를 생성합니다: $TARGET_DIR"
  mkdir -p "$TARGET_DIR"
fi

# 2. git 없이 lua-language-server-addon 브랜치 다운로드 및 압축 해제
echo "GitHub에서 브랜치(lua-language-server-addon) 다운로드 중..."

# 임시 zip 파일 경로
ZIP_FILE="addon_temp.zip"
REPO_URL="https://github.com/luttje/glua-api-snippets/archive/refs/heads/lua-language-server-addon.zip"

# curl을 이용해 zip 다운로드 (실패 시 스크립트 중단)
if ! curl -L "$REPO_URL" -o "$ZIP_FILE"; then
  echo "오류: 다운로드에 실패했습니다."
  exit 1
fi

echo "압축 해제 및 파일 이동 중..."
# 임시 폴더에 압축 해제
mkdir -p temp_extract
unzip -q "$ZIP_FILE" -d temp_extract

# GitHub zip은 압축 해제 시 '저장소명-브랜치명' 형태의 폴더가 생성되므로,
# 그 내부의 실제 내용물만 대상 경로로 이동합니다.
mv temp_extract/glua-api-snippets-lua-language-server-addon/* "$TARGET_DIR"/ 2>/dev/null || true
# 숨김 파일(점 파일)이 있을 경우를 대비해 안전하게 이동
mv temp_extract/glua-api-snippets-lua-language-server-addon/.[!.]* "$TARGET_DIR"/ 2>/dev/null || true

# 임시 파일 및 폴더 정리
rm -f "$ZIP_FILE"
rm -rf temp_extract

echo "작업이 성공적으로 완료되었습니다!"
read -r -n 1 -s -p "Press any key to continue..."
echo
