rm -rf /tmp/glfosWelcomeScreen.AppDir
cp -r build/linux/x64/release/bundle/ /tmp/glfosWelcomeScreen.AppDir
cp assets/logo.png /tmp/glfosWelcomeScreen.AppDir/glfosWelcomeScreen.png
cp appImage/AppRun /tmp/glfosWelcomeScreen.AppDir/glfosWelcomeScreen.png
chmod +x /tmp/glfosWelcomeScreen.AppDir/AppRun
cp appImage/glfosWelcomeScreen.desktop /tmp/glfosWelcomeScreen.AppDir/
appimagetool-x86_64.AppImage /tmp/glfosWelcomeScreen.AppDir
