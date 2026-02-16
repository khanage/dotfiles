{
  lib,
  darwin ? false,
  ...
}: {
  enable = true;
  font = {
    name = "GoMono Nerd Font";
    size = 12;
  };
  themeFile = "Nord";
  settings =
    {
      copy_on_select = "clipboard";
    }
    // lib.optionalAttrs darwin {
      hide_window_decorations = "yes";
      background_opacity = 0.9;
    };
}
