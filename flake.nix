{
  description = "Soni's flake :D";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    polymc.url = "github:PolyMC/PolyMC";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [ ./nixos/nixos.nix ];
        };

	headless = nixpkgs.lib.nixosSystem {
	  specialArgs = { inherit system inputs; };
	  modules = [ ./nixos/headless.nix ];
	};
      };
    };
}
