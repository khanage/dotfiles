{
  self,
  inputs,
  ...
}: {
  flake.darwinModules.workHomeManager = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.khanthompson = {
        imports = [
          inputs.nvf.homeManagerModules.default
          self.homeModules.shell
          self.homeModules.nvim
          self.homeModules.kitty
          self.homeModules.opencode
          self.homeModules.workLegacy
        ];
        home = {
          username = "khanthompson";
          stateVersion = "25.05";
        };
      };
    };
  };
}
