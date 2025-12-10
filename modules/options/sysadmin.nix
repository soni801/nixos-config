{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    adoptopenjdk-icedtea-web
    dig
    remmina
  ];
}

