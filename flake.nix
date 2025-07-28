{
  description = "GLF OS Welcome Screen (Flutter App)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11-pre";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { };
        };

        src = pkgs.fetchFromGitHub {
          owner = "imikado";
          repo = "glfos-welcome-screen";
          rev = "1.0.15";
          sha256 = "1ynnhp0ri461yahwz2y21mrwzshqg29b8qg9zm8dpgjfyj9yg3vg";
        };

        flutterApp = pkgs.flutter.buildFlutterApplication {
          pname = "glfos_welcome_screen";
          version = "0.0.3";

          inherit src;
          flutterChannel = "stable";

          nativeBuildInputs = with pkgs; [ pkg-config ];

          buildInputs = with pkgs; [
            gtk4 libadwaita libepoxy libxkbcommon glib cairo pango atk
          ];

          buildPhase = ''
            rm -rf build
            flutter build linux --release
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp -r build/linux/x64/release/bundle/* $out/
            ln -s $out/glfos_welcome_screen $out/bin/glfos_welcome_screen

            for lib in $out/lib/*.so; do
              if patchelf --print-rpath "$lib" | grep -q "/build"; then
                echo "Fixing RPATH in $lib"
                patchelf --set-rpath "$out/lib" "$lib"
              fi
            done
          '';

          strictDeps = true;
          autoPubspecLock = "${src}/pubspec.lock";

          meta = with pkgs.lib; {
            description = "Welcome screen";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };

      in {
      
      packages.default = flutterApp.overrideAttrs (_: {
	  outputs = [ "out" ];  # Disable "debug" output
	});
      });
}