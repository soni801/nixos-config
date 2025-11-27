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

      require("base46").compile()
      require("base46").load_all_highlights()
    '';
    chadrcConfig = ''
      local M = {}

      M.base46 = {
        theme = "catppuccin"
      }

      M.ui = {
        cmp = {
          icons_left = true
        }
      }

      M.nvdash = {
        load_on_startup = true
      }

      return M
    '';
  };
}

