{pkgs, ...}: {
  enable = true;
  mutableExtensionsDir = false;

  profiles.default = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      "window.autoDetectColorScheme" = true;
      "workbench.preferredDarkColorTheme" = "Nord";
      "workbench.preferredLightColorTheme" = "Nord";
      "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
    };

    keybindings = [
      {
        key = "ctrl+/";
        command = "workbench.action.terminal.toggleTerminal";
      }
    ];

    extensions = with pkgs.vscode-marketplace; [
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      editorconfig.editorconfig
      a5huynh.vscode-ron
      arcticicestudio.nord-visual-studio-code
      jnoortheen.nix-ide
      vscodevim.vim
      # ms-dotnettools.csdevkit
      fill-labs.dependi
    ];
  };
}
