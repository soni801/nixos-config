{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    # CLI apps
    gh

    # Toolchains
    nodejs_22
    rustup

    # JetBrains apps
    jetbrains.webstorm
    jetbrains.gateway
    jetbrains.datagrip

    # Desktop apps
    postman
    vscode
  ];
}
