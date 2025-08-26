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
      bradlc.vscode-tailwindcss
      catppuccin.catppuccin-vsc
      astro-build.astro-vscode
      ionic.ionic
      sdras.night-owl
      mvllow.rose-pine
      continue.continue
      dart-code.dart-code
      unifiedjs.vscode-mdx
      brandonkirbyson.solarized-palenight
    ];
  };
}
