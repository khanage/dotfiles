_: {
  flake.homeModules.kitty = {
    pkgs,
    lib,
    ...
  }: {
    programs.kitty = {
      enable = true;
      font = {
        name = "GoMono Nerd Font";
        size = 12;
      };
      themeFile = "Nord";
      settings =
        {
          copy_on_select = "clipboard";
          open_url_with = "default";
        }
        // lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
          hide_window_decorations = "yes";
          background_opacity = 0.9;
        };
    };
  };
}
