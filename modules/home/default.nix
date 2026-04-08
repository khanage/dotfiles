{
  self,
  inputs,
  ...
}: let
  user = "khan";
  host = "homepc";
  system = "x86_64-linux";
in {
  flake.homeConfigurations."${user}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {inherit system;};
    modules = [
      {
        home.username = user;
        home.homeDirectory = "/home/${user}";
        home.stateVersion = "25.05";
      }
      inputs.nvf.homeManagerModules.default
      self.homeModules.shell
      self.homeModules.nvim
    ];
  };
}
