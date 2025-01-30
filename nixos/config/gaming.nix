{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [ clonehero polymc tetrio-desktop ];

  # Programs
  programs.steam.enable = true;
}
