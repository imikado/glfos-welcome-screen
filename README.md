# glfos-welcome-screen

Welcome screen for glf os (a linux distribution, based on nixos)

## Build the derivation and test it

Derivation use flake.nix

```bash
nix build
```

## generate hash

(To generate hash for glfos-welcome-screen/default.nix)

```bash
nix flake prefetch https://github.com/imikado/glfos-welcome-screen/releases/download/X.Y.Z/bundle.zip
```
