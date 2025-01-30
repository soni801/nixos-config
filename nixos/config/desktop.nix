{ inputs, pkgs, system, ... }:

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

  # Fonts
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono roboto ];

  # Packages
  environment.systemPackages = with pkgs; [
    # Nixpkgs
    alacritty
    anyrun
    legcord
    parsec-bin
    proton-pass
    rpiplay
    wl-clipboard

    # Stuff for Hyprland
    grim
    hyprpanel
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
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
