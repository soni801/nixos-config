# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports = [
    # Import other config files
    ../../config/desktop.nix
    ../../config/development.nix
    ../../config/gaming.nix
    ../../config/networking.nix
    ../../config/vm.nix
    ../../config/git.nix
    ../../config/nixpkgs.nix

    # Home manager
    ../../config/home-manager.nix

    # Include the results of the hardware scan.
    ./network.nix
    ./hardware-configuration.nix
  ];

  # This is needed to get video output on Hyper-V
  #boot.kernelParams = [ "nomodeset" ];

  networking.hostName = "nixos"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.soni = {
    isNormalUser = true;
    description = "Soni";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # Nixpkgs
    dust
    wakelan
    wineWowPackages.stable
    yt-dlp
  ];

  # This does not belong here but it is fine for now
  environment.variables.EDITOR = "nvim";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
