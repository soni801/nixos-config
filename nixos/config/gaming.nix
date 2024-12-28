{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    clonehero
    modrinth-app
    tetrio-desktop
  ];

  # Programs
  programs.steam.enable = true;
}
