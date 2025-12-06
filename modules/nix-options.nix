{ inputs, pkgs, ... }:

{
  # Remove old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 524288000;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Overlay for nvchad
  # TODO: Move this somewhere else
  nixpkgs.overlays = [
    (final: prev: {
      nvchad = inputs.nix4nvchad.packages."${pkgs.system}".nvchad;
    })
  ];
}

