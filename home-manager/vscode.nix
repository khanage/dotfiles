{pkgs, ...}: {
  enable = true;
  extensions = with pkgs.vscode-marketplace; [
    dracula-theme.theme-dracula
  ];
}
