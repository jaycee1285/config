{ config, pkgs, nix-vscode-extensions, ... }:


let

  exts = nix-vscode-extensions.extensions.${pkgs.system};
  ovsx = exts.open-vsx-release; # or open-vsx-release-universal

in

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
      enkia.tokyo-night
      astro-build.astro-vscode
      ionic.ionic
      bierner.color-info
      sdras.night-owl
      mvllow.rose-pine
      dart-code.dart-code
      unifiedjs.vscode-mdx
      saoudrizwan.claude-dev
      vitaliymaz.vscode-svg-previewer
      tekumara.typos-vscode
      tauri-apps.tauri-vscode
      joshmu.periscope
      enkia.tokyo-night
      elijah-potter.harper
      antfu.icons-carbon
      yzhang.markdown-all-in-one
      golang.go
      anthropic.claude-code
    ]
     ++ [
        ovsx."sst-dev".opencode
        ovsx.raillyhugo."one-hunter"
        ovsx.selemondev."vscode-shadcn-svelte"
        ovsx.breaking-brake."cc-wf-studio"
      ];
  };
}
