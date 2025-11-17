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
    jetbrains.datagrip
    jetbrains.gateway
    jetbrains.rust-rover
    jetbrains.webstorm

    # Desktop apps
    postman
    vscode
  ];
}
