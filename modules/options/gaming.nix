{ inputs, pkgs, ... }:

{
  # Use an older version of Modrinth because the newest one is broken...
  nixpkgs.overlays = [
    (final: prev:
      let
        modrinthPkgs = import inputs.nixpkgs-modrinth {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      in {
        modrinth-app = modrinthPkgs.modrinth-app;
      }
    )
  ];

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

