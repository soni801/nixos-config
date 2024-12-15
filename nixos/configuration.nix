# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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

  # Let's have Plasma in addition to Hyprland just in case
  services.desktopManager.plasma6.enable = true;

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.soni = {
    isNormalUser = true;
    description = "Soni";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  # Set extra sudo options
  security.sudo.extraConfig = "
    Defaults	pwfeedback
    Defaults	insults
  ";

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
    alacritty
    jetbrains-toolbox
    bat
    fzf
    yt-dlp
    tealdeer
    delta
    rustup
    legcord
    nerd-fonts.jetbrains-mono
    postman
    rpiplay
    proton-pass
    vscode
    swaybg
    anyrun
    fastfetch
    eza
    gh
    pinentry-curses
    grim
    slurp
    wl-clipboard
    tetrio-desktop
    clonehero
    modrinth-app
    wineWowPackages.stable

    # Flakes
    inputs.zen-browser.packages."${system}".specific
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
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
    steam.enable = true;
    firefox.enable = true;
    git.enable = true;
    tmux.enable = true;
    htop.enable = true;
    waybar.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
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
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };

  # Enable Docker
  virtualisation.docker.enable = true;

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
