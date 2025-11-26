{ pkgs, ... }:

{
  # Install shell stuff
  environment.systemPackages = with pkgs; [
    # Interactive replacements for coreutils
    bat
    eza

    # Eye candy
    fastfetch

    # Utilities
    fzf
    tealdeer
  ];

  programs = {
    tmux.enable = true;
    htop.enable = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableBashCompletion = true;
      loginShellInit = ''
        tldr --update
      '';
      shellAliases = {
        ls = "eza -F -aa --icons --hyperlink";
        cat = "bat";
        vim = "nvim";
        gl = "git log --oneline --graph --all";
      };
      ohMyZsh = {
        enable = true;
        theme = "refined";
        plugins = [
          "colored-man-pages"
          "docker-compose"
          "docker"
          "rust"
          "ssh"
        ];
      };
      setOptions = [
        "APPENDHISTORY"
        "SHAREHISTORY"
        "HIST_IGNORE_ALL_DUPS"
        "HIST_SAVE_NO_DUPS"
        "HIST_IGNORE_DUPS"
        "HIST_FIND_NO_DUPS"
      ];
    };
  };
}

