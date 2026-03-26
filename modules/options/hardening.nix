{ ... }:

{
  # Firewall — allow SSH only; hosts needing more ports add them in their own configuration.nix
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    logRefusedConnections = false;
  };

  # Stricter SSH for internet-facing hosts — layers on top of ssh-server.nix
  services.openssh.settings = {
    # Auth
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    MaxAuthTries = 3;
    MaxSessions = 3;
    LoginGraceTime = 30;

    # Disable unnecessary forwarding
    AllowAgentForwarding = false;
    AllowTcpForwarding = false;

    # Verbose logging for audit trail
    LogLevel = "VERBOSE";

    # Strong cryptography only
    KexAlgorithms = "curve25519-sha256,curve25519-sha256@libssh.org,sntrup761x25519-sha512@openssh.com";
    Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com";
    Macs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com";
    HostKeyAlgorithms = "ssh-ed25519,ssh-ed25519-cert-v01@openssh.com";
  };
}
