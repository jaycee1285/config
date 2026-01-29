# Tauri Binary Releases

Skip the Nix-sandbox Rust/Tauri build pain. Build binaries in the dev shell, tar them up, and have the config flake unpack them straight into the path.

---

## Building Release Binaries

### SPRedux

```bash
cd ~/repos/SPRedux
nix develop

# install frontend deps + build frontend + build tauri binary
bun install
cargo tauri build --no-bundle

# binary lands here
ls src-tauri/target/release/spredux

# package it
tar czf ~/spredux.tar.gz -C src-tauri/target/release spredux
```

### CoverPro

```bash
cd ~/repos/coverpro/app
nix develop

# install frontend deps + build frontend + build tauri binary
bun install
cargo tauri build --no-bundle

# binary lands here
ls src-tauri/target/release/coverpro

# package it
tar czf ~/coverpro.tar.gz -C src-tauri/target/release coverpro
```

---

## Updating the Config Flake

### 1. Drop the flake inputs

In `flake.nix`, remove the `spredux` and `coverpro` inputs and all references to them in `outputs`, `specialArgs`, and `extraSpecialArgs`.

Remove these lines from `inputs`:

```nix
spredux.url = "git+file:///home/john/repos/SPRedux";
coverpro.url = "git+file:///home/john/repos/coverpro";
```

Remove `spredux` and `coverpro` from the `outputs` function arguments and from every `specialArgs` / `extraSpecialArgs` block.

### 2. Add binary package derivations

Create `home/spredux.nix`:

```nix
{ pkgs, ... }:

let
  spredux = pkgs.stdenv.mkDerivation {
    pname = "spredux";
    version = "0.1.0";

    src = /home/john/spredux.tar.gz;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    unpackPhase = ''
      mkdir -p $out/bin
      tar xzf $src -C $out/bin
    '';

    dontBuild = true;
    dontInstall = true;

    postFixup = ''
      wrapProgram $out/bin/spredux \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath (with pkgs; [
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
        ])}" \
        --set GIO_MODULE_DIR "${pkgs.glib-networking}/lib/gio/modules" \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    '';
  };
in
{
  home.packages = [ spredux ];
}
```

Create `home/coverpro.nix`:

```nix
{ pkgs, ... }:

let
  coverpro = pkgs.stdenv.mkDerivation {
    pname = "coverpro";
    version = "0.1.0";

    src = /home/john/coverpro.tar.gz;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    unpackPhase = ''
      mkdir -p $out/bin
      tar xzf $src -C $out/bin
    '';

    dontBuild = true;
    dontInstall = true;

    postFixup = ''
      wrapProgram $out/bin/coverpro \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath (with pkgs; [
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
        ])}" \
        --set GIO_MODULE_DIR "${pkgs.glib-networking}/lib/gio/modules" \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    '';
  };
in
{
  home.packages = [ coverpro ];
}
```

### 3. Clean up flake.nix

The `home/home.nix` imports already exist for both files. The only changes needed are in `flake.nix` itself.

**Before** (current `flake.nix`):

```nix
inputs = {
  # ...
  spredux.url = "git+file:///home/john/repos/SPRedux";
  coverpro.url = "git+file:///home/john/repos/coverpro";
};

outputs = { ..., spredux, coverpro, ... }:
```

**After**:

```nix
inputs = {
  # ... (spredux and coverpro removed)
};

outputs = { ..., ... }:  # spredux and coverpro removed
```

Also remove `spredux` and `coverpro` from every `extraSpecialArgs` and `specialArgs` block (Sed, Zed, and iso).

---

## Rebuild Workflow

Whenever you change either app:

```bash
# 1. Build the binary in the app's dev shell
cd ~/repos/SPRedux   # or ~/repos/coverpro/app
nix develop
bun install
cargo tauri build --no-bundle

# 2. Re-tar it
tar czf ~/spredux.tar.gz -C src-tauri/target/release spredux

# 3. Rebuild NixOS (the derivation picks up the new tarball)
cd ~/repos/config
sudo nixos-rebuild switch --flake .#Sed
```

---

## Notes

- The tarballs live at `~/spredux.tar.gz` and `~/coverpro.tar.gz`. Move them wherever you want, just update the `src` path in the nix files.
- The runtime libs list matches what both apps' flakes already declare. If either app adds new native deps, add them to the `makeLibraryPath` list.
- `cargo tauri build --no-bundle` builds the binary with the frontend embedded but skips creating deb/rpm packages.
- The `wrapProgram` call handles all the GTK/WebKit/Wayland runtime deps so the binary works outside the dev shell.
