{ inputs, pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    # Games
    clonehero
    tetrio-desktop

    # Remote gaming
    parsec-bin

    # Modrinth requires a silly fix
    # https://github.com/NixOS/nixpkgs/issues/359820#issuecomment-2601110696
    (modrinth-app.overrideAttrs (oldAttrs: {
      buildCommand = ''
        gappsWrapperArgs+=(
          --set GDK_BACKEND x11
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        )
      ''
      + oldAttrs.buildCommand;
    }))
  ];

  # Steam
  programs.steam.enable = true;
}

