{
  description = "Always-latest super-productivity fork (no hashes!)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Replace this with your actual fork location:
    super-productivity-src.url = "github:jaycee1285/super-productivity";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, super-productivity-src, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        superProductivity = pkgs.callPackage ./super-productivity.nix {
          src = super-productivity-src;
        };
      in {
        packages.default = superProductivity;
        # Optional: expose as an app for `nix run`
        apps.default = flake-utils.lib.mkApp { drv = superProductivity; };
      }
    );
}
