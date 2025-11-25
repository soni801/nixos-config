{ ... }:

{
  # Enable Yubikey login
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  security.pam.u2f.settings = {
    cue = true;
    interactive = true;
  };

  services.pcscd.enable = true;
}
