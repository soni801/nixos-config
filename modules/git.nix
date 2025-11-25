{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Fancier diffs
    delta

    # GPG passphrase entry
    pinentry-curses
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
}

