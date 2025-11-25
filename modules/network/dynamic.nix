{ lib, ... }:

{
  # Use NetworkManager
  networking.networkmanager.enable = true;

  # Wireless networking
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  
  # Explicit per-interface declarations
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # System architecture
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

