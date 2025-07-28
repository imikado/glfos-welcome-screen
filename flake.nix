{
  description = "GLF OS Welcome Screen using Flutter 3.2.7 from GitHub";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        flutter327 = pkgs.flutter327;

        # Download source archive
        src = pkgs.fetchFromGitHub {
          owner = "imikado";
          repo = "glfos-welcome-screen";
          rev = "1.0.12";
          sha256 = "0piqdp1rswv6b4bqfp7475kd5z96kvx5kwhiqdjgh4r0q4xzn30a";
        };

        # Wrap the local pubspec.lock (generated via flutter pub get)
        pubspecLock = pkgs.runCommandLocal "pubspec.lock" { } ''
          cp ${./pubspec.lock} $out
        '';
      in {
        packages.default = flutter327.buildFlutterApplication {
          pname = "glfos-welcome-screen";
          version = "1.0.12";
          inherit src ;

         autoPubspecLock = "${src}/pubspec.lock";



          flutterBuildArgs = [ "linux" ];

          nativeBuildInputs = with pkgs; [
            pkg-config
            libadwaita
            glib
            gtk3
          ];

          meta = with pkgs.lib; {
            description = "GLF OS Welcome screen built with Flutter 3.2.7";
            homepage = "https://github.com/imikado/glfos-welcome-screen";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };

        # Optional: enter a dev shell with flutter and GTK libs
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            flutter327
            libadwaita
            glib
            gtk3
            pkg-config
          ];
        };
      });
}
