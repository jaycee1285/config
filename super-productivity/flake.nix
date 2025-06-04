{
  description = "Always-latest super-productivity build from GitHub fork, for Nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Replace below with your actual fork and branch/tag as needed:
    super-productivity-src.url = "github:jaycee1285/super-productivity";
    # Optionally, to use a branch: super-productivity-src.url = "github:youruser/super-productivity?ref=my-branch";
  };

  outputs = { self, nixpkgs, flake-utils, super-productivity-src, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        superProductivity = pkgs.callPackage ./super-productivity.nix {
          src = super-productivity-src;
        };

      in {
        packages.default = superProductivity;
        apps.default = flake-utils.lib.mkApp { drv = superProductivity; };
      }
    );
}
