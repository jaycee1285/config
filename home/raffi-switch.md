# Switching to Raffi

## What Changed

| File | Change |
|------|--------|
| `home/raffi.nix` | New module with raffi config and helper scripts |
| `home/apps.nix` | Added `raffi` package |
| `home/home.nix` | Added `./raffi.nix` to imports |

## Consolidated Scripts

| Old Script | Raffi Entry | Notes |
|------------|-------------|-------|
| `fz.sh` | Removed | Raffi handles unified menu |
| `fz-power.sh` | `lock`, `logout`, `suspend`, `reboot`, `shutdown` | Individual entries with icons |
| `fz-clip.sh` | `clipboard` | Inline script |
| `fz-search.sh` | `search` | Inline script |
| `fz-bookmarks.sh` | `bookmarks` | External script (SQLite) |
| `fz-files.sh` | `files` | External script (multi-step) |
| `barswitch.sh` | `waybar-restart` | Inline script |

## Next Steps

1. **Build and test**:
   ```bash
   sudo nixos-rebuild switch --flake .#Sed
   ```

2. **Clean up scripts.nix** - remove these entries:
   - `fz.sh`
   - `fz-bookmarks.sh`
   - `fz-clip.sh`
   - `fz-search.sh`
   - `fz-files.sh`
   - `fz-power.sh`

3. **Update LabWC keybindings** - change `fz` to `rf`

## Commands


- `rf` — Launch raffi (full menu)
- `rf-power` — Power menu only

## Not Migrated
rr
- `fuzzwall.sh` — Too interactive (theme picker with prompts), keep as standalone
