{ ... }:

{
  programs.alacritty = {
    enable = true;
    theme = "catppuccin_mocha";
    settings = {
      window = {
        opacity = 0.98;
        blur = true;
      };

      env = {
        TERM = "xterm-256color";
      };

      font.normal.family = "JetBrainsMono Nerd Font";
    };
  };
}

