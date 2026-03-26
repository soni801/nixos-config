# Security Hardening Round 2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply a second batch of safe hardening improvements: additional sysctl params, boot hardening params, core dump protection, explicit fail2ban config with timing, SSH crypto hardening for internet-facing hosts, and Nix daemon access restriction.

**Architecture:** Three files are modified. `modules/security.nix` (all hosts) gets additional sysctl entries, boot params, core dump config, and explicit fail2ban timing. `modules/options/hardening.nix` (opt-in) gets SSH crypto restrictions. `modules/nix-options.nix` (all hosts) gets `trusted-users` restriction.

**Tech Stack:** NixOS flake configuration (Nix language). Validation is `sudo nixos-rebuild dry-run --flake .#<host>` on the target NixOS system — not available in this environment, so each task verifies by reading the file back.

---

### Task 1: Expand `modules/security.nix` with additional sysctl, boot params, and core dump protection

**Files:**
- Modify: `modules/security.nix`

- [ ] **Step 1: Replace the full contents of `modules/security.nix`**

The current file has 8 sysctl entries, KPTI, blacklisted modules, sudo config, and fail2ban. Replace it entirely with:

```nix
{ ... }:

{
  # Kernel hardening
  boot.kernel.sysctl = {
    # Hide kernel pointer addresses from all users (prevent info leaks)
    "kernel.kptr_restrict" = 2;
    # Restrict dmesg to root only
    "kernel.dmesg_restrict" = 1;
    # Restrict kernel profiling to root
    "kernel.perf_event_paranoid" = 3;
    # Prevent runtime kernel replacement via kexec
    "kernel.kexec_load_disabled" = 1;
    # Prevent unprivileged BPF programs (common exploit vector)
    "kernel.unprivileged_bpf_disabled" = 1;
    # Harden BPF JIT compiler
    "net.core.bpf_jit_harden" = 2;
    # Restrict ptrace to process ancestors only (stops process injection)
    "kernel.yama.ptrace_scope" = 1;

    # Network hardening
    # Reverse path filtering — blocks spoofed packets
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    # Disable ICMP redirect acceptance and sending (MITM vector; does not affect ping)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Disable source routing
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    # Log packets arriving from impossible addresses
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
    # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
    # Proper TIME-WAIT handling (RFC 1337)
    "net.ipv4.tcp_rfc1337" = 1;
    # Disable TCP timestamps — prevents uptime fingerprinting
    "net.ipv4.tcp_timestamps" = 0;
    # Disable IPv6 ICMP redirect acceptance
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Disable IPv6 router advertisement acceptance (prevents rogue RA attacks)
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;
  };

  # Meltdown mitigation (KPTI) — explicit, most systems already have this on
  security.forcePageTableIsolation = true;

  # Disable unused network protocol kernel modules (common attack vectors)
  boot.blacklistedKernelModules = [ "dccp" "sctp" "rds" "tipc" ];

  # Additional boot-time kernel hardening
  boot.kernelParams = [
    "slab_nomerge"          # Prevent slab merging (blocks heap exploit techniques)
    "init_on_free=1"        # Zero memory on free (defends against use-after-free leaks)
    "page_alloc.shuffle=1"  # Randomise page allocator freelists
    "vsyscall=none"         # Disable legacy vsyscall interface (potential info leak)
    "debugfs=off"           # Disable debugfs (exposes kernel internals)
  ];

  # Core dump protection — prevents credential leakage from crash dumps
  systemd.coredump.extraConfig = "Storage=none";
  security.pam.loginLimits = [
    { domain = "*"; item = "core"; type = "hard"; value = "0"; }
  ];

  # Sudo hardening
  security.sudo.extraConfig = ''
    Defaults  pwfeedback
    Defaults  insults
    Defaults  timestamp_timeout=15
    Defaults  log_output
    Defaults  use_pty
  '';

  # Intrusion prevention — ban IPs after repeated failed auth attempts
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "10m";
    findtime = "10m";
    # ignoreIP = [ "127.0.0.1/8" "your-lan-subnet/24" ];
  };
}
```

- [ ] **Step 2: Read the file back to confirm it was written correctly**

Read `/Users/samuel/GitHub/nixos-config/modules/security.nix` and verify all sections are present.

- [ ] **Step 3: Commit**

```bash
git add modules/security.nix
git commit -m "feat(security): add kernel hardening, kernel boot params, and core dump protection"
```

---

### Task 2: Add SSH crypto hardening to `modules/options/hardening.nix`

**Files:**
- Modify: `modules/options/hardening.nix`

- [ ] **Step 1: Replace the full contents of `modules/options/hardening.nix`**

The current file has firewall config and basic SSH restrictions. Expand the SSH settings block with crypto hardening:

```nix
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
```

- [ ] **Step 2: Read the file back to confirm it was written correctly**

Read `/Users/samuel/GitHub/nixos-config/modules/options/hardening.nix` and verify all sections are present.

- [ ] **Step 3: Commit**

```bash
git add modules/options/hardening.nix
git commit -m "feat(hardening): add SSH crypto hardening and session limits"
```

---

### Task 3: Restrict Nix daemon access in `modules/nix-options.nix`

**Files:**
- Modify: `modules/nix-options.nix`

- [ ] **Step 1: Add `trusted-users` to the existing `nix.settings` block**

The current file has `nix.settings` with `experimental-features` and `download-buffer-size`. Add `trusted-users` to the same block:

```nix
{ inputs, pkgs, ... }:

{
  # Remove old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 524288000;
    # Restrict nix daemon access to wheel group only
    trusted-users = [ "@wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Overlay for nvchad
  # TODO: Move this somewhere else
  nixpkgs.overlays = [
    (final: prev: {
      nvchad = inputs.nix4nvchad.packages."${pkgs.system}".nvchad;
    })
  ];
}
```

- [ ] **Step 2: Read the file back to confirm it was written correctly**

Read `/Users/samuel/GitHub/nixos-config/modules/nix-options.nix` and verify `trusted-users` is present in `nix.settings`.

- [ ] **Step 3: Commit**

```bash
git add modules/nix-options.nix
git commit -m "feat(nix): restrict nix daemon access to wheel group"
```
