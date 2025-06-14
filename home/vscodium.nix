{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      huytd.nord-light
      teabyii.ayu
      sainnhe.gruvbox-material
      arcticicestudio.nord-visual-studio-code
      yzhang.markdown-all-in-one
      svelte.svelte-vscode
      naumovs.color-highlight
      vscode-tailwindcss
      catppuccin.catppuccin-vsc
      astro-build.astro-vscode
    ];
  };
}
