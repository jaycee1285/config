# Claude Instructions for This Repository

> This file provides context and instructions for Claude Code when working on this project.

## Project Overview

This is a NixOS configuration repository with:
- **Flake-based NixOS** configuration for hosts Sed and Zed
- **Home Manager** integration for user-level config
- **LabWC** Wayland compositor with Waybar and Fuzzel
- **Custom packages** (Ferrite, SPRedux, Helium, etc.)
- **Emergency ISO** for recovery/installation

## Key Paths

| Path | Purpose |
|------|---------|
| `flake.nix` | Main flake with host definitions |
| `home/home.nix` | Home Manager entry point |
| `home/*.nix` | Individual HM modules |
| `modules/*.nix` | System-level NixOS modules |
| `hosts/Sed/` | Primary host configuration |
| `hosts/Zed/` | Secondary/backup host |
| `iso.nix` | Emergency ISO configuration |

## Owner

- GitHub: jaycee1285
- User: john

---

## Documentation Requirements

**IMPORTANT:** When creating or updating documentation for this project, follow the Obsidian integration instructions in `.claude/obsidian-docs.md`.

### Quick Summary

1. **Documentation lives in Obsidian** at `~/Sync/JMC/SideProjects/NixOS-Config/`
2. **All markdown files need frontmatter** with `type`, `title`, etc.
3. **Update project status** when completing tasks
4. **Create reference docs** for new features

### After Completing Work

Always update the Obsidian project file:

```bash
# Project file location
~/Sync/JMC/SideProjects/NixOS-Config/NixOS Config.md
```

Update these frontmatter fields:
- `last-completed`: What you just finished
- `next-tasks`: Remove completed, add new discoveries
- `blockers`: Set if you need human input

### Creating New Docs

Put them in `~/Sync/JMC/SideProjects/NixOS-Config/` with frontmatter:

```yaml
---
type: reference
parent: "[[NixOS Config]]"
created: YYYY-MM-DD
tags:
  - nixos
---
```

---

## Build Commands

```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#Sed

# Build without switching (test)
nixos-rebuild build --flake .#Sed

# Build emergency ISO
nix build .#nixosConfigurations.iso.config.system.build.isoImage

# Update flake inputs
nix flake update

# Check flake
nix flake check
```

---

## Current State / Known Issues

See `~/Sync/JMC/SideProjects/NixOS-Config/Simplification Review.md` for:
- Duplicate packages to remove
- Sed/Zed argument mismatch in flake.nix
- Orphaned files to clean up

---

## Conventions

### Nix Style
- Use `pkgs.unstable.package` for bleeding-edge packages
- Prefer Home Manager modules over system packages when possible
- Use `mkOutOfStoreSymlink` for configs that need live editing

### Git
- Commit messages: imperative mood, concise
- Don't commit secrets or credentials

### When Adding Packages
1. Check if it exists in nixpkgs first
2. If packaging manually, create `home/packagename.nix`
3. Add import to `home/home.nix`
4. Document in Obsidian if significant
