{ system, inputs, lib, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";

      home-manager.extraSpecialArgs = {
        inherit system inputs;
      };

      # Auto configure users from dirctory
      home-manager.users =
      let
        users = (builtins.attrNames (lib.filterAttrs (n: _: n != "default.nix" && !lib.hasPrefix "." n)
          (builtins.readDir ./users/.)));
      in
        builtins.listToAttrs (builtins.map (user: {
          name = user;
          value = ./users/${user}/configuration.nix;
        }) users);
    }
  ];
}

