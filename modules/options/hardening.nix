{ ... }:

{
  # Firewall — allow SSH only; hosts needing more ports add them in their own configuration.nix
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    logRefusedConnections = false;
  };

  # Stricter SSH — key-only auth, reduced brute-force window
  services.openssh.settings = {
    PasswordAuthentication = false;
    MaxAuthTries = 3;
  };
}
