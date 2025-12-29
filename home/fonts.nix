{ pkgs, ... }:
{
  # Make sure your user session picks up fonts installed via home.packages
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    aileron
    cabin
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
    victor-mono
    camingo-code
    league-mono
    azeret-mono
    monoid
    helvetica-neue-lt-std
    recursive
    zilla-slab
    inriafonts
    andika
    route159
    jost
    aporetic-bin
    mplus-outline-fonts.githubRelease

    nerd-fonts.iosevka-term-slab
    nerd-fonts.atkynson-mono
    nerd-fonts.symbols-only
    nerd-fonts.zed-mono
    nerd-fonts.martian-mono
    nerd-fonts.recursive-mono
    nerd-fonts.monaspace
    nerd-fonts.lekton
    nerd-fonts.intone-mono
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.agave
    nerd-fonts._0xproto
    nerd-fonts.iosevka-term
    nerd-fonts.im-writing

    (google-fonts.override {
      fonts = [
        "Buenard" "Libre Franklin" "Overpass" "Overpass Mono" "Epilogue"
        "Philosopher" "Mulish" "Tenor Sans" "Gentium Book Plus" "Sintony"
        "Poppins" "Oswald" "Outfit" "Bricolage" "Merriweather"
        "Quattrocento" "Lora" "Raleway" "Cormorant Garamond" "Changa"
        "Merriweather Sans" "Arsenal" "Inter" "Spline Sans" "Tauri"
        "Palanquin" "Tinos" "Source Sans" "Source Serif" "B612" "B612 Mono"
        "Oxygen Mono" "Fragment Mono" "Chivo Mono" "Fira Mono" "Lekton"
        "Sono" "IBM Plex Sans" "Fira Sans Condensed" "Cabin Condensed"
        "Patrick Hand"
      ];
    })
  ];
}
