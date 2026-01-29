# NixOS Configuration Simplification Review

## Executive Summary

This document identifies redundancies, duplicates, and opportunities for simplification in your NixOS/home-manager flake configuration. Special attention is given to TUI vs GUI alternatives for reducing RAM usage.

---

## Progress Tracker

*Last updated: 2026-01-27*

### Completed
- [x] `modules/nemo.nix` deleted (unstaged - run `git add -u` to stage)
- [x] `harper` duplicate removed (only 1 occurrence now)
- [x] Host files unified (`hosts/Sed/default.nix` and `hosts/Zed/default.nix` are identical except hostname)

### In Progress / Remaining
- [ ] **CRITICAL:** Fix `flake.nix` argument mismatch between Sed and Zed (see Section 9)
- [ ] Remove 4 remaining duplicate packages
- [ ] Delete orphaned files (`autohidpi*`, `home/firefox.nix`)
- [ ] Remove redundant `swaylock-fancy`

---

## 1. Duplicate Packages (System Level)

These packages appear multiple times in `modules/packages.nix`:

| Package | Occurrences | Lines | Status |
|---------|-------------|-------|--------|
| `labwc-menu-generator` | 2 | 93, 101 | **Still duplicated** |
| `harper` | ~~2~~ 1 | 86 | **Fixed** |
| `gowall` | 2 | 97, 154 | **Still duplicated** |
| `jq` | 2 | 34, 201 | **Still duplicated** |
| `kdePackages.qtstyleplugin-kvantum` | 2 | 38, 225 | **Still duplicated** |

---

## 2. Duplicate Services

These services are enabled in multiple modules:

| Service | Location 1 | Location 2 | Recommendation |
|---------|-----------|------------|----------------|
| `gvfs` | `modules/services.nix:6` | `modules/nemo.nix:4` | Keep in services.nix only (nemo.nix is disabled anyway) |
| `tumbler` | `modules/services.nix:5` | `modules/nemo.nix:5` | Keep in services.nix only |
| `flatpak` | `modules/flatpak.nix:3` | `modules/services.nix:14` | Keep in flatpak.nix only, remove from services.nix |

---

## 3. Apps Doing the Same Thing

### 3.1 Code Editors

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **helix** | TUI | ~50MB | LSP, modal editing, built-in | **Keep (primary TUI)** |
| **vscodium** | GUI | ~400-800MB | Extensions, debugging, git | Keep if GUI needed |
| **kate** | GUI | ~150MB | KDE editor, basic | Remove (redundant with VSCodium) |
| **fresh-editor** | GUI | ~100MB | Minimal | Remove (redundant) |
| **opencode** | TUI | ~30MB | AI-powered | Evaluate vs helix |
| **codex** | TUI | ~30MB | AI CLI | Keep (different purpose - AI) |
| **claude-code** | TUI | ~50MB | AI CLI | Keep (different purpose - AI) |

**Suggested consolidation:** Keep `helix` (TUI), `vscodium` (GUI when needed), and one AI tool (`claude-code` or `codex`).

### 3.2 Markdown/Note Editors

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **obsidian** | GUI | ~300-500MB | Full knowledge base, plugins | Keep if using vault features |
| **marker** | GUI | ~100MB | Simple markdown editor | Remove (redundant) |
| **eloquent** | GUI | ~80MB | Markdown editor | Remove (redundant) |
| **typesetter** | GUI | ~80MB | Markdown/LaTeX | Remove unless LaTeX needed |
| **helix** | TUI | ~50MB | Can edit markdown | **Already included** |

**Suggested consolidation:** Use `helix` for quick edits, keep `obsidian` only if using its knowledge graph/linking features.

### 3.3 Application Launchers

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **fuzzel** | GUI (Wayland) | ~10MB | Fast, simple | **Keep (primary)** |
| **rofi** | GUI (X11/Wayland) | ~15MB | Highly customizable | Remove (fuzzel is sufficient for Wayland) |
| **bemenu** | TUI-style | ~5MB | dmenu clone | Remove (fuzzel is better) |

**Suggested consolidation:** Keep only `fuzzel` for Wayland.

### 3.4 Screenshot Tools

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **flameshot** | GUI | ~50MB | Annotations, upload | Keep if annotations needed |
| **wayscriber** | TUI/CLI | ~10MB | Simple Wayland screenshots | **Keep (lightweight)** |
| **grim + slurp** | CLI | ~5MB | Standard Wayland screenshot | Consider adding (most minimal) |

**Suggested consolidation:** Keep `wayscriber` (or `grim+slurp`), remove `flameshot` unless annotations are essential.

### 3.5 Lock Screens

