{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "samuel" ];
      PermitRootLogin = "no";
      X11Forwarding = false;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };
}
