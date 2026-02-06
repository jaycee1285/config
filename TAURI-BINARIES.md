# Tauri Binary Releases

Skip the Nix-sandbox Rust/Tauri build pain. Build binaries in the dev shell, release to GitHub, and have the config flake fetch them.

---

## Architecture

```
GitHub Releases (tar.xz)
        │
        ▼
  tauri.nix (root)         ← mkTauriApp + fetchurl derivations
   ├── home/tauri.nix      ← HM module: both apps in home.packages
   └── iso.nix             ← system module: spredux in environment.systemPackages
```

One shared `tauri.nix` at the repo root defines `mkTauriApp` and both derivations. Home Manager and the ISO import from it.

---

## Release URLs

| App | URL |
|-----|-----|
| CoverPro | `https://github.com/jaycee1285/coverpro/releases/download/v0.1.0/coverpro-v0.1.0-linux-x86_64.tar.xz` |
| SPRedux | `https://github.com/jaycee1285/SPRedux/releases/download/v0.1.0/spredux-v0.1.0-linux-x86_64.tar.xz` |

Pattern: `https://github.com/jaycee1285/<repo>/releases/download/v<version>/<pname>-v<version>-linux-x86_64.tar.xz`

---

## Building + Releasing

Both repos have a `release.sh` that builds, tars, and uploads to GitHub Releases.

### CoverPro

```bash
cd ~/repos/coverpro
./release.sh
# Builds via `bun run tauri build --no-bundle`, tars the binary, uploads to GH release
```

### SPRedux

```bash
cd ~/repos/SPRedux
./release.sh
# Same pattern
```

`release.sh` auto-enters the Nix dev shell if `PKG_CONFIG_PATH` is missing.

---

## Updating the Config Flake

After uploading a new release:

1. Get the new hash:
   ```bash
   nix-prefetch-url --type sha256 https://github.com/jaycee1285/coverpro/releases/download/v0.2.0/coverpro-v0.2.0-linux-x86_64.tar.xz
   ```

2. Update `tauri.nix` at the repo root — change the `version`, `url`, and `hash` for the relevant app.

3. Rebuild:
   ```bash
   cd ~/repos/config
   sudo nixos-rebuild switch --flake .#Sed
   ```

---

## Notes

- The `wrapProgram` call in `tauri.nix` handles all GTK/WebKit/Wayland runtime deps so the binary works outside the dev shell.
- `cargo tauri build --no-bundle` builds the binary with the frontend embedded but skips creating deb/rpm packages.
- If either app adds new native deps, add them to the `makeLibraryPath` list in `tauri.nix`.
- The old approach (flake inputs pointing at local git repos) has been removed. No more `spredux` or `coverpro` in `flake.nix` inputs.
