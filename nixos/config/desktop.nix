{ inputs, pkgs, ... }:

{
  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Let's have Plasma in addition to Hyprland just in case
  services.desktopManager.plasma6.enable = true;

  # Attempt fixing electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Packages
  environment.systemPackages = with pkgs; [
    # Nixpkgs
    alacritty
    anyrun
    legcord
    nerd-fonts.jetbrains-mono
    proton-pass
    rpiplay
    wl-clipboard

    # Stuff for Hyprland
    grim
    hyprpolkitagent
    slurp
    swaybg

    # Flakes
    inputs.zen-browser.packages."${system}".specific
  ];

  # Programs
  programs = {
    firefox.enable = true;
    waybar.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
