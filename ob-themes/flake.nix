{
  inputs = {
    ob-themes.url = "github:jaycee1285/ob-themes";
  };

  outputs = { nixpkgs, ob-themes, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      # NixOS module
      nixosConfigurations.my-hostname = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            environment.systemPackages = [
              ob-themes.packages.${system}.default
            ];
          }
        ];
      };
    };
