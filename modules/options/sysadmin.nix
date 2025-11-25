{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    dig
    remmina
  ];
}

