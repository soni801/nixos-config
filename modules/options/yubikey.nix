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

  # TODO: Check if I actually need this?
  services.pcscd.enable = true;
}
