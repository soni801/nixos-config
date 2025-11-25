{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;
    extraConfig = ''
      vim.opt.colorcolumn = "80"
      vim.opt.list = true
      vim.opt.listchars = {
        space = "\u{22C5}",
        tab = "\u{2192}\u{2002}"
      }
    '';
    chadrcConfig = ''
      local M = {}
      M.ui = {theme = 'catppuccin'}
      return M
    '';
  };
  # Set nvim as preferred editor
  home.sessionVariables.EDITOR = "nvim";
}

