{ pkgs, ... }:
{
  # Make sure your user session picks up fonts installed via home.packages
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    cabin
    font-awesome
    line-awesome
    material-icons
    julia-mono
    hanken-grotesk
    aleo-fonts
    hubot-sans
    victor-mono
    azeret-mono
    zilla-slab
    inriafonts
    jost
	nacelle
	figtree
	excalifont
	sudo-font
	route159	
  
    nerd-fonts.atkynson-mono
    nerd-fonts.symbols-only

    (google-fonts.override {
      fonts = [
        "Buenard" "Libre Franklin" "Overpass" "Overpass Mono" "Epilogue"
        "Philosopher" "Mulish" "Tenor Sans" "Gentium Book Plus" "Sintony"
        "Oswald" "Outfit" "Bricolage"
        "Quattrocento" "Raleway" "Cormorant Garamond" "Changa"
        "Arsenal" "Spline Sans" "Tauri"
        "Palanquin" "Tinos" "Source Sans" "Source Serif" "B612" "B612 Mono"
        "Fragment Mono" "Chivo Mono" "Fira Mono" "Lekton"
        "Sono" "IBM Plex Sans" "Fira Sans Condensed" "Cabin Condensed"
        "Patrick Hand" "Spline Sans Mono"
      ];
    })
  ];
}
