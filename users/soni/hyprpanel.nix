{ inputs, ... }:

{
  programs.hyprpanel = {
    enable = true;
    # See 'https://hyprpanel.com/configuration/settings.html'.
    settings = {
      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      bar.layouts = {
        "*" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [
            "clock"
            "cpu"
            "ram"
          ];
          right = [
            "netstat"
            "media"
            "volume"
            "systray"
            "power"
          ];
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      bar.windowtitle = {
        custom_title = false;
        class_name = false;
        truncation = true;
      };

      bar.clock.format = "%a %d. %b %H:%M:%S";

      bar.customModules.netstat = {
        # TODO: Figure out a way to specify this as a unicode escape sequence
        icon = "󰈀";
        networkInLabel = "";
        networkOutLabel = "";
      };

      menus.clock = {
        time.military = true;
        weather.unit = "metric";
      };

      theme.bar = {
        outer_spacing = "0.2em";
        floating = true;
        margin_sides = "15px";
        border_radius = "10px";
      };

      theme.font = {
        name = "Roboto";
        label = "Roboto";
      };
    };
  };
}

