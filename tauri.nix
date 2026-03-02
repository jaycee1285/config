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
      local tmp srcRoot
      local -a entries
      tmp=$(mktemp -d)
      tar xJf $src -C "$tmp"
      srcRoot="$tmp"

      # Handle archives wrapped in a single top-level directory.
      shopt -s nullglob dotglob
      entries=("$tmp"/*)
      if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
        srcRoot="''${entries[0]}"
      fi

      mkdir -p $out/bin

      if [ -d "$srcRoot/bin" ]; then
        # Archive with directory structure (e.g. from nix build output)
        cp -a "$srcRoot"/. "$out/"
        # Unwrap stale Nix wrappers to get the raw binary
        if [ -f "$out/bin/.${pname}-wrapped_" ]; then
          mv "$out/bin/.${pname}-wrapped_" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped"
        fi
      else
        # Flat archive: copy everything, then move top-level files into bin
        # while leaving directories like share/ at the package root.
        cp -a "$srcRoot"/. "$out/"
        entries=("$out"/*)
        for entry in "''${entries[@]}"; do
          [ "$entry" = "$out/bin" ] && continue
          if [ ! -d "$entry" ]; then
            mv "$entry" "$out/bin/"
          fi
        done
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

  ferriteRuntimeLibs = gtk4RuntimeLibs ++ (with pkgs; [
    fontconfig
    freetype
    libxkbcommon
    wayland
    vulkan-loader
    libGL
    libx11
    libxcursor
    libxi
    libxrandr
    libxcb
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libxcb
    xorg.libXext
    xorg.libXrender
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXxf86vm
  ]);

  mkGtkApp = { pname, version, url, hash, extraWrapArgs ? "" }: pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl { inherit url hash; };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    buildInputs = gtk4RuntimeLibs;

    unpackPhase = ''
      local tmp srcRoot
      local -a entries
      tmp=$(mktemp -d)
      tar xJf $src -C "$tmp"
      srcRoot="$tmp"

      shopt -s nullglob dotglob
      entries=("$tmp"/*)
      if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
        srcRoot="''${entries[0]}"
      fi

      mkdir -p $out/bin

      if [ -d "$srcRoot/bin" ]; then
        cp -a "$srcRoot"/. "$out/"
        if [ -f "$out/bin/.${pname}-wrapped_" ]; then
          mv "$out/bin/.${pname}-wrapped_" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped"
        fi
      else
        cp -a "$srcRoot"/. "$out/"
        entries=("$out"/*)
        for entry in "''${entries[@]}"; do
          [ "$entry" = "$out/bin" ] && continue
          if [ ! -d "$entry" ]; then
            mv "$entry" "$out/bin/"
          fi
        done
      fi
      chmod +x "$out/bin/${pname}"
    '';

    dontBuild = true;
    dontInstall = true;

    postFixup = ''
      wrapProgram $out/bin/${pname} \
        ${extraWrapArgs} \
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
        local tmp srcRoot
        local -a entries
        tmp=$(mktemp -d)
        tar xJf $src -C "$tmp"
        srcRoot="$tmp"

        shopt -s nullglob dotglob
        entries=("$tmp"/*)
        if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
          srcRoot="''${entries[0]}"
        fi

        mkdir -p $out/bin

        if [ -d "$srcRoot/bin" ]; then
          cp -a "$srcRoot"/. "$out/"
          if [ -f "$out/bin/.${pname}-wrapped_" ]; then
            mv "$out/bin/.${pname}-wrapped_" "$out/bin/${pname}"
            rm -f "$out/bin/.${pname}-wrapped"
          fi
        else
          cp -a "$srcRoot"/. "$out/"
          entries=("$out"/*)
          for entry in "''${entries[@]}"; do
            [ "$entry" = "$out/bin" ] && continue
            if [ ! -d "$entry" ]; then
              mv "$entry" "$out/bin/"
            fi
          done
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
      local tmp srcRoot
      local -a entries
      tmp=$(mktemp -d)
      tar xJf $src -C "$tmp"
      srcRoot="$tmp"

      shopt -s nullglob dotglob
      entries=("$tmp"/*)
      if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
        srcRoot="''${entries[0]}"
      fi

      mkdir -p $out/bin $out/share/rustvox/models

      if [ -d "$srcRoot/bin" ]; then
        cp -a "$srcRoot"/. "$out/"
        if [ -f "$out/bin/.${pname}-wrapped_" ]; then
          mv "$out/bin/.${pname}-wrapped_" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped"
        fi
      else
        cp -a "$srcRoot"/. "$out/"
        entries=("$out"/*)
        for entry in "''${entries[@]}"; do
          [ "$entry" = "$out/bin" ] && continue
          if [ ! -d "$entry" ]; then
            mv "$entry" "$out/bin/"
          fi
        done
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
    hash = "sha256:572959b5800785673082890de1f16ea94e39ef41870d2390d93e2a65b94fa7b6";
  };

  daylight = mkTauriApp {
    pname = "daylight";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/daylight/releases/download/v0.1.0/daylight-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:12f59b87ed571e8159ea08bb21ec07361224285d3975ac51dd5ec06b6c9829cd";
  };

  jotter = mkTauriApp {
    pname = "jotter";
    version = "0.1.3";
    url = "https://github.com/jaycee1285/jotter/releases/download/v0.1.3/jotter-v0.1.3-linux-x86_64.tar.xz";
    hash = "sha256:d1e18b58c875a48f49b1a4ac1b5400690e960bf12ea63837ba6a1ff8dfc33494";
  };

  openswarm = mkGtkApp {
    pname = "openswarm";
    version = "0.0.1";
    url = "https://github.com/jaycee1285/OpenSwarm/releases/download/v0.0.1/openswarm-v0.0.1-linux-x86_64.tar.xz";
    hash = "sha256:a36824d2b8c6f3a59978ed68d3b9579b8733f934088b0dd4aeb9f9210ee2105f";
  };

  ferritebar = mkFerritebarApp {
    pname = "ferritebar";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/ferritebar/releases/download/v0.1.0/ferritebar-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:158e716823726c1d34107e002f3577cb82b98a10cc7e71f60b9cbe859d0ffed6";
  };

  rustvox = mkRustvoxApp {
    pname = "rustvox";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/rustvox/releases/download/v0.1.0/rustvox-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:bfd943d18a9b6bb58dba39369172f40b764e3f63dc6bb9664d7be42ace7f5fb3";
  };

  ferrite = mkGtkApp {
    pname = "ferrite";
    version = "0.2.7";
    url = "https://github.com/jaycee1285/Ferrite/releases/download/v0.2.7/ferrite-v0.2.7-linux-x86_64.tar.xz";
    hash = "sha256:7a11c1b64d5c6fc875272a53fb3d6ade7235ee66bc67f31bdbb368bd5172164d";
    extraWrapArgs = ''--prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath ferriteRuntimeLibs}"'';
  };
}
