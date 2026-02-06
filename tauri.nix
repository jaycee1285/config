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
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
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
        --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
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
in
{
  coverpro = mkTauriApp {
    pname = "coverpro";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/coverpro/releases/download/v0.1.0/coverpro-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:26096b163a9fad8ca812d7c215b2649153cf48543c419a49ce70e7deb9df668c";
  };

  spredux = mkTauriApp {
    pname = "spredux";
    version = "0.1.0";
    url = "https://github.com/jaycee1285/SPRedux/releases/download/v0.1.0/spredux-v0.1.0-linux-x86_64.tar.xz";
    hash = "sha256:23dfcc7c50ff7c3b934c8b47da427d060004596ee6b3e091bd9738498a1e5565";
  };

  openswarm = mkGtkApp {
    pname = "openswarm";
    version = "0.0.1";
    url = "https://github.com/jaycee1285/OpenSwarm/releases/download/release/openswarm-v0.0.1-linux-x86_64.tar.xz";
    hash = "sha256-XGMl+K/+istRrEUdzP0ezIqUWir+VGxx9nlyncKQ11E=";
  };
}
