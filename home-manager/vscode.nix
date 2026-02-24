{pkgs, ...}: {
  enable = true;
  extensions = with pkgs.vscode-marketplace; [
    dracula-theme.theme-dracula
    rust-lang.rust-analyzer
    tamasfe.even-better-toml
    editorconfig.editorconfig
    a5huynh.vscode-ron
    arcticicestudio.nord-visual-studio-code
    jnoortheen.nix-ide
    ms-dotnettools.csdevkit
  ];
}
