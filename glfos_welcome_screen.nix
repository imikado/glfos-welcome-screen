{ lib, flutter, dart, zlib, gtk3, gtk4, pkg-config, libtool, libGL, libX11, fetchurl, libadwaita }:

# Define the Flutter app package
flutter.buildFlutterApplication rec {
  pname = "glfos_welcome_screen";
  version = "1.0.0";

  src = fetchurl {

    url = "https://github.com/imikado/glfos-welcome-screen/archive/refs/tags/0.0.1.tar.gz";
    sha256 = "151fe0d819675e9a36602ad5390a8b85aeb29de116faa0bc7cd6285e2064ca6e";
  };

  

  autoPubspecLock = ./pubspec.lock;

  buildInputs = [ flutter dart zlib gtk3 pkg-config libtool libGL libX11 gtk4 libadwaita ];
 


}
