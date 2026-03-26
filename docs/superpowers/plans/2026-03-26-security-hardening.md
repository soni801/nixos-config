# Security Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Harden both NixOS hosts with kernel-level protections, fail2ban, sudo logging, and a new opt-in firewall/SSH module for internet-facing deployments.

**Architecture:** Expand `modules/security.nix` (imported by all hosts) with kernel sysctl params, blacklisted protocols, sudo hardening, and fail2ban. Harden `modules/options/ssh-server.nix` with safe base SSH defaults. Create a new `modules/options/hardening.nix` for opt-in use on internet-facing hosts.

**Tech Stack:** NixOS flake configuration (Nix language). No traditional unit tests — validation is `sudo nixos-rebuild dry-run --flake .#<host>` for both hosts after each change.

---

### Task 1: Expand `modules/security.nix` with kernel hardening, sudo hardening, and fail2ban

**Files:**
- Modify: `modules/security.nix`

- [ ] **Step 1: Replace the contents of `modules/security.nix`**

The file currently only has `pwfeedback` and `insults`. Replace it entirely with:

```nix
{ ... }:

{
  # Kernel hardening
  boot.kernel.sysctl = {
    # Hide kernel pointer addresses from all users (prevent info leaks)
    "kernel.kptr_restrict" = 2;
    # Restrict dmesg to root only
    "kernel.dmesg_restrict" = 1;
    # Prevent unprivileged BPF programs (common exploit vector)
    "kernel.unprivileged_bpf_disabled" = 1;
    # Harden BPF JIT compiler
    "net.core.bpf_jit_harden" = 2;
    # Restrict ptrace to parent processes only (stops process injection)
    "kernel.yama.ptrace_scope" = 1;
    # Reverse path filtering — blocks spoofed packets
    "net.ipv4.conf.all.rp_filter" = 1;
    # Log packets arriving from impossible addresses
    "net.ipv4.conf.all.log_martians" = true;
    # SYN flood protection
    "net.ipv4.tcp_syncookies" = true;
  };

  # Meltdown mitigation (KPTI) — explicit, most systems already have this on
  security.forcePageTableIsolation = true;

  # Disable unused network protocol kernel modules (common attack vectors)
  boot.blacklistedKernelModules = [ "dccp" "sctp" "rds" "tipc" ];

  # Sudo hardening
  security.sudo.extraConfig = ''
    Defaults  pwfeedback
    Defaults  insults
    Defaults  timestamp_timeout=15
    Defaults  log_output
    Defaults  use_pty
  '';

  # Intrusion prevention — ban IPs after repeated failed auth attempts
  services.fail2ban.enable = true;
}
```

- [ ] **Step 2: Verify both hosts evaluate without errors**

```bash
sudo nixos-rebuild dry-run --flake .#desktop
sudo nixos-rebuild dry-run --flake .#proxmox
```

Expected: both complete with no errors. If `security.forcePageTableIsolation` is unavailable on your NixOS version, remove that line (it's already on by default on most kernels).

- [ ] **Step 3: Commit**

```bash
git add modules/security.nix
git commit -m "feat(security): add kernel hardening, sudo logging, and fail2ban"
```

---

### Task 2: Harden `modules/options/ssh-server.nix` with safe base defaults

**Files:**
- Modify: `modules/options/ssh-server.nix`

- [ ] **Step 1: Replace the contents of `modules/options/ssh-server.nix`**

The file currently only sets `AllowUsers`. Add safe defaults to the existing `settings` block:

```nix
{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "samuel" ];
      PermitRootLogin = "no";
      X11Forwarding = false;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };
}
```

- [ ] **Step 2: Verify the proxmox host evaluates without errors**

```bash
sudo nixos-rebuild dry-run --flake .#proxmox
```

Expected: completes with no errors. (Desktop does not import ssh-server.nix so only proxmox needs checking here.)

- [ ] **Step 3: Commit**

```bash
git add modules/options/ssh-server.nix
git commit -m "feat(ssh-server): disable root login, X11 forwarding, and add session timeouts"
```

---

### Task 3: Create `modules/options/hardening.nix` for internet-facing hosts

**Files:**
- Create: `modules/options/hardening.nix`

- [ ] **Step 1: Create `modules/options/hardening.nix`**

This module is opt-in only. It does **not** enable SSH — it layers stricter settings on top of `ssh-server.nix`. Import it in a host's `configuration.nix` only after SSH keys are configured.

```nix
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
```

- [ ] **Step 2: Verify the module is syntactically valid by doing a dry-run with a temporary import**

Add `../../modules/options/hardening.nix` to the imports list in `hosts/proxmox/configuration.nix`, run the dry-run, then **remove it again** (it should not be imported until SSH keys are set up):

```bash
# Temporarily add the import, then:
sudo nixos-rebuild dry-run --flake .#proxmox
# Then remove the import line before committing
```

Expected: dry-run completes with no errors.

- [ ] **Step 3: Commit (without the temporary import)**

Ensure `hosts/proxmox/configuration.nix` does **not** have the hardening import before committing:

```bash
git add modules/options/hardening.nix
git commit -m "feat(hardening): add opt-in firewall and key-only SSH module for internet-facing hosts"
```

---

## Usage Note — Activating on Proxmox

When SSH keys are set up on the proxmox host, activate hardening by adding one line to `hosts/proxmox/configuration.nix` imports:

```nix
../../modules/options/hardening.nix
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake .#proxmox
```

The firewall will then allow only port 22, and password auth will be disabled.
