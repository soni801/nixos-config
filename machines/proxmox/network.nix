{ lib, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  #networking.useDHCP = lib.mkDefault true;
  networking.interfaces.ens18.ipv4.addresses = [
    {
      address = "0.0.0.0";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "0.0.0.0";
  networking.nameservers = [ "0.0.0.0" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
