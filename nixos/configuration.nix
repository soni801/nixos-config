# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports = [
    # Import other config files
    ./config/desktop.nix
    ./config/development.nix
    ./config/gaming.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # This is needed to get video output on Hyper-V
  #boot.kernelParams = [ "nomodeset" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.soni = {
    isNormalUser = true;
    description = "Soni";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ ];
  };

  # Set extra sudo options
  security.sudo.extraConfig = ''
    Defaults	pwfeedback
    Defaults	insults
  '';

  # Enable Yubikey login
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  security.pam.u2f.settings = {
    cue = true;
    interactive = true;
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Remove old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Nixpkgs
    bat
    delta
    dust
    eza
    fastfetch
    fzf
    pinentry-curses
    tealdeer
    wakelan
    wineWowPackages.stable
    yt-dlp
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  programs = {
    git.enable = true;
    tmux.enable = true;
    htop.enable = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ls = "eza -F -aa --icons --hyperlink";
        cat = "bat";
      };
      ohMyZsh = {
        enable = true;
        theme = "refined";
        plugins =
          [ "colored-man-pages" "docker-compose" "docker" "rust" "ssh" ];
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
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  nixpkgs.config = { allowUnfree = true; };
  nixpkgs.overlays = [ inputs.hyprpanel.overlay inputs.polymc.overlay ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
