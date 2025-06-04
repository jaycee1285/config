{
  description = "Always-latest super-productivity build from GitHub fork, for Nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    super-productivity-src.url = "github:jaycee1285/super-productivity";
  };

  outputs = { self, nixpkgs, flake-utils, super-productivity-src, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        buildNpmPackage = pkgs.buildNpmPackage.override { nodejs = pkgs.nodejs_20; };
        superProductivity = pkgs.callPackage ./super-productivity.nix {
          inherit buildNpmPackage;
          src = super-productivity-src;
        };
      in {
        packages.default = superProductivity;
        apps.default = flake-utils.lib.mkApp { drv = superProductivity; };
      }
    );
}
