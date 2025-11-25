{ pkgs, ... }:

{
  # Add delta package for better diffs
  environment.systemPackages = with pkgs; [
    delta
  ];

  # Configure git
  programs.git = {
    enable = true;
    
    # Use Delta for diffs
    config = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      merge.conflictStyle = "zdiff3";
      delta = {
        navigate = true;
	      line-numbers = true;
	      hyperlinks = true;
      };
    };
  };

  # Configure GPG
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  # Set extra sudo options
  security.sudo.extraConfig = ''
    Defaults	pwfeedback
    Defaults	insults
  '';

  # Remove old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Overlay for nvchad
  # TODO: Move this somewhere else
  nixpkgs.overlays = [
    (final: prev: {
      nvchad = inputs.nix4nvchad.packages."${pkgs.system}".nvchad;
    })
  ];
}

