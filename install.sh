#!/bin/bash
set -euo pipefail

app_path="/Applications/红果短剧.app"
api="https://api.github.com/repos/JialaoLiu/hongguo-mac-release/releases"

if [[ "$(uname -m)" != "arm64" ]]; then
  echo "安装失败：仅支持 Apple Silicon（arm64），不支持 Intel Mac。" >&2
  exit 1
fi
macos_version="$(sw_vers -productVersion)"
if [[ "${macos_version%%.*}" -lt 13 ]]; then
  echo "安装失败：需要 macOS 13 或以上，当前为 ${macos_version}。" >&2
  exit 1
fi
if [[ -n "${HONGGUO_VERSION:-}" ]]; then
  release_url="$api/tags/v$HONGGUO_VERSION"
else
  release_url="$api/latest"
fi

tmp="$(mktemp -d)"
mounted=0
cleanup() {
  if [[ "$mounted" -eq 1 ]]; then
    hdiutil detach "$tmp/mnt" >/dev/null
  fi
  rm -rf "$tmp"
}
trap cleanup EXIT

echo "正在获取发行版本……"
if ! curl -fsSL "$release_url" -o "$tmp/release.json"; then
  echo "获取版本失败：请检查网络、GitHub API 或指定版本。" >&2
  exit 1
fi
release_tag="$(plutil -extract tag_name raw -o - "$tmp/release.json")"
index=0
download_url=""
while asset_name="$(plutil -extract "assets.$index.name" raw -o - "$tmp/release.json" 2>/dev/null)"; do
  if [[ "$asset_name" == HongguoDrama-*-arm64.dmg ]]; then
    download_url="$(plutil -extract "assets.$index.browser_download_url" raw -o - "$tmp/release.json")"
    break
  fi
  index=$((index + 1))
done
if [[ -z "$download_url" ]]; then
  echo "安装失败：$release_tag 中没有 HongguoDrama-<版本>-arm64.dmg。" >&2
  exit 1
fi

echo "正在下载 ${release_tag}：${asset_name}"
if ! curl -fL --progress-bar "$download_url" -o "$tmp/hongguo.dmg"; then
  echo "下载失败，请检查网络后重试。" >&2
  exit 1
fi
mkdir "$tmp/mnt"
echo "正在挂载安装包……"
hdiutil attach -nobrowse -readonly -mountpoint "$tmp/mnt" "$tmp/hongguo.dmg" >/dev/null
mounted=1
source_app="$tmp/mnt/红果短剧.app"
minimum_version="$(plutil -extract LSMinimumSystemVersion raw -o - "$source_app/Contents/Info.plist")"
if [[ ! "$minimum_version" =~ ^[0-9]+(\.[0-9]+){0,2}$ ]]; then
  echo "安装失败：安装包的最低系统要求无效，现有应用保持不变。" >&2
  exit 1
fi
IFS=. read -r required_major required_minor required_patch <<< "$minimum_version"
IFS=. read -r current_major current_minor current_patch <<< "$macos_version"
required_minor="${required_minor:-0}"; required_patch="${required_patch:-0}"
current_minor="${current_minor:-0}"; current_patch="${current_patch:-0}"
if (( current_major < required_major ||
      (current_major == required_major && current_minor < required_minor) ||
      (current_major == required_major && current_minor == required_minor && current_patch < required_patch) )); then
  echo "安装失败：${release_tag} 需要 macOS ${minimum_version} 或以上，当前为 ${macos_version}。现有应用保持不变。" >&2
  exit 1
fi
if ! codesign --verify --deep --strict "$source_app"; then
  echo "安装失败：安装包签名完整性校验未通过，现有应用保持不变。" >&2
  exit 1
fi
if pgrep -x HongguoMac >/dev/null; then
  echo "请先退出红果短剧，再运行安装脚本。" >&2
  exit 1
fi

needs_sudo=0
if [[ ! -w /Applications || ( -e "$app_path" && ! -w "$app_path" ) ]]; then
  echo "Applications 或旧版应用不可写，需要管理员权限安装。"
  sudo -v
  needs_sudo=1
fi
run_install() {
  if [[ "$needs_sudo" -eq 1 ]]; then
    sudo "$@"
  else
    "$@"
  fi
}
if [[ -e "$app_path" ]]; then
  echo "正在移除旧版红果短剧……"
  run_install rm -rf "$app_path"
fi
echo "正在安装到 Applications……"
run_install ditto "$source_app" "$app_path"
run_install xattr -dr com.apple.quarantine "$app_path" 2>/dev/null || true
if ! codesign --verify --deep --strict "$app_path"; then
  echo "安装失败：应用签名完整性校验未通过。" >&2
  exit 1
fi
version="$(plutil -extract CFBundleShortVersionString raw -o - "$app_path/Contents/Info.plist")"
echo "安装成功：红果短剧 $version"
echo '启动命令：open "/Applications/红果短剧.app"'
if { exec 3<> /dev/tty; } 2>/dev/null; then
  printf '是否立即打开？[y/N] ' >&3
  if IFS= read -r answer <&3; then
    case "$answer" in
      y|Y) open "$app_path" ;;
    esac
  fi
  exec 3>&-
fi
