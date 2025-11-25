{ pkgs, ... }:

{
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

