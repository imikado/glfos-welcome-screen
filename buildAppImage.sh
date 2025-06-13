#!/usr/bin/env bash
rm -rf /tmp/glfosWelcomeScreen.AppDir
flutter build linux --release



set -euo pipefail

APP_BIN="build/linux/x64/release/bundle/glfos_welcome_screen"
DEST_DIR="appImage/lib"

copy_lib() {
  local lib_path="$1"

  # Skip non-absolute or non-existent paths
  [[ "$lib_path" != /* || ! -f "$lib_path" ]] && return

  local lib_name
  lib_name=$(basename "$lib_path")
  local dest_path="$DEST_DIR/$lib_name"

  # Avoid duplicates
  if [[ ! " ${SEEN_LIBS[*]} " =~ " ${lib_name} " ]]; then
    SEEN_LIBS+=("$lib_name")
    echo "Copying $lib_name"
    cp "$lib_path" "$dest_path"

    # Recursively scan this lib's dependencies
    ldd "$lib_path" | awk '{ if ($(NF-1) == "=>") print $3 }' | while read -r subdep; do
      copy_lib "$subdep"
    done
  fi
}

# Start with main binary
ldd "$APP_BIN" | awk '{ if ($(NF-1) == "=>") print $3 }' | while read -r lib; do
  copy_lib "$lib"
done



cp -r build/linux/x64/release/bundle/ /tmp/glfosWelcomeScreen.AppDir
cp -p appImage/lib/* /tmp/glfosWelcomeScreen.AppDir/lib/
cp assets/logo.png /tmp/glfosWelcomeScreen.AppDir/glfosWelcomeScreen.png
cp appImage/AppRun /tmp/glfosWelcomeScreen.AppDir/AppRun
chmod +x /tmp/glfosWelcomeScreen.AppDir/AppRun
cp appImage/glfosWelcomeScreen.desktop /tmp/glfosWelcomeScreen.AppDir/
appimagetool-x86_64.AppImage /tmp/glfosWelcomeScreen.AppDir
