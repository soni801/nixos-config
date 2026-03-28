{ pkgs, ... }:

{
  # Install shell stuff
  environment.systemPackages = with pkgs; [
    # Interactive replacements for coreutils/builtin commands
    atuin # history
    bat # cat
    eza # ls

    # Eye candy
    fastfetch

    # Utilities
    fzf
    tealdeer
  ];

  programs = {
    tmux = {
      enable = true;
      baseIndex = 1;
      shortcut = "Space";
      plugins = with pkgs.tmuxPlugins; [
        catppuccin
        sensible
        tmux-which-key
        vim-tmux-navigator
      ];
      extraConfig = ''
        set -g mouse on
        bind -n M-H previous-window
        bind -n M-L next-window
      '';
    };
    htop.enable = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableBashCompletion = true;
      loginShellInit = ''
        tldr --update
      '';
      # Immediately start a tmux session in all interactive shells
      # I would love to use this but it became a bit cumersome.
      # Maybe I will come back to improving this in the future.
      #interactiveShellInit = ''
      #  tmux new -A
      #'';
      promptInit = ''
        eval "$(atuin init zsh)"
      '';
      shellAliases = {
        ls = "eza -F -aa --icons --hyperlink";
        cat = "bat";
        vim = "nvim";
        gl = "git log --oneline --graph --all";
        gs = "git status";
        gd = "git diff";
      };
      ohMyZsh = {
        enable = true;
        theme = "refined";
        plugins = [
          "colored-man-pages"
          "docker-compose"
          "docker"
          "gh"
          "ng"
          "rust"
          "safe-paste"
          "ssh"
          "sudo"
        ];
      };
      setOptions = [
        "APPENDHISTORY"
        "SHAREHISTORY"
        "HIST_IGNORE_ALL_DUPS"
        "HIST_SAVE_NO_DUPS"
        "HIST_IGNORE_DUPS"
        "HIST_FIND_NO_DUPS"
        "HIST_IGNORE_SPACE"
      ];
    };
  };
}

