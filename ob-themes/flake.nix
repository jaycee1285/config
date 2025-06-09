{
  description = "Jaycee1285 Openbox themes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
        pname = "ob-themes";
        version = "unstable-${self.shortRev or "unknown"}";
        src = ./.;
        installPhase = ''
          mkdir -p $out/share/themes
          cp -r $src/* $out/share/themes/
        '';
        meta = with pkgs.lib; {
          description = "Jaycee1285 Openbox themes";
          license = licenses.gpl3Only;
          platforms = platforms.linux;
        };
      };
    };
}
