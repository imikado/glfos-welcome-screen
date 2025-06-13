#!/usr/bin/env bash
rm -rf /tmp/glfosWelcomeScreen.AppDir
flutter build linux --release



set -euo pipefail

APP_BIN="build/linux/x64/release/bundle/glfos_welcome_screen"
DEST_DIR="appImage/lib"

echo "Collecting shared library dependencies for: $APP_BIN"
ldd "$APP_BIN" | grep '=>' | while read -r lib _ path _; do
  if [[ -n "$path" && "$path" == /* && -f "$path" ]]; then
    libname=$(basename "$path")
    dest="$DEST_DIR/$libname"
    if [[ ! -f "$dest" ]]; then
      echo "Copying $libname"
      cp "$path" "$dest"
    else
      echo "Skipping already copied $libname"
    fi
  fi
done

echo "Done. All dependencies are now in $DEST_DIR"



cp -r build/linux/x64/release/bundle/ /tmp/glfosWelcomeScreen.AppDir
cp -p appImage/lib/* /tmp/glfosWelcomeScreen.AppDir/lib/
cp assets/logo.png /tmp/glfosWelcomeScreen.AppDir/glfosWelcomeScreen.png
cp appImage/AppRun /tmp/glfosWelcomeScreen.AppDir/AppRun
chmod +x /tmp/glfosWelcomeScreen.AppDir/AppRun
cp appImage/glfosWelcomeScreen.desktop /tmp/glfosWelcomeScreen.AppDir/
appimagetool-x86_64.AppImage /tmp/glfosWelcomeScreen.AppDir
