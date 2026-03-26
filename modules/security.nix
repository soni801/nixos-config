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
    # Restrict ptrace to process ancestors only (stops process injection)
    "kernel.yama.ptrace_scope" = 1;
    # Reverse path filtering — blocks spoofed packets
    "net.ipv4.conf.all.rp_filter" = 1;
    # Log packets arriving from impossible addresses
    "net.ipv4.conf.all.log_martians" = 1;
    # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
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
