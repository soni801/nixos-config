{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.nvchad.enable = true;

  environment.variables.EDITOR = "nvim";
}