| App | Interface | RAM Usage | Features | Status |
|-----|-----------|-----------|----------|--------|
| **swaylock-effects** | GUI | ~20MB | Blur, effects | **Keep** |
| **swaylock-fancy** | GUI | ~20MB | Screenshot blur | **Still installed** (line 119) - remove |

**Suggested consolidation:** Keep only `swaylock-effects`. Remove `swaylock-fancy` from line 119 of `modules/packages.nix`.

### 3.6 Notification Daemons

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **mako** | GUI | ~10MB | Minimal, fast | **Keep (lighter)** |
| **sway-notification-center** | GUI | ~30MB | Full notification center | Remove (heavier, mako is sufficient) |

**Suggested consolidation:** Keep only `mako`.

### 3.7 Status Bars

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **waybar** | GUI | ~30MB | Highly configurable | **Keep (primary, already configured)** |
| **sfwbar** | GUI | ~25MB | Taskbar-style | Remove (waybar is configured) |

### 3.8 File Managers

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **nnn** | TUI | ~5MB | Fast, plugins | **Keep (primary TUI)** |
| **thunar** | GUI | ~80MB | XFCE file manager | Keep for GUI needs |
| **bazaar** | GUI | ~100MB | ? | Remove (thunar is better) |
| **collector** | GUI | ~50MB | ? | Evaluate necessity |

### 3.9 Backup/Sync Tools

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **syncthing** | Web/TUI | ~50MB | P2P sync | **Keep** |
| **syncthingtray** | GUI | ~30MB | Tray integration | Remove if not using |
| **pcloud** | GUI | ~100MB | Cloud storage | Keep if using pCloud |
| **duplicati** | GUI | ~200MB | Backup to cloud | Remove (redundant with rclone) |
| **pika-backup** | GUI | ~100MB | Borg frontend | Remove (pick one backup solution) |
| **kopia-ui** | GUI | ~150MB | Snapshot backups | Remove (pick one backup solution) |
| **rclone** | TUI/CLI | ~30MB | Cloud sync | **Already configured in services** |

**Suggested consolidation:** Keep `syncthing` + `rclone`. Remove GUI backup tools unless specific features needed.

### 3.10 Window Managers/Compositors

| App | Interface | RAM Usage | Purpose | Recommendation |
|-----|-----------|-----------|---------|----------------|
| **labwc** | GUI | ~30MB | Primary compositor | **Keep (primary)** |
| **wayfire** | GUI | ~40MB | Plugin-rich compositor | Remove unless using specific plugins |
| **niri** | GUI | ~25MB | Scrolling tiling | Remove unless specific use case |

### 3.11 AI/LLM Tools

| App | Interface | RAM Usage | Features | Recommendation |
|-----|-----------|-----------|----------|----------------|
| **claude-desktop** | GUI | ~300MB | Claude chat | Keep one GUI |
| **cherry-studio** | GUI | ~200MB | Multi-LLM | Remove (redundant) |
| **chatbox** | GUI | ~150MB | Multi-LLM | Remove (redundant) |
| **lmstudio** | GUI | ~500MB | Local models | Keep if running local models |
| **claude-code** | TUI | ~50MB | Claude CLI | **Keep (TUI primary)** |
| **codex** | TUI | ~30MB | OpenAI CLI | Choose one AI CLI |
| **opencode** | TUI | ~30MB | AI editor | Choose one AI CLI |

**Suggested consolidation:** Keep `claude-code` (TUI) and optionally `lmstudio` (local models). Remove other GUI chat apps.

### 3.12 Policy Kit Agents

| App | Current Location | Recommendation |
|-----|-----------------|----------------|
| **polkit-kde-agent** | `modules/packages.nix` | Move to home-manager or keep as system |

Only one polkit agent detected - no duplication here.

---

## 4. Orphaned Files & Directories

| Path | Status | Description | Action |
|------|--------|-------------|--------|
| `autohidpi/` | Staged (A) | Firefox extension source (full git repo) | Delete or add to .gitignore |
| `autohidpi.xpi` | Staged (A) | Packaged extension | Delete |
| `autohidpi.tar.gz` | Staged (A) | Archive | Delete |
| `home/firefox.nix` | Modified | 294 lines, commented out in home.nix | Delete if not returning to Firefox |
| `modules/nemo.nix` | **Deleted** | Was commented out in configuration.nix | **Done** (unstaged, run `git add -u`) |
| `home/steam.nix` | Referenced but missing | Commented import in home.nix | Remove import line |

---

## 5. Move to Home-Manager for Portability

These items are currently in system config but could be moved to home-manager for cross-distro compatibility:

