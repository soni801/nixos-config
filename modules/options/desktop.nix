{ inputs, pkgs, system, ... }:

{
  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enrionment variables
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Fix electron frame pacing

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono 
    roboto
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    # Terminal emulator
    alacritty

    # Application runner
    anyrun

    # Chatting
    legcord

    # File manager
    nautilus

    # Password manager
    proton-pass

    # AirPlay server
    rpiplay

    # Wayland clipboard
    wl-clipboard

    # Screenshotting
    grim
    slurp

    # Hyprland packages
    hyprpanel
    hyprpolkitagent
    swaybg

    # Browser
    inputs.zen-browser.packages."${system}".default
  ];

  # Programs
  programs = {
    # Disk manager
    partition-manager.enable = true;
    
    # Hyprland
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };

    # Recording/streaming
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}

