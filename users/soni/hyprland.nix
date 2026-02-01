{ config, pkgs, ... }:

{
  # Enable hyprland config options
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    # Application definitions
    "$terminal" = "alacritty";
    "$fileManager" = "nautilus";
    "$menu" = "anyrun";

    # Modifier key definitions
    "$mod" = "SUPER";

    # Color definitions
    "$rosewater" = "rgb(f5e0dc)";
    "$flamingo" = "rgb(f2cdcd)";
    "$pink" = "rgb(f5c2e7)";
    "$mauve" = "rgb(cba6f7)";
    "$red" = "rgb(f38ba8)";
    "$maroon" = "rgb(eba0ac)";
    "$peach" = "rgb(fab387)";
    "$yellow" = "rgb(f9e2af)";
    "$green" = "rgb(a6e3a1)";
    "$teal" = "rgb(94e2d5)";
    "$sky" = "rgb(89dceb)";
    "$sapphire" = "rgb(74c7ec)";
    "$blue" = "rgb(89b4fa)";
    "$lavender" = "rgb(b4befe)";
    "$text" = "rgb(cdd6f4)";
    "$subtext1" = "rgb(bac2de)";
    "$subtext0" = "rgb(a6adc8)";
    "$overlay2" = "rgb(9399b2)";
    "$overlay1" = "rgb(7f849c)";
    "$overlay0" = "rgb(6c7086)";
    "$surface2" = "rgb(585b70)";
    "$surface1" = "rgb(45475a)";
    "$surface0" = "rgb(313244)";
    "$base" = "rgb(1e1e2e)";
    "$mantle" = "rgb(181825)";
    "$crust" = "rgb(11111b)";

    monitor = [
      "HDMI-A-1, 1920x1080@120, 0x180, 1"
      "DP-2, 3440x1440@165, 1920x0, 1"
      "DP-1, 1920x1080@144, 5360x180, 1"
    ];

    # Autostart necessary processes
    exec-once = [
      "hyprpanel"
      "swaybg --image ~/.local/share/wallpapers/avery.jpeg --mode fill"
      "hyprctl setcursor Banana 40"
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

      layout = "dwindle";
    };

    decoration = {
      rounding = 10;

      shadow = {
        enabled = true;
        range = 10;
        render_power = 4;
        color = "$mantle";
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
      # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      pseudotile = true;

      # You probably want this
      preserve_split = true;
    };

    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master = {
      new_status = "master";
    };

    misc = {
      # Disable the anime mascot wallpapers
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
    };

    input = {
      kb_layout = "us";

      # Mouse sensitivity. -1.0 - 1.0, 0 means no modification.
      sensitivity = "-0.4";
      accel_profile = "flat";
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

      # Move active window to workspace
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

      # Scroll thru existing workspaces with scroll wheel
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Screenshotting
      "$mod SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
    ];

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    windowrule = [
      # Ignore maximize requests from apps. You'll probably like this.
      "suppress_event maximize, match:class .*"

      # Fix some dragging issues with XWayland
      "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
    ];

    # Bind workspaces to specific monitors
    workspace = [
      "1, monitor:HDMI-A-1, default:true"
      "2, monitor:HDMI-A-1"
      "3, monitor:DP-2, default:true"
      "4, monitor:DP-2"
      "5, monitor:DP-1, default:true"
      "6, monitor:DP-1"
    ];

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };
  };
}

