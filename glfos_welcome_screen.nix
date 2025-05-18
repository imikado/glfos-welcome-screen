{ lib, flutter, dart, zlib, gtk3, gtk4, pkg-config, libtool, libGL, libX11, fetchurl, libadwaita }:

# Define the Flutter app package
flutter.buildFlutterApplication rec {
  pname = "glfos_welcome_screen";
  version = "1.0.0";

  src = fetchurl {

    url = "https://github.com/imikado/glfos-welcome-screen/archive/refs/tags/0.0.2.tar.gz";
    sha256 = "813af583b17a9e2cb9d81cbcdd0b366a828093e606e0c31989a30b605a49cbcb";
  };

  

  autoPubspecLock = ./pubspec.lock;

  buildInputs = [ flutter dart zlib gtk3 pkg-config libtool libGL libX11 gtk4 libadwaita ];
 


}
