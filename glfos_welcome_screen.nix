{ lib, flutter, dart, zlib, gtk3, gtk4, pkg-config, libtool, libGL, libX11, fetchurl, libadwaita, libepoxy, libxkbcommon, cairo, pango, atk }:



# Define the Flutter app package
flutter.buildFlutterApplication rec {
  pname = "glfos_welcome_screen";
  version = "1.0.0";

  src = fetchurl {

    url = "https://github.com/imikado/glfos-welcome-screen/archive/refs/tags/0.0.3.tar.gz";
    sha256 = "1edb9ee580f5e1e0bfa343600fa9a2c3df16b09552575aea12679e9a6c17bf01";
  };

  installPhase = ''
  mkdir -p $out/usr/lib
  ln -s /etc/os-release $out/usr/lib/os-release
'';  

  autoPubspecLock = ./pubspec.lock;

  buildInputs = [  
    gtk4
    libadwaita
    libepoxy
    libxkbcommon
     
    cairo
    pango
    atk 
  ];
 
  meta = with lib; {
    description = "Adwaita-themed Flutter desktop app";
    license = licenses.mit;
    platforms = platforms.linux;
  };

}
