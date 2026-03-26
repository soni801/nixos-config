# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

```bash
# Rebuild and switch (desktop host)
sudo nixos-rebuild switch --flake .#desktop

# Rebuild and switch (proxmox host)
sudo nixos-rebuild switch --flake .#proxmox

# Test a build without activating it
sudo nixos-rebuild test --flake .#desktop

# Update flake inputs
nix flake update

# Update a single input
nix flake update nixpkgs

# Check flake outputs
nix flake show

# Build without switching (dry run check)
sudo nixos-rebuild dry-run --flake .#desktop

# Garbage collect
sudo nix-collect-garbage -d
```

## Architecture Overview

This is a NixOS flake-based configuration for two hosts. The top-level entry points are:

- **`flake.nix`** — defines inputs (nixpkgs unstable, hyprland, zen-browser, home-manager, nix4nvchad) and two `nixosConfigurations`: `desktop` and `proxmox`.
- **`home-manager.nix`** — integrates home-manager as a NixOS module. Auto-discovers users by scanning the `users/` directory; any subdirectory with a `configuration.nix` is registered automatically.

### Import Hierarchy

```
flake.nix
└── hosts/<hostname>/configuration.nix
    ├── modules/git.nix             # git + GPG + delta
    ├── modules/nix-options.nix     # flakes, GC, unfree, nix4nvchad overlay
    ├── modules/region.nix          # timezone, locale, keymap
    ├── modules/security.nix        # sudo tweaks
    ├── modules/network/(dynamic|static).nix
    ├── modules/options/*.nix       # feature modules, selectively imported
    ├── home-manager.nix            # auto-discovers users/
    │   └── users/<user>/configuration.nix
    │       └── users/<user>/*.nix  # app configs (alacritty, hyprland, etc.)
    └── hosts/<hostname>/hardware-configuration.nix
```

### Hosts

| Host | Hostname | User | Profile |
|------|----------|------|---------|
| `desktop` | `sa-nix-01` | `soni` | Full desktop: Hyprland, dev tools, gaming, docker, VMs |
| `proxmox` | `nixos-proxmox` | `samuel` | Headless: docker, shell, ssh-server, static IP |

The proxmox host has no home-manager / desktop environment.

### Module Categories

- **`modules/`** — core modules always imported by both hosts (git, nix-options, region, security).
- **`modules/network/`** — choose one: `dynamic.nix` (NetworkManager/DHCP) or `static.nix` (manual IP on `ens18`).
- **`modules/options/`** — feature-gated modules imported selectively per host. Each file is self-contained and enables exactly one feature (bluetooth, docker, gaming, shell, desktop, yubikey, etc.).

### Adding a New Feature

1. Create `modules/options/<feature>.nix` with the NixOS config.
2. Import it in the relevant `hosts/<hostname>/configuration.nix`.

### Adding a New User

Create `users/<username>/configuration.nix` — home-manager will discover it automatically on the next rebuild. The user must still be declared as a NixOS user in the host configuration.

### Home Manager User Config (`users/soni/`)

- `configuration.nix` — base: sets `home.username`, `home.homeDirectory`, imports app configs.
- `alacritty.nix` — terminal (Catppuccin Mocha, JetBrainsMono).
- `editor.nix` — NVChad via nix4nvchad flake input with Catppuccin theme.
- `hyprland.nix` — full Hyprland config: 3-monitor layout, keybindings, workspace assignments.
- `hyprpanel.nix` — top bar: workspaces, clock, CPU/RAM/network, media, systray.

### Key Design Decisions

- **nixpkgs-unstable**: All packages track the unstable channel.
- **nix4nvchad overlay**: Applied in `nix-options.nix` so `pkgs.nvchad` is available everywhere.
- **`inputs` passed as `specialArgs`**: Both `system` and `inputs` are available in all NixOS and home-manager modules.
- **Static IP placeholder**: `modules/network/static.nix` contains `0.0.0.0` placeholders that must be set at deployment.
