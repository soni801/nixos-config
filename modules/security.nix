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
    ignoreIP = [
      # "127.0.0.1/8"
    ];
  };
}
