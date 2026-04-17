{
  lib,
  fetchgit,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  glib,
  glib-networking,
  desktop-file-utils,
  gettext,
  librsvg,
  blueprint-compiler,
  python3Packages,
  sassc,
  appstream-glib,
  libadwaita,
  gtk4,
  libportal,
  libportal-gtk4,
  libsoup_3,
  polkit,
  gobject-introspection,
}:

python3Packages.buildPythonApplication rec {
  pname = "glfos-welcome-screen";
  version = "2.0.1";

  src = fetchgit {
    url = "https://github.com/imikado/glfos-welcome-screen";
    rev = version;
    sha256 = "sha256-G6tn7yuLjdkIyPNRiQjY8/r7Z92R404jUCvXph+cUJs=";
  };

  format = "other";
  dontWrapGApps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    gtk4
    meson
    ninja
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    libadwaita
    librsvg
    polkit.bin
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    mkdir -p "$out/etc/xdg/autostart"
    cat > "$out/etc/xdg/autostart/glfos-welcome-screen.desktop" <<'EOF'
[Desktop Entry]
Name=GLF OS Welcome Screen
Exec=/run/current-system/sw/bin/glfos-welcome-screen
Icon=glfos-welcome-screen
Terminal=false
Type=Application
StartupNotify=true
StartupWMClass=org.dupot.glfos_welcome_screen
X-GNOME-Autostart-enabled=true
EOF
  '';

  meta = with lib; {
    description = "Welcome Screen";
    license = licenses.gpl3Plus;
  };
}
