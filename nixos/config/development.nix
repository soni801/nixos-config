{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    # CLI apps
    gh

    # Toolchains
    nodejs_22
    rustup

    # Desktop apps
    jetbrains-toolbox
    postman
    vscode
  ];
}
