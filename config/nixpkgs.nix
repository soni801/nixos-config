{ inputs, pkgs, ... }:

{
  nixpkgs.config = { allowUnfree = true; };

  nixpkgs.overlays = [
    (final: prev: {
      nvchad = inputs.nix4nvchad.packages."${pkgs.system}".nvchad;
    })
  ];
}
