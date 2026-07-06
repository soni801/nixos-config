{ pkgs, ... }:

{
  # Use Hyprpaper for setting wallpaper
  # procps provides pgrep, used by the wallpaper-daynight.sh script below
  environment.systemPackages = with pkgs; [
    hyprpaper
  ];

  # Create wallpaper folder
  environment.etc."wallpapers" = {
    source = ../../wallpapers;
  };

  # Create cycle script
  environment.etc."scripts/wallpaper-daynight.sh" = {
    source = pkgs.writeShellScript "wallpaper-daynight.sh" ''
      #!/bin/sh

      # Wait for hyprpaper
      while ! pgrep -x hyprpaper >/dev/null; do
        sleep 1
      done
      sleep 2

      HOUR=$(date +%H)

      if   [ "$HOUR" -ge 0 ] && [ "$HOUR" -le 5 ]; then
        WALL="/etc/wallpapers/tropic_island_night.jpg"
      elif [ "$HOUR" -ge 6 ] && [ "$HOUR" -le 9 ]; then
        WALL="/etc/wallpapers/tropic_island_morning.jpg"
      elif [ "$HOUR" -ge 10 ] && [ "$HOUR" -le 17 ]; then
        WALL="/etc/wallpapers/tropic_island_day.jpg"
      else
        WALL="/etc/wallpapers/tropic_island_evening.jpg"
      fi

      hyprctl hyprpaper wallpaper ",$WALL"
    '';
    mode = "0755";
  };

  # Systemd units
  systemd.user.services.wallpaper-daynight = {
    description = "Hyprland 4-period wallpaper switcher";
    wantedBy = [ "graphical-session.target" ];
    # NixOS gives units a minimal default PATH (coreutils/findutils/gnugrep/
    # gnused/systemd) that doesn't include /run/current-system/sw/bin, so
    # pgrep (procps) and hyprctl (hyprland) must be added explicitly here.
    path = with pkgs; [ procps hyprland ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/etc/scripts/wallpaper-daynight.sh";
    };
  };

  systemd.user.timers.wallpaper-daynight = {
    description = "Run wallpaper switcher hourly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "10s";
      OnUnitActiveSec = "1h";
      Persistent = true;
    };
  };
}

