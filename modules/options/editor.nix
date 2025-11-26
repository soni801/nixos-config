{ ... }:

{
  # Specify neovim as preferred text editor
  environment.sessionVariables.EDITOR = "nvim";

  # The rest of the configuration needs to be done in home-manager because
  # it is really stupid in the way it handles environment variables.
}