| Item | Current Location | Target | Difficulty | Notes |
|------|-----------------|--------|------------|-------|
| User packages | `modules/packages.nix` | `home/apps.nix` | Easy | Most packages can be user-level |
| Git config | Not present | `home/git.nix` | Easy | Add programs.git |
| Fish shell config | System | `home/fish.nix` | Easy | programs.fish in HM |
| Zellij config | System | `home/zellij.nix` | Easy | programs.zellij in HM |
| Kitty config | System | `home/kitty.nix` | Easy | programs.kitty in HM |
| Helix config | System | `home/helix.nix` | Easy | programs.helix in HM |
| Fuzzel | Partial | `home/fuzzel.nix` | Easy | Already partially there |
| Syncthing | `modules/services.nix` | `home/syncthing.nix` | Medium | services.syncthing in HM |
| Mako | System | `home/mako.nix` | Easy | services.mako in HM |
| Swayidle | System | `home/swayidle.nix` | Easy | services.swayidle in HM |
| Swaylock | System | `home/swaylock.nix` | Easy | programs.swaylock in HM |
| Kanshi | Partial | Complete in HM | Easy | Already using services.kanshi |
| GTK/Qt theming | Mixed | Consolidate in HM | Medium | Partially done |
| Cursor theme | System | `home/theming.nix` | Easy | home.pointerCursor |
| XDG dirs | Not configured | `home/xdg.nix` | Easy | xdg.userDirs in HM |
| Default apps | Not configured | `home/xdg.nix` | Easy | xdg.mimeApps in HM |
| Espanso | System | `home/espanso.nix` | Easy | services.espanso in HM |

### Packages Safe to Move to Home-Manager

These user-facing applications don't need system-level installation:

```
# Development
helix, gh, nodejs-slim, bun, flutter (with modifications)

# Editors & Office
obsidian, marker, kate, abiword

# Media
vlc, inkscape, koreader

# Utilities
nnn, zoxide, eza, television, fclones-gui, qdirstat

# Theming
flavours, matugen, wpgtk, themechanger

# AI Tools
claude-code, codex, opencode, cherry-studio, chatbox

# Internet
qbittorrent, localsend, chawan
```

---

## 6. Summary: Maximum Simplification

### Packages to Remove (Estimated ~15-20 packages)

| Category | Remove | Keep Instead |
|----------|--------|--------------|
| Editors | kate, fresh-editor, marker, eloquent, typesetter | helix (TUI), vscodium (GUI), obsidian (notes) |
| Launchers | rofi, bemenu | fuzzel |
| Screenshots | flameshot | wayscriber |
| Lockscreen | swaylock-fancy | swaylock-effects |
| Notifications | sway-notification-center | mako |
| Status bars | sfwbar | waybar |
| Backup | duplicati, pika-backup, kopia-ui | rclone + syncthing |
| AI GUI | cherry-studio, chatbox | claude-desktop or claude-code |
| Compositors | wayfire, niri | labwc |
| File managers | bazaar | nnn (TUI), thunar (GUI) |

### Services to Deduplicate

| Action | Files | Status |
|--------|-------|--------|
| Remove flatpak enable | `modules/services.nix` (keep in flatpak.nix) | Pending |
| Delete | `modules/nemo.nix` | **Done** |

### Files to Delete

| File | Reason | Status |
|------|--------|--------|
| `autohidpi/`, `autohidpi.xpi`, `autohidpi.tar.gz` | Unused | Pending |
| `home/firefox.nix` | Disabled, using LibreWolf | Pending |
| `modules/nemo.nix` | Disabled, redundant | **Deleted** |

### Estimated RAM Savings

| Change | Estimated Savings |
|--------|-------------------|
| Remove redundant GUI editors | ~300-500MB |
| Remove extra backup GUIs | ~400MB |
| Remove extra AI GUIs | ~400MB |
| Switch to TUI where possible | Variable |
| **Total potential** | **~1-1.5GB** (when running removed apps) |

---

## 7. Recommended TUI Stack for Minimal RAM

For maximum RAM efficiency, consider this TUI-focused workflow:

| Task | TUI App | GUI Alternative (when needed) |
|------|---------|------------------------------|
| Editor | helix | vscodium |
| Files | nnn | thunar |
| Git | lazygit (add) | github-desktop |
| Notes | helix + markdown | obsidian |
| Browser | chawan | zen-browser |
| AI | claude-code | claude-desktop |
| Music | - | consider cmus or ncmpcpp |
| System monitor | btop (add) | - |
| Process viewer | htop (add) | - |

---

## 8. Configuration Architecture Improvements

### 8.1 Host Deduplication

**Status: Host files are now unified!**

Both `hosts/Sed/default.nix` and `hosts/Zed/default.nix` are now identical (only `networking.hostName` differs). However, **the real duplication is in `flake.nix`** where each host has its own config block with slightly different arguments.

**See Section 9 for the critical flake.nix fix and mkHost refactor.**

