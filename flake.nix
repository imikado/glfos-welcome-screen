{
  description = "GLF OS Welcome Screen using Flutter 3.2.7";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    flutter.url = "github:nix-community/flutter";
  };

  outputs = { self, nixpkgs, flake-utils, flutter, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ flutter.overlays.default ];
        };

        flutter327 = pkgs.flutter327;
      in {
        packages.default = flutter327.buildFlutterApplication {
          pname = "glfos-welcome-screen";
          version = "1.0.11";

          src = ./.;

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
      });
}
