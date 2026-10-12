#!/bin/bash
set -euo pipefail

app_path="/Applications/红果短剧.app"
api="https://api.github.com/repos/JialaoLiu/hongguo-mac-release/releases"

# 终端在 Rosetta 下运行时 uname -m 也会显示 x86_64，以硬件为准。
if [[ "$(sysctl -n hw.optional.arm64 2>/dev/null || true)" == "1" ]]; then
  arch="arm64"
else
  arch="x86_64"
fi
macos_version="$(sw_vers -productVersion)"
if [[ "${macos_version%%.*}" -lt 13 ]]; then
  echo "安装失败：需要 macOS 13 或以上，当前为 ${macos_version}。" >&2
  exit 1
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

release_tag=""
asset_name=""
expected_size=""
expected_sha=""
download_urls=()

# 先读版本清单（国内 Gitee 优先，其次 GitHub），清单给出哈希与多个下载地址。
read_manifest() {
  local manifest="$tmp/update.json" prefix=""
  [[ "$arch" == "x86_64" ]] && prefix="variants.x86_64."
  for source in "${manifests[@]}"; do
    curl -fsSL --max-time 20 "$source" -o "$manifest" 2>/dev/null || continue
    local version name
    version="$(plutil -extract version raw -o - "$manifest" 2>/dev/null)" || continue
    name="$(plutil -extract "${prefix}file" raw -o - "$manifest" 2>/dev/null)" || {
      echo "当前版本 ${version} 暂无 ${arch} 安装包。" >&2
      return 1
    }
    [[ "$name" == "HongguoDrama-${version}-${arch}.dmg" ]] || continue
    release_tag="v$version"; asset_name="$name"
    expected_size="$(plutil -extract "${prefix}size" raw -o - "$manifest")"
    expected_sha="$(plutil -extract "${prefix}sha256" raw -o - "$manifest")"
    download_urls=()
    local index=0 url
    while url="$(plutil -extract "${prefix}urls.$index" raw -o - "$manifest" 2>/dev/null)"; do
      case "$url" in
        https://gitee.com/jarvislao/hongguo-mac-release/releases/download/*|https://github.com/JialaoLiu/hongguo-mac-release/releases/download/*)
          download_urls+=("$url") ;;
      esac
      index=$((index + 1))
    done
    [[ ${#download_urls[@]} -gt 0 ]] && return 0
  done
  return 1
}

# 指定版本或清单不可用时，使用 GitHub Release API。
read_github_release() {
  local release_url="$api/latest"
  [[ -n "${HONGGUO_VERSION:-}" ]] && release_url="$api/tags/v$HONGGUO_VERSION"
  if ! curl -fsSL "$release_url" -o "$tmp/release.json"; then
    echo "获取版本失败：请检查网络、GitHub API 或指定版本。" >&2
    exit 1
  fi
  release_tag="$(plutil -extract tag_name raw -o - "$tmp/release.json")"
  local index=0 name
  while name="$(plutil -extract "assets.$index.name" raw -o - "$tmp/release.json" 2>/dev/null)"; do
    if [[ "$name" == HongguoDrama-*-"$arch".dmg ]]; then
      asset_name="$name"
      download_urls=("$(plutil -extract "assets.$index.browser_download_url" raw -o - "$tmp/release.json")")
      expected_size="$(plutil -extract "assets.$index.size" raw -o - "$tmp/release.json" 2>/dev/null || true)"
      local digest
      digest="$(plutil -extract "assets.$index.digest" raw -o - "$tmp/release.json" 2>/dev/null || true)"
      expected_sha="${digest#sha256:}"
      return 0
    fi
    index=$((index + 1))
  done
  echo "安装失败：$release_tag 暂无 ${arch} 安装包（HongguoDrama-<版本>-${arch}.dmg）。" >&2
  exit 1
}

echo "正在获取发行版本……"
manifests=("https://gitee.com/jarvislao/hongguo-mac-release/raw/master/update.json"
           "https://raw.githubusercontent.com/JialaoLiu/hongguo-mac-release/main/update.json")
if [[ -n "${HONGGUO_VERSION:-}" ]] || ! read_manifest; then
  read_github_release
fi

echo "正在下载 ${release_tag}：${asset_name}"
downloaded=0
for url in "${download_urls[@]}"; do
  rm -f "$tmp/hongguo.dmg"
  curl -fL --progress-bar "$url" -o "$tmp/hongguo.dmg" || continue
  if [[ -n "$expected_size" && "$(stat -f %z "$tmp/hongguo.dmg")" != "$expected_size" ]]; then
    echo "安装包大小不一致，尝试其他下载地址……" >&2
    continue
  fi
  if [[ -n "$expected_sha" && "$(shasum -a 256 "$tmp/hongguo.dmg" | cut -d ' ' -f 1)" != "$expected_sha" ]]; then
    echo "安装包 SHA-256 不一致，尝试其他下载地址……" >&2
    continue
  fi
  downloaded=1
  break
done
if [[ "$downloaded" -ne 1 ]]; then
  echo "下载失败或安装包校验未通过，现有应用保持不变。" >&2
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
if ! lipo -archs "$source_app/Contents/MacOS/HongguoMac" 2>/dev/null | tr ' ' '\n' | grep -qx "$arch"; then
  echo "安装失败：安装包不是 ${arch} 版本，现有应用保持不变。" >&2
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
