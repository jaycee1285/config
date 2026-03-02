{ config, pkgs, sartwc, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  sartwcRepoDir = "${config.home.homeDirectory}/repos/config/home/sartwc";
  sartwcPackage = sartwc.packages.${system}.default.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      rm -rf build
    '';
    passthru = (old.passthru or { }) // {
      providedSessions = [ "sartwc" ];
    };
  });
in {
  home.packages = [
    sartwcPackage
  ];

  xdg.configFile."sartwc".source =
    config.lib.file.mkOutOfStoreSymlink sartwcRepoDir;
  xdg.configFile."sartwc".recursive = true;
}
