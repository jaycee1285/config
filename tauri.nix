# Pre-built app derivations fetched from GitHub releases and patched
# with autoPatchelfHook to link against the correct runtime deps.
{ pkgs }:

let
  tauriRuntimeLibs = with pkgs; [
    webkitgtk_4_1
    gtk3
    glib
    glib-networking
    libsoup_3
    cairo
    pango
    gdk-pixbuf
    openssl
    dbus
    wayland
    libxkbcommon
    libX11
    libXcursor
    libXrandr
    libXi
  ];

  mkTauriApp = { pname, version, url, hash }: pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl { inherit url hash; };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    buildInputs = tauriRuntimeLibs;

    unpackPhase = ''
      local tmp=$(mktemp -d)
      tar xJf $src -C "$tmp"
      mkdir -p $out/bin

      if [ -d "$tmp/bin" ]; then
        # Archive with directory structure (e.g. from nix build output)
        cp -r "$tmp"/* "$out/"
        # Unwrap stale Nix wrappers to get the raw binary
        if [ -f "$out/bin/.${pname}-wrapped_" ]; then
          mv "$out/bin/.${pname}-wrapped_" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped"
        fi
      else
        # Simple archive with just the binary
        cp "$tmp"/* "$out/bin/"
      fi
      chmod +x "$out/bin/${pname}"
    '';

    dontBuild = true;
    dontInstall = true;

    postFixup = ''
      wrapProgram $out/bin/${pname} \
        --set GIO_MODULE_DIR "${pkgs.glib-networking}/lib/gio/modules" \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
        --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" \
        --prefix PATH : "${pkgs.typst}/bin" \
        --run 'export TYPST_FONT_PATHS="/etc/profiles/per-user/$USER/share/fonts:$HOME/.local/share/fonts:/run/current-system/sw/share/fonts"'
    '';
  };

  gtk4RuntimeLibs = with pkgs; [
    gtk4
    vte-gtk4
    glib
    pango
    gdk-pixbuf
    cairo
    graphene
    harfbuzz
    gsettings-desktop-schemas
  ];

  mkGtkApp = { pname, version, url, hash }: pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl { inherit url hash; };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    buildInputs = gtk4RuntimeLibs;

    unpackPhase = ''
      local tmp=$(mktemp -d)
      tar xJf $src -C "$tmp"
      mkdir -p $out/bin

      if [ -d "$tmp/bin" ]; then
        cp -r "$tmp"/* "$out/"
        if [ -f "$out/bin/.${pname}-wrapped_" ]; then
          mv "$out/bin/.${pname}-wrapped_" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped"
        fi
      else
        cp "$tmp"/* "$out/bin/"
      fi
      chmod +x "$out/bin/${pname}"
    '';

    dontBuild = true;
    dontInstall = true;

    postFixup = ''
      wrapProgram $out/bin/${pname} \
        --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}"
    '';
  };

  # Ferritebar-specific builder with bundled fonts and optimized env vars
  mkFerritebarApp = { pname, version, url, hash }:
    let
      barFonts = pkgs.symlinkJoin {
        name = "${pname}-fonts";
        paths = [
          pkgs.font-awesome
          pkgs.fira
        ];
      };

      barFontconfig = pkgs.writeText "${pname}-fonts.conf" ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <dir>${barFonts}/share/fonts</dir>
          <cachedir>/tmp/${pname}-fontcache</cachedir>
          <rescan><int>0</int></rescan>
        </fontconfig>
      '';

      ferritebarRuntimeLibs = gtk4RuntimeLibs ++ (with pkgs; [
        gtk4-layer-shell
        wayland
        libpulseaudio
        libxkbcommon
      ]);
    in
    pkgs.stdenv.mkDerivation {
      inherit pname version;

      src = pkgs.fetchurl { inherit url hash; };

      nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
      buildInputs = ferritebarRuntimeLibs;

      unpackPhase = ''
        local tmp=$(mktemp -d)
        tar xJf $src -C "$tmp"
        mkdir -p $out/bin

        if [ -d "$tmp/bin" ]; then
          cp -r "$tmp"/* "$out/"
          if [ -f "$out/bin/.${pname}-wrapped_" ]; then
            mv "$out/bin/.${pname}-wrapped_" "$out/bin/${pname}"
            rm -f "$out/bin/.${pname}-wrapped"
          fi
        else
          cp "$tmp"/* "$out/bin/"
        fi
        chmod +x "$out/bin/${pname}"
      '';

      dontBuild = true;
      dontInstall = true;

      postFixup = ''
        wrapProgram $out/bin/${pname} \
          --set GSK_RENDERER cairo \
          --set GDK_DISABLE "vulkan,gl,dmabuf,offload" \
          --set GTK_A11Y none \
          --set NO_AT_BRIDGE 1 \
          --set GDK_BACKEND wayland \
          --set GTK_MEDIA none \
          --set GTK_CSD 0 \
          --unset GTK_IM_MODULE \
          --set FONTCONFIG_FILE ${barFontconfig} \
          --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}"
      '';
    };
  rustvoxRuntimeLibs = with pkgs; [
    alsa-lib
    libpulseaudio
    wayland
    dbus
    stdenv.cc.cc.lib  # libstdc++ for bundled libvosk.so
  ];

  mkRustvoxApp = { pname, version, url, hash }: pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl { inherit url hash; };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    buildInputs = rustvoxRuntimeLibs;

    unpackPhase = ''
      local tmp=$(mktemp -d)
      tar xJf $src -C "$tmp"
      mkdir -p $out/bin $out/share/rustvox/models

      if [ -d "$tmp/bin" ]; then
        cp -r "$tmp"/* "$out/"
        if [ -f "$out/bin/.${pname}-wrapped_" ]; then
          mv "$out/bin/.${pname}-wrapped_" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped"
        fi
      else
        cp "$tmp"/* "$out/bin/"
      fi
      chmod +x "$out/bin/${pname}"
    '';

    dontBuild = true;
    dontInstall = true;

    postFixup = ''
      wrapProgram $out/bin/${pname} \
        --prefix PATH : "${pkgs.wtype}/bin" \
        --prefix PATH : "${pkgs.dotool}/bin"
    '';
  };

in
{
  coverpro = mkTauriApp {
    pname = "coverpro";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/coverpro/releases/download/v0.1.0/coverpro-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:ed6883cce723a99feab5376c793d773500e593d6711acb160ea738b84bf27f87";
  };

  daylight = mkTauriApp {
    pname = "daylight";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/daylight/releases/download/v0.1.0/daylight-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:6d0e81ed94a4c194b7962255684c44f2e5d97ef6ca8c228164b966e15423138a";
  };

  openswarm = mkGtkApp {
    pname = "openswarm";
    version = "0.0.1";
    url = "https://github.com/jaycee1285/OpenSwarm/releases/download/release/openswarm-v0.0.1-linux-x86_64.tar.xz";
    hash = "sha256:89e8cd1bdd10b8856692bec9766ca6138f3b6e74968729b1c5ed89e1f08a9b80";
  };

  ferritebar = mkFerritebarApp {
    pname = "ferritebar";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/ferritebar/releases/download/v0.1.0/ferritebar-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:62f54a8917f96a97b4fa06c17210fb201fcd2d612a20fb7a8a7d0dd09324c54d";
  };

  rustvox = mkRustvoxApp {
    pname = "rustvox";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/rustvox/releases/download/v0.1.0/rustvox-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:508c263e15ab28d17f69e9d52f326d60fa3c15f74387c12a7b9b6e8e8c47662d";
  };
}
