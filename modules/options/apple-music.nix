{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cider-2
  ];
}

