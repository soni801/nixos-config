{
  description = "Soni's flake :D";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-modrinth.url = "github:nixos/nixpkgs/01f116e4df6a15f4ccdffb1bcd41096869fb385c";

    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix4nvchad.url = "github:nix-community/nix4nvchad";
    nix4nvchad.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [ ./hosts/desktop/configuration.nix ];
        };
        proxmox = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [ ./hosts/proxmox/configuration.nix ];
        };
      };
    };
}

