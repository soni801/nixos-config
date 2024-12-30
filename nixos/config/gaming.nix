{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    clonehero
    modrinth-app
    tetrio-desktop
  ];

  # Fix Modrinth segfault on launch
  nixpkgs.overlays = [
    ( import ../../overlays/modrinth-app.nix )
  ];

  # Programs
  programs.steam.enable = true;
}
