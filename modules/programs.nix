{ pkgs, sartwc, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  sartwcPackage = sartwc.packages.${system}.default.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      rm -rf build
    '';
    passthru = (old.passthru or { }) // {
      providedSessions = [ "sartwc" ];
    };
  });
  upstreamLabwcPackage = pkgs.labwc092;
  labwc097Package = pkgs.unstable.labwc;
  labwc097Launcher = pkgs.writeShellScriptBin "labwc-097" ''
    exec ${pkgs.lib.getExe labwc097Package} "$@"
  '';
  labwc097DesktopFile = pkgs.writeTextFile {
    name = "labwc-097.desktop";
    destination = "/share/wayland-sessions/labwc-097.desktop";
    text = ''
      [Desktop Entry]
      Name=labwc-097
      Comment=A wayland stacking compositor (labwc ${labwc097Package.version})
      Exec=${labwc097Launcher}/bin/labwc-097
      Icon=labwc
      Type=Application
      DesktopNames=labwc;wlroots
    '';
  };
  labwc097SessionPackage = pkgs.runCommand "labwc-097-session" {
    passthru = {
      providedSessions = [ "labwc-097" ];
    };
  } ''
    mkdir -p "$out/bin" "$out/share/wayland-sessions"
    cp ${labwc097Launcher}/bin/labwc-097 "$out/bin/labwc-097"
    chmod +x "$out/bin/labwc-097"
    cp ${labwc097DesktopFile}/share/wayland-sessions/labwc-097.desktop "$out/share/wayland-sessions/labwc-097.desktop"
  '';
  sartwcSessionPackage = pkgs.runCommand "sartwc-session" {
    passthru = {
      providedSessions = [ "sartwc" ];
    };
  } ''
    mkdir -p "$out/bin" "$out/share/wayland-sessions"

    cat > "$out/bin/sartwc-session" <<'EOF'
    #!${pkgs.runtimeShell}
    set -eu

    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/sartwc"
    mkdir -p "$state_dir"
    log_file="$state_dir/session.log"

    {
      printf '\n=== %s ===\n' "$(${pkgs.coreutils}/bin/date --iso-8601=seconds)"
      printf 'launcher=%s\n' "ly"
      printf 'exec=%s\n' "${pkgs.lib.getExe sartwcPackage}"
      printf 'pwd=%s\n' "$PWD"
      printf 'user=%s\n' "''${USER:-}"
      printf 'shell=%s\n' "''${SHELL:-}"
      printf 'tty=%s\n' "$(${pkgs.coreutils}/bin/tty 2>/dev/null || printf 'unknown')"
      printf '%s\n' '-- env --'
      ${pkgs.coreutils}/bin/env | ${pkgs.coreutils}/bin/sort
    } >> "$log_file" 2>&1

    exec >> "$log_file" 2>&1
    printf 'starting sartwc\n'
    ${pkgs.lib.getExe sartwcPackage} -V
    status=$?
    printf 'sartwc exited status=%s\n' "$status"
    exit "$status"
EOF

    chmod +x "$out/bin/sartwc-session"

    cat > "$out/share/wayland-sessions/sartwc.desktop" <<EOF
    [Desktop Entry]
    Name=sartwc
    Comment=A wayland stacking compositor (labwc fork with IPC)
    Exec=$out/bin/sartwc-session
    Icon=labwc
    Type=Application
    DesktopNames=sartwc;wlroots
EOF
  '';
in
{
  environment.systemPackages = [
    labwc097Launcher
  ];

  services.displayManager.sessionPackages = [
    labwc097SessionPackage
    sartwcSessionPackage
  ];

  programs.labwc.enable = true;
  programs.labwc.package = upstreamLabwcPackage;
  programs.niri.enable = true;
  programs.fuse.enable = true;
  programs.fuse.userAllowOther = true;
  programs.nix-ld.enable = true;
  programs.wayvnc.enable = true;
   programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}
