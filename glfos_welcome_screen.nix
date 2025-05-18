{ lib, flutter, dart, zlib, gtk3, pkg-config, libtool, libGL, libX11, fetchurl }:

# Define the Flutter app package
flutter.buildFlutterApplication rec {
  pname = "glfos_welcome_screen";
  version = "1.0.0";

  src = fetchurl {

    url = "https://github.com/imikado/glfos-welcome-screen/archive/refs/tags/1.4.0.tar.gz";
    sha256 = "sha256-2fdef9e87988c49f6332d8020eb3f5492e3a47c2f3fac52a167cd3600d7f7887;
  };

  autoPubspecLock = ./pubspec.lock;

  buildInputs = [ flutter dart zlib gtk3 pkg-config libtool libGL libX11 ];



}
