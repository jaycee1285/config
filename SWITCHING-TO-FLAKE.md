# Switching to the Flake

## Available Hosts

| Host | Description |
|------|-------------|
| Sed  | Primary configured host |
| Zed  | Template host (requires hardware config) |

## Prerequisites

Ensure flakes are enabled in your NixOS configuration. This is already handled by `modules/nix-features.nix`.

## Switching to the Flake

From the repository directory, run:

```bash
# For Sed
sudo nixos-rebuild switch --flake .#Sed

# For Zed
sudo nixos-rebuild switch --flake .#Zed
```

Or from anywhere, using the full path:

```bash
sudo nixos-rebuild switch --flake /home/john/repos/config#Sed
```

## Other Operations

### Test without switching
```bash
sudo nixos-rebuild test --flake .#Sed
```

### Build without activating
```bash
sudo nixos-rebuild build --flake .#Sed
```

### Update flake inputs
```bash
nix flake update
```

### Update a single input
```bash
nix flake update nixpkgs
```

## Repository Structure

```
config/
├── flake.nix              # Main flake definition
├── flake.lock             # Locked input versions
├── hosts/
│   ├── Sed/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── Zed/
│       ├── default.nix
│       └── hardware-configuration.nix  # PLACEHOLDER - needs configuration
├── modules/               # Shared NixOS modules
└── home/                  # Home-manager configuration
```

---

## Setting Up Zed (New Host Guide)

The Zed host contains a placeholder `hardware-configuration.nix` that must be replaced with your actual hardware configuration.

### Step 1: Generate Hardware Configuration

On the target machine, run:

```bash
nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
```

### Step 2: Copy to Repository

Copy the generated file to `hosts/Zed/hardware-configuration.nix`:

```bash
cp /tmp/hardware-configuration.nix /path/to/config/hosts/Zed/hardware-configuration.nix
```

### Step 3: Review the Configuration

Key items to verify in `hardware-configuration.nix`:

- **Kernel modules**: `boot.initrd.availableKernelModules` should include modules for your storage controllers
- **CPU**: Use `kvm-intel` for Intel or `kvm-amd` for AMD
- **Filesystems**: Ensure UUIDs match your disk layout (check with `blkid` or `lsblk -f`)
- **Platform**: `nixpkgs.hostPlatform` should be `x86_64-linux` or `aarch64-linux`
- **Microcode**: Use `hardware.cpu.intel.updateMicrocode` or `hardware.cpu.amd.updateMicrocode`

### Step 4: Stage and Switch

```bash
cd /path/to/config
git add hosts/Zed/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#Zed
```

---

## Adding More Hosts

To add a new host beyond Sed and Zed:

### 1. Create Host Directory

```bash
mkdir -p hosts/NewHost
```

### 2. Copy and Adapt default.nix

```bash
cp hosts/Zed/default.nix hosts/NewHost/default.nix
```

Edit `hosts/NewHost/default.nix` and change the hostname:

```nix
networking.hostName = "NewHost";
```

### 3. Generate Hardware Config

On the target machine:

```bash
nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

Copy to `hosts/NewHost/hardware-configuration.nix`.

### 4. Add to flake.nix

Add a new entry under `nixosConfigurations`:

```nix 
# Host: NewHost
NewHost = nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./hosts/NewHost
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = ".bakbuk";
      home-manager.users.john = import ./home/home.nix;

      home-manager.extraSpecialArgs = {
        inherit pkgs gtk-themes nixpkgs-unstable labwcchanger-tui nix-vscode-extensions;
        ob-themes = obThemesPkg;
      };
    }
  ];
  specialArgs = {
    inherit pkgs gtk-themes nixpkgs-unstable claude-desktop zen-browser helium-nix;
    ob-themes = obThemesPkg;
  };
};
```

### 5. Build and Switch

```bash
git add hosts/NewHost
sudo nixos-rebuild switch --flake .#NewHost
```
