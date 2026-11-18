# Compatibility entry point for users of `nix-build` and NUR-style tooling.
# Package availability follows the package's declared platform support.
{
  pkgs,
}:
{
  lib = import ./lib { inherit (pkgs) lib; };
  # overlays.default = import ./overlay.nix;
  modules.homeManager.rift = ./modules/home-manager/rift.nix;
}
// pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
  rift-wm = pkgs.callPackage ./pkgs/rift-wm { };
}
