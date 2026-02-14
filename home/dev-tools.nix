{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Runtimes
    nodejs-slim
    pkgs.unstable.bun
    cargo

    # Version control
    gh
    github-desktop
    codeberg-cli

    # Editors & IDEs
    pkgs.unstable.codex
    pkgs.unstable.opencode
    pkgs.unstable.fresh-editor
    pkgs.unstable.claude-code

    # Development tools
    devtoolbox
    # fjo - REMOVED: conflicts with codeberg-cli (both provide 'berg' binary)
    pkgs.unstable.n8n
    love
  ];
}
