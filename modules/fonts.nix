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
  fragment-mono
  helvetica-neue-lt-std
  recursive
  mplus-outline-fonts.githubRelease
  pkgs.nerd-fonts.iosevka-term-slab
  pkgs.nerd-fonts.atkynson-mono
  pkgs.nerd-fonts.symbols-only
  pkgs.nerd-fonts.zed-mono
  pkgs.nerd-fonts.martian-mono
  pkgs.nerd-fonts.recursive-mono
  pkgs.nerd-fonts.monaspace
  pkgs.nerd-fonts.lekton
  pkgs.nerd-fonts.intone-mono
  pkgs.nerd-fonts.fantasque-sans-mono
  pkgs.nerd-fonts.agave
  pkgs.nerd-fonts._0xproto
  pkgs.nerd-fonts.iosevka-term
  pkgs.nerd-fonts.im-writing
  (google-fonts.override {fonts = [ "Buenard" "Libre Franklin" "Overpass" "Overpass Mono" "Epilogue" "Philosopher" "Mulish" "Tenor Sans" "Gentium Book Plus" "Sintony" "Poppins" "Oswald" "Outfit" "Bricolage"
  "Merriweather" "Quattrocento" "Lora" "Raleway" "Cormorant Garamond" "Changa" "Merriweather Sans" "Arsenal" "Inter" "Spline Sans" "Tauri" "Libre Franklin" "Palanquin" "Tinos" "Source Sans" "Source Serif"
  "B612" "B612 Mono" "Oxygen Mono" "Fragment Mono" "Chivo Mono" "Fira Mono" "Lekton" "Sono" "IBM Plex Sans" "Fira Sans Condensed" ];
  }
  )
  ];
}
