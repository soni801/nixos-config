{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    # GitHub CLI
    gh

    # Toolchains
    nodejs_22
    rustup
    libgcc

    # JetBrains apps
    jetbrains.datagrip
    jetbrains.gateway
    jetbrains.rust-rover
    jetbrains.webstorm

    # Desktop app
    postman

    # Visual Studio Code
    vscode
  ];
}

