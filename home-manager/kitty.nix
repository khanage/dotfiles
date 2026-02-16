{darwin ? false, ...}: {
  enable = true;
  font = {
    name = "GoMono Nerd Font";
    size = 12;
  };
  themeFile = "Nord";
  settings = {
    copy_on_select = "clipboard";
    hide_window_decorations =
      if darwin
      then "no"
      else "yes";
    background_opacity = 0.9;
  };
}
