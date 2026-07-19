_: {
  flake.homeModules.nordic-theme = {pkgs, ...}: {
    gtk = {
      enable = true;
      gtk4.theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      iconTheme = {
        name = "Zafiro-Icons-Dark";
        package = pkgs.zafiro-icons;
      };
    };
  };
}
