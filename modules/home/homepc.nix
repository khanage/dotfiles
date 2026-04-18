{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.homepcHomeManager = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.khan = {
        imports = [
          inputs.nvf.homeManagerModules.default
          self.homeModules.shell
          self.homeModules.nvim
          self.homeModules.gaming
          self.homeModules.kitty
          self.homeModules.legacy
        ];
        home = {
          username = "khan";
          homeDirectory = "/home/khan";
          stateVersion = "25.05";
        };
      };
    };
  };
}
