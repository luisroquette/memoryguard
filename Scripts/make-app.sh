#!/bin/zsh
set -euo pipefail

project_dir="${0:A:h:h}"
app_dir="$project_dir/dist/MemoryGuard.app"
staging_root="$(/usr/bin/mktemp -d "$project_dir/.memoryguard-package.XXXXXX")"
staging_app="$staging_root/MemoryGuard.app"
contents_dir="$staging_app/Contents"

cleanup() {
    /bin/rm -rf "$staging_root"
}
trap cleanup EXIT

cd "$project_dir"
swift Scripts/generate-icon.swift
/usr/bin/iconutil -c icns "$project_dir/Resources/MemoryGuard.iconset" -o "$project_dir/Resources/MemoryGuard.icns"
swift build -c release

/bin/mkdir -p "$contents_dir/MacOS" "$contents_dir/Resources"
/bin/cp "$project_dir/.build/release/MemoryGuard" "$contents_dir/MacOS/MemoryGuard"
/bin/cp "$project_dir/Resources/Info.plist" "$contents_dir/Info.plist"
/bin/cp "$project_dir/Resources/MemoryGuard.icns" "$contents_dir/Resources/MemoryGuard.icns"
/usr/bin/codesign --force --deep --sign - "$staging_app"

if [[ "$app_dir" != "$project_dir/dist/MemoryGuard.app" || -L "$app_dir" ]]; then
    echo "Destino de pacote inválido: $app_dir" >&2
    exit 1
fi
/bin/rm -rf "$app_dir"
/bin/mv "$staging_app" "$app_dir"
/usr/bin/codesign --verify --deep --strict "$app_dir"

echo "$app_dir"
