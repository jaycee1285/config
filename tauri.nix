# Pre-built app derivations fetched from GitHub releases and patched
# with autoPatchelfHook to link against the correct runtime deps.
{ pkgs, openswarm-src }:

let
  cliRuntimeLibs = with pkgs; [
    stdenv.cc.cc.lib
  ];

  transcrustRuntimeLibs = with pkgs; [
    alsa-lib
    libpulseaudio
    wayland
    dbus
    openssl
    libnotify
    stdenv.cc.cc.lib
  ];

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
      tar xaf $src -C "$tmp"
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
        if [ -f "$out/bin/.${pname}-wrapped" ]; then
          mv "$out/bin/.${pname}-wrapped" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped_"
        elif [ -f "$out/bin/.${pname}-wrapped_" ]; then
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
        --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    '';
  };

  mkCliApp = { pname, version, url, hash }: pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl { inherit url hash; };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = cliRuntimeLibs;

    unpackPhase = ''
      local tmp srcRoot
      local -a entries
      tmp=$(mktemp -d)
      tar xaf $src -C "$tmp"
      srcRoot="$tmp"

      shopt -s nullglob dotglob
      entries=("$tmp"/*)
      if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
        srcRoot="''${entries[0]}"
      fi

      mkdir -p $out/bin

      if [ -d "$srcRoot/bin" ]; then
        cp -a "$srcRoot"/. "$out/"
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
    adwaita-icon-theme
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
    libxext
    libxrender
    libxfixes
    libxinerama
    libxdamage
    libxcomposite
    libxxf86vm
  ]);

  openswarmSrc = openswarm-src;

  mkGtkApp = { pname, version, url, hash, extraWrapArgs ? "", extraPostFixup ? "" }: pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl { inherit url hash; };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    buildInputs = gtk4RuntimeLibs;

    unpackPhase = ''
      local tmp srcRoot
      local -a entries
      tmp=$(mktemp -d)
      tar xaf $src -C "$tmp"
      srcRoot="$tmp"

      shopt -s nullglob dotglob
      entries=("$tmp"/*)
      if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
        srcRoot="''${entries[0]}"
      fi

      mkdir -p $out/bin

      if [ -d "$srcRoot/bin" ]; then
        cp -a "$srcRoot"/. "$out/"
        if [ -f "$out/bin/.${pname}-wrapped" ]; then
          mv "$out/bin/.${pname}-wrapped" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped_"
        elif [ -f "$out/bin/.${pname}-wrapped_" ]; then
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
        --set GTK_THEME Adwaita \
        --prefix XDG_DATA_DIRS : "$out/share:${pkgs.adwaita-icon-theme}/share:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}"
      ${extraPostFixup}
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
        tar xaf $src -C "$tmp"
        srcRoot="$tmp"

        shopt -s nullglob dotglob
        entries=("$tmp"/*)
        if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
          srcRoot="''${entries[0]}"
        fi

        mkdir -p $out/bin

        if [ -d "$srcRoot/bin" ]; then
          cp -a "$srcRoot"/. "$out/"
          if [ -f "$out/bin/.${pname}-wrapped" ]; then
          mv "$out/bin/.${pname}-wrapped" "$out/bin/${pname}"
          rm -f "$out/bin/.${pname}-wrapped_"
        elif [ -f "$out/bin/.${pname}-wrapped_" ]; then
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
  mkTranscrustApp = { pname, version, url, hash }: pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl { inherit url hash; };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    buildInputs = transcrustRuntimeLibs;

    unpackPhase = ''
      local tmp srcRoot
      local -a entries
      tmp=$(mktemp -d)
      tar xaf $src -C "$tmp"
      srcRoot="$tmp"

      shopt -s nullglob dotglob
      entries=("$tmp"/*)
      if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
        srcRoot="''${entries[0]}"
      fi

      mkdir -p $out/bin

      if [ -d "$srcRoot/bin" ]; then
        cp -a "$srcRoot"/. "$out/"
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
        --prefix PATH : "${pkgs.wtype}/bin:${pkgs.dotool}/bin:${pkgs.libnotify}/bin"
    '';
  };

  # Serverbar: GTK4 system tray daemon
  mkServerbarApp = { pname, version, url, hash }:
    let
      serverbarRuntimeLibs = gtk4RuntimeLibs ++ (with pkgs; [
        libnotify
        dbus
        libxkbcommon
        fontconfig
        freetype
      ]);
    in
    pkgs.stdenv.mkDerivation {
      inherit pname version;

      src = pkgs.fetchurl { inherit url hash; };

      nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
      buildInputs = serverbarRuntimeLibs;

      unpackPhase = ''
        local tmp srcRoot
        local -a entries
        tmp=$(mktemp -d)
        tar xaf $src -C "$tmp"
        srcRoot="$tmp"

        shopt -s nullglob dotglob
        entries=("$tmp"/*)
        if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
          srcRoot="''${entries[0]}"
        fi

        mkdir -p $out/bin

        if [ -d "$srcRoot/bin" ]; then
          cp -a "$srcRoot"/. "$out/"
          if [ -f "$out/bin/.${pname}-wrapped" ]; then
            mv "$out/bin/.${pname}-wrapped" "$out/bin/${pname}"
            rm -f "$out/bin/.${pname}-wrapped_"
          elif [ -f "$out/bin/.${pname}-wrapped_" ]; then
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
          --set GTK_THEME Adwaita \
          --prefix XDG_DATA_DIRS : "$out/share:${pkgs.adwaita-icon-theme}/share:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}"
      '';
    };

in
{
  coverpro = mkTauriApp {
    pname = "coverpro";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/coverpro/releases/download/v0.1.0/coverpro-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:6c23e1852a207a5f0d26086c3b41060afaf8cc620f16466dfd4c9ba087bc1cca";
  };

  daylight = mkTauriApp {
    pname = "daylight";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/daylight/releases/download/v0.1.0/daylight-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:6b4dc1c18aa0f17243d75f936fb8f0e2d0de106c0acfc54cbd0b826d99656e0e";
  };

  openswarm = pkgs.rustPlatform.buildRustPackage {
    pname = "openswarm";
    version = "main";
    src = openswarmSrc;
    cargoLock.lockFile = openswarmSrc + "/Cargo.lock";

    nativeBuildInputs = [ pkgs.pkg-config pkgs.makeWrapper ];
    buildInputs = gtk4RuntimeLibs;

    postInstall = ''
      install -Dm644 ${openswarmSrc}/packaging/linux/openswarm.desktop \
        $out/share/applications/openswarm.desktop
      substituteInPlace $out/share/applications/openswarm.desktop \
        --replace-fail 'Exec=openswarm' "Exec=$out/bin/openswarm"

      mkdir -p $out/share/icons
      cp -r ${openswarmSrc}/icons/linux/hicolor $out/share/icons/
    '';

    postFixup = ''
      wrapProgram $out/bin/openswarm \
        --set OPENSWARM_CODEX_BIN "${pkgs.codex}/bin/codex" \
        --set GTK_THEME Adwaita \
        --prefix XDG_DATA_DIRS : "$out/share:${pkgs.adwaita-icon-theme}/share:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}"
    '';
  };

  ferritebar = mkFerritebarApp {
    pname = "ferritebar";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/ferritebar/releases/download/v0.1.0/ferritebar-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:8e9a93d901720b203a17ef1ee8cb822ae9bbdf6e04cbc4f9c14b01547310dbdb";
  };

  transcrust = mkTranscrustApp {
    pname = "transcrust";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/transcrust/releases/download/v0.1.0/transcrust-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:dc63be543d7265154b1ada01616196eb1f6ac6ecb3f5d3f48f55a975f086b8d4";
  };

  dotagent = mkGtkApp {
    pname = "dotagent";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/dotagent/releases/download/v0.1.0/dotagent-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:a6d83511dabab5c103ac7927702a718d9cebc2604f0e2f5b6b0468942211489a";
    extraWrapArgs = ''--prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath ferriteRuntimeLibs}"'';
  };

  ferritor = mkGtkApp {
    pname = "ferritor";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/ferritor/releases/download/v0.1.0/ferritor-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:f72cfa272d43112033023eb67fa6f0153ec0b8dfbe9049a1f11af4b5a50a5401";
    extraWrapArgs = ''--prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath ferriteRuntimeLibs}"'';
    extraPostFixup = ''
      if [ ! -f "$out/share/applications/ferritor.desktop" ]; then
        mkdir -p $out/share/applications
        cat > $out/share/applications/ferritor.desktop <<'DESKTOP'
[Desktop Entry]
Version=1.0
Type=Application
Name=Ferritor
GenericName=Text Editor
Comment=A filesystem browser and text editor built with Rust
Exec=ferritor %F
Icon=ferritor
Terminal=false
Categories=Utility;TextEditor;Office;
Keywords=editor;text;markdown;files;browser;rust;
MimeType=text/plain;text/markdown;text/x-markdown;application/json;application/x-yaml;application/toml;text/x-toml;text/csv;text/tab-separated-values;text/x-rust;text/javascript;application/javascript;application/x-typescript;
StartupNotify=true
StartupWMClass=ferritor
DESKTOP
      fi
    '';
  };

  krust = mkCliApp {
    pname = "krust";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/krust/releases/download/v0.1.0/krust-v0.1.0-linux-x86_64.tar.gz";
    hash = "sha256:03a5e31c5c48722ebfbbe55a7490e138a60a41a9bdffef63e8761f69a4bf0c0f";
  };

  serverbar = mkServerbarApp {
    pname = "serverbar";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/serverbar/releases/download/v0.1.0/serverbar-v0.1.0-linux-x86_64.tar.gz";
    hash = "sha256:757699e9255a99fc9248e8503218bb21bb290e097689d8d32e55c06bf4f65b08";
  };
}
