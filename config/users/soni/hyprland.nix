{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "alacritty";
    "$fileManager" = "dolphin";
    "$menu" = "anyrun";

    "$mod" = "SUPER";

    monitor = [
      "HDMI-A-1, 1920x1080@120, 0x180, 1"
      "DP-2, 3440x1440@165, 1920x0, 1"
      "DP-1, 1920x1080@144, 5360x180, 1"
    ];

    exec-once = [
      "hyprpanel"
      "swaybg --image ~/.local/share/wallpapers/avery.jpeg --mode fill"
    ];

    #env = [
    #  "XCURSOR_SIZE,24"
    #  "HYPRCURSOR_SIZE,24"
    #  "ELECTRON_OZONE_PLATFORM_HINT,auto"
    #];

    general = {
      gaps_in = "5";
      gaps_out = "8, 15, 15, 15";
      border_size = "3";

      "col.active_border" = "$blue";
      "col.inactive_border" = "$surface1";

      resize_on_border = false;
      allow_tearing = false;

      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      active_opacity = "1.0";
      inactive_opacity = "1.0";

      shadow = {
        enabled = true;
	range = 10;
	render_power = 4;
	color = "rgba(1a1a1aee)";
      };

      blur = {
        enabled = true;
	size = 3;
	passes = 1;
	vibrancy = "0.1696";
      };
    };

    animations = {
      enabled = true;
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
    };

    input = {
      kb_layout = "us";
      follow_mouse = 1;
      accel_profile = "flat";
      sensitivity = "-0.4";

      touchpad = {
        natural_scroll = false;
      };
    };

    bind = [
      "$mod, return, exec, $terminal"
      "$mod SHIFT, Q, killactive"
      "$mod, M, exit"
      "$mod, E, exec, $fileManager"
      "$mod, F, togglefloating"
      "$mod, D, exec, $menu"
      "$mod, P, pseudo"
      "$mod, J, togglesplit"
      "$mod SHIFT, F, fullscreen"
      # Move focus
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      # Move windows
      "$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"
      # Switch workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"
      # Move window to workspace
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"
      # Scroll thru workspaces
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
      # Screenshotting
      "$mod SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    windowrulev2 = [
      "suppressevent maximize, class:.*"
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    ];

    workspace = [
      "1, monitor:HDMI-A-1, default:true"
      "2, monitor:HDMI-A-1"
      "3, monitor:DP-2, default:true"
      "4, monitor:DP-2"
      "5, monitor:DP-1, default:true"
      "6, monitor:DP-1"
    ];
  };

  # Environment variables
  home.sessionVariables = {
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}

