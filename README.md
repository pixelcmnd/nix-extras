# nix-extras

A small collection of Nix packages and modules.

## Nix outputs

- `packages`: buildable packages.
- `homeModules`: Home Manager module.
- `legacyPackages`: compatibility package set.
- `lib`: repository helper namespace.

## Updating the package

The package exposes nixpkgs' standard `passthru.updateScript`. From the
repository root, update its source version and hashes with:

```sh
nix run .#rift-wm.updateScript
```
