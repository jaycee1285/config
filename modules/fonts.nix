{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
  aileron
  font-awesome
  line-awesome
  material-icons
  julia-mono
  geist-font
  iosevka
  hanken-grotesk
  aleo-fonts
  hubot-sans
  manrope
  pkgs.nerd-fonts.iosevka-term-slab
  pkgs.nerd-fonts.atkynson-mono
  pkgs.nerd-fonts.symbols-only
  pkgs.nerd-fonts.zed-mono
  pkgs.nerd-fonts.martian-mono
  pkgs.nerd-fonts.rec-mono
  pkgs.nerd-fonts.monaspace
  pkgs.nerd-fonts.lekton
  pkgs.nerd-fonts.intone-mono
  pkgs.nerd-fonts.fantasque-sans-mono
  pkgs.nerd-fonts.agave
  pkgs.nerd-fonts._0xproto
  (google-fonts.override {fonts = [ "Buenard" "Libre Franklin" "Overpass" "Overpass Mono" "Philosopher" "Mulish" "Tenor Sans" "Gentium Book Plus" "Sintony" "Poppins" "Oswald" "Outfit" "Bricolage"
  "Merriweather" "Quattrocento" "Lora" "Raleway" "Cormorant Garamond" "Changa" "Merriweather Sans" "Arsenal" "Inter" "Mulish" "Tauri" "Libre Franklin" "Palanquin" "Tinos" "Source Sans" "Source Serif" ];
  }
  )
  ];
}
