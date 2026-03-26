# Security Hardening Design

**Date:** 2026-03-26
**Scope:** NixOS configuration — desktop and proxmox hosts
**Approach:** Option B — Network + safe kernel hardening

## Context

Security audit identified the following issues to address:

- `modules/security.nix` is nearly empty (only sudo cosmetic options)
- No fail2ban on any host
- Unused kernel protocols loaded (DCCP, SCTP, RDS, TIPC) — common exploit vectors
- `ssh-server.nix` allows root login and X11 forwarding
- No opt-in hardening module for internet-facing hosts (firewall, key-only SSH)

The proxmox host is currently internal-only, so key-only SSH is not enforced yet. The `hardening.nix` module is designed to be imported once SSH keys are set up.

## Design

### 1. `modules/security.nix` — applied to all hosts

Expanded with:

**Kernel sysctl parameters (`boot.kernel.sysctl`):**
- `kernel.kptr_restrict = 2` — hides kernel pointer addresses from all users
- `kernel.dmesg_restrict = 1` — restricts `dmesg` to root only
- `kernel.unprivileged_bpf_disabled = 1` — prevents unprivileged BPF programs
- `net.core.bpf_jit_harden = 2` — hardens BPF JIT compiler
- `kernel.yama.ptrace_scope = 1` — restricts ptrace to parent processes only
- `net.ipv4.conf.all.rp_filter = 1` — reverse path filtering (blocks spoofed packets)
- `net.ipv4.conf.all.log_martians = true` — logs packets from impossible addresses
- `net.ipv4.tcp_syncookies = true` — SYN flood protection

**System hardening:**
- `security.forcePageTableIsolation = true` — explicit Meltdown mitigation (KPTI)
- `boot.blacklistedKernelModules = [ "dccp" "sctp" "rds" "tipc" ]` — disable unused network protocols

**Sudo hardening (added to `extraConfig`):**
- `Defaults timestamp_timeout=15` — reduce sudo cache from infinite to 15 minutes
- `Defaults log_output` — log all sudo session output
- `Defaults use_pty` — force pseudo-terminal (prevents some escalation techniques)

**Fail2ban:**
- `services.fail2ban.enable = true` — default config; applied everywhere, harmless on hosts without exposed services

### 2. `modules/options/ssh-server.nix` — safe base SSH defaults

The following settings are added to the existing `settings` block alongside `AllowUsers`:
- `PermitRootLogin = "no"`
- `X11Forwarding = false`
- `ClientAliveInterval = 300`
- `ClientAliveCountMax = 2`

### 3. `modules/options/hardening.nix` — new opt-in module for internet-facing hosts

Layers stricter settings on top of the base config. Does not enable SSH itself.

**Firewall:**
- `networking.firewall.enable = true`
- `networking.firewall.allowedTCPPorts = [ 22 ]` — SSH only; hosts add more ports in their own config
- `networking.firewall.logRefusedConnections = false` — avoids log spam from internet noise

**SSH (stricter settings only):**
- `PasswordAuthentication = false` — key-only auth
- `MaxAuthTries = 3`

## Host Import Plan

| Host | Changes |
|---|---|
| `desktop` | Picks up `security.nix` changes automatically (already imported) |
| `proxmox` | Picks up `security.nix` changes automatically; `hardening.nix` **not imported yet** — wait until SSH keys are configured |

## Out of Scope

- Docker hardening / rootless mode — only one user per host, risk accepted
- `security.lockKernelModules` — would break KVM/driver loading
- AppArmor/SELinux — not worth the complexity for personal use
- Kernel module signing enforcement

## Notes

- `hardening.nix` should be imported on any future internet-facing host via `../../modules/options/hardening.nix`
- When SSH keys are set up on proxmox, add `../../modules/options/hardening.nix` to `hosts/proxmox/configuration.nix` imports and remove password auth
