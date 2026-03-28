{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    legcord # Modified Discord client
    slack
  ];
}

