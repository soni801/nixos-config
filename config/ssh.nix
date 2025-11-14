{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "samuel" ];
    };
  };
}
