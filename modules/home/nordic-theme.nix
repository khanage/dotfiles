_: {
  flake.homeModules.nordic-theme = {pkgs, ...}: {
    gtk = {
      enable = true;
      gtk4.theme = {
        name = "Nordic";
        package = pkgs.colloid-gtk-theme.override {
          colorVariants = ["dark"];
          sizeVariants = ["compact"];
          tweaks = ["nord"];
        };
      };
      iconTheme = {
        name = "Zafiro-Icons-Dark";
        package = pkgs.zafiro-icons;
      };
    };
  };
}
