{ lib, ... }:

{
  # IPv4 address
  networking.interfaces.ens18.ipv4.addresses = [
    {
      address = "0.0.0.0";
      prefixLength = 24;
    }
  ];

  # Options
  networking.defaultGateway = "0.0.0.0";
  networking.nameservers = [ "0.0.0.0" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # System architecture
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

