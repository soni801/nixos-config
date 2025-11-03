{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    clonehero
    tetrio-desktop
  ];

  # Programs
  programs.steam.enable = true;
}
