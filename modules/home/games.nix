_: {
  flake.homeModules.gaming = {pkgs, ...}: {
    home.packages = with pkgs; [
      wowup-cf
      xivlauncher
      (lutris.override {
        extraLibraries = pkgs: with pkgs; [
          vulkan-loader
        ];
        extraPkgs = pkgs: with pkgs; [
          vulkan-tools
          winetricks
        ];
      })
    ];
  };
}
