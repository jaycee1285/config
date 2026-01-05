{ config, pkgs, ... }:


let
opencode = pkgs.vscode-utils.buildVscodeExtension {
  pname = "opencode";
  version = "0.0.12";
  vscodeExtPublisher = "sst-dev";
  vscodeExtName = "opencode";
  vscodeExtUniqueId = "sst-dev.opencode";
  src = pkgs.fetchurl {
    url = "https://open-vsx.org/api/sst-dev/opencode/0.0.12/file/sst-dev.opencode-0.0.12.vsix";
    sha256 = "sha256-0Bql5AWQKw2937sfjm22mi675kAyh8v447b+IjkGKjU=";
  };
};

oneHunter = pkgs.vscode-utils.buildVscodeExtension {
  pname = "one-hunter";
  version = "1.4.0";
  vscodeExtPublisher = "RaillyHugo";
  vscodeExtName = "one-hunter";
  vscodeExtUniqueId = "RaillyHugo.one-hunter";
  src = pkgs.fetchurl {
    url = "https://open-vsx.org/api/RaillyHugo/one-hunter/1.4.0/file/RaillyHugo.one-hunter-1.4.0.vsix";
    sha256 = "sha256-9gZwLmUpwfYf9DtwPxRFpe81IyXUEXk2dSt/15sIc/I=";
  };
};

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
    ]
     ++ [
        opencode
        oneHunter
      ];
  };
}
