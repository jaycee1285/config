{ pkgs, ... }:

let
  ferrite = pkgs.stdenv.mkDerivation rec {
    pname = "ferrite";
    version = "0.2.6";

    src = pkgs.fetchurl {
      url = "https://github.com/OlaProeis/Ferrite/releases/download/v${version}/ferrite-linux-x64.tar.gz";
      sha256 = "sha256-QJWh6AzNlo0WdpnLvPZGXoItNaN4h4FN+f0XgEiHh2w=";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    buildInputs = [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.fontconfig
    ];

    unpackPhase = ''
      tar xf $src
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp ferrite $out/bin/
      chmod +x $out/bin/ferrite
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "A fast, lightweight text editor for Markdown, JSON, YAML, and TOML";
      homepage = "https://github.com/OlaProeis/Ferrite";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "ferrite";
    };
  };
in
{
  home.packages = [ ferrite ];
}
