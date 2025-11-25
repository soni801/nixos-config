{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.nvchad.enable = true;

  # Set nvim as preferred editor
  home.sessionVariables.EDITOR = "nvim";
}

