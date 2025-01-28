{
  description = "Soni's flake :D";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    polymc.url = "github:PolyMC/PolyMC";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };

      overlays = [
        inputs.hyprpanel.overlay
	inputs.polymc.overlay
      ];
    };
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system pkgs inputs; };

	modules = [
	  ./nixos/configuration.nix
	];
      };
    };
  };
}
