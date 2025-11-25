{ ... }:

{
  # Time zone
  time.timeZone = "Europe/Oslo";

  # Internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}