Example mkHost pattern:
```nix
# In flake.nix, use a function:
mkHost = hostname: nixpkgs.lib.nixosSystem {
  # shared config - single source of truth
  modules = [
    ./hosts/${hostname}
    # ... home-manager config
  ];
  specialArgs = { /* same for all hosts */ };
};
```

### 8.2 Package Organization

Consider splitting `modules/packages.nix` (248 lines) into:
- `modules/packages/cli.nix`
- `modules/packages/gui.nix`
- `modules/packages/dev.nix`
- `modules/packages/media.nix`

This makes it easier to toggle entire categories.

---

## 9. CRITICAL: Sed/Zed Flake Configuration Mismatch

**Problem:** While `hosts/Sed/default.nix` and `hosts/Zed/default.nix` are now identical (good!), **`flake.nix` passes different arguments** to each host. This will cause Zed to fail if any module references the missing inputs.

### Current State in `flake.nix`

| Argument Location | Sed | Zed | Issue |
|-------------------|-----|-----|-------|
| `extraSpecialArgs.walls` | Yes | Yes | OK |
| `extraSpecialArgs.spredux` | Yes | **Missing** | Zed build will fail if referenced |
| `specialArgs.walls` | Yes | **Missing** | Zed build will fail if referenced |

### Fix Option 1: Add Missing Args to Zed (Quick Fix)

In `flake.nix`, update Zed's configuration (around lines 83-91):

```nix
# Zed - extraSpecialArgs (line ~84)
home-manager.extraSpecialArgs = {
  inherit pkgs gtk-themes nixpkgs-unstable labwcchanger-tui nix-vscode-extensions walls spredux;  # Add spredux
  ob-themes = obThemesPkg;
};

# Zed - specialArgs (line ~90)
specialArgs = {
  inherit pkgs nixpkgs-unstable claude-desktop zen-browser helium-nix walls;  # Add walls
  ob-themes = obThemesPkg;
};
```

### Fix Option 2: Use mkHost Function (Recommended - Prevents Future Drift)

Replace the entire `nixosConfigurations` block with:

```nix
let
  mkHost = hostname: nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ./hosts/${hostname}
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = ".bakbuk";
        home-manager.users.john = import ./home/home.nix;
        home-manager.extraSpecialArgs = {
          inherit pkgs gtk-themes nixpkgs-unstable labwcchanger-tui nix-vscode-extensions walls spredux;
          ob-themes = obThemesPkg;
        };
      }
    ];
    specialArgs = {
      inherit pkgs nixpkgs-unstable claude-desktop zen-browser helium-nix walls;
      ob-themes = obThemesPkg;
    };
  };
in {
  nixosConfigurations = {
    Sed = mkHost "Sed";
    Zed = mkHost "Zed";
  };
}
```

**Benefits of mkHost:**
- Single source of truth for host configuration
- Adding a new host = one line (`NewHost = mkHost "NewHost";`)
- No more argument drift between hosts
- Zed becomes a true backup of Sed

---

## Appendix: Quick Reference - What to Do

### CRITICAL (Do First)
- [ ] **Fix flake.nix Sed/Zed mismatch** - Add `spredux` and `walls` to Zed's args OR implement `mkHost` function (see Section 9)

### Immediate Actions (Low Effort)
- [ ] Remove 4 duplicate packages from `modules/packages.nix`:
  - Line 101: `labwc-menu-generator` (keep line 93)
  - Line 154: `gowall` (keep line 97)
  - Line 201: `jq` (keep line 34)
  - Line 225: `kdePackages.qtstyleplugin-kvantum` (keep line 38)
- [ ] Remove `swaylock-fancy` (line 119) - redundant with `swaylock-effects`
- [ ] Delete `autohidpi/` directory and related files (unstage first: `git reset autohidpi*`)
- [ ] Delete or archive `home/firefox.nix`
- [x] ~~Delete `modules/nemo.nix`~~ **Done** (stage with `git add -u`)

### Short-term Actions (Medium Effort)
- [ ] Remove redundant apps (choose one per category from tables above)
- [ ] Move user packages to `home/apps.nix`
- [ ] Add home-manager configs for: fish, helix, kitty, mako, swaylock

### Long-term Actions (Higher Effort)
- [ ] Refactor to `mkHost` function for zero-drift host configs (see Section 9)
- [ ] Split packages.nix into categorized files
- [ ] Full home-manager migration for cross-distro support

---

## Verification: Test Zed Build

After fixing the flake.nix mismatch, verify Zed can build:

```bash
# Dry-run build (no actual switch)
nixos-rebuild build --flake .#Zed

# Or just evaluate
nix eval .#nixosConfigurations.Zed.config.system.build.toplevel
```

If both Sed and Zed build successfully with identical configs, Zed is ready to serve as your backup.
