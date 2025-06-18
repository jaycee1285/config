{
description = "Always-latest GTK theme bundle (Fausto, Vince, Orchis, Kanagawa, Juno Mirage)";

inputs = {
nixpkgs.url = "github\:NixOS/nixpkgs/nixos-unstable";

```
# Fausto themes
catppuccin-theme.url = "github:jaycee1285/Catppuccin-GTK-Theme";
gruvbox-theme.url = "github:jaycee1285/Gruvbox-GTK-Theme";
everforest-theme.url = "github:jaycee1285/Everforest-GTK-Theme";
tokyonight-theme.url = "github:jaycee1285/Tokyonight-GTK-Theme";
osaka-theme.url = "github:jaycee1285/Osaka-GTK-Theme";

# Kanagawa
kanagawa-theme.url = "github:jaycee1285/Kanagawa-GTK-Theme";  

# Nordfox
nordfox-theme.url = "github:jaycee1285/Nightfox-GTK-Theme";

# Eliver
orchis-theme.url = "github:jaycee1285/Orchis-theme";

# Vince themes
nordic-polar-theme.url = "github:jaycee1285/Nordic-Polar";

# Eliver themes
magnetic-theme.url = "github:jaycee1285/magnetic-gtk-theme";
graphite-theme.url = "github:jaycee1285/graphite-gtk-theme";
```

};

outputs = { self, nixpkgs
, catppuccin-theme, gruvbox-theme, everforest-theme, tokyonight-theme, osaka-theme
, kanagawa-theme, nordfox-theme, orchis-theme
, nordic-polar-theme, magnetic-theme, graphite-theme
, ... }:
let
system = "x86\_64-linux";
pkgs = import nixpkgs { inherit system; };

```
  makeTheme = {
    pname,
    src,
    style,     # "fausto", "eliver", "vince"
    themeFolder ? null, # e.g. "Catppuccin-gtk-theme" or "Orchis-orange-compact"
    installFlags ? "",
    nativeBuildInputs ? [ pkgs.gtk3 pkgs.sassc ],
    buildInputs ? [],
    propagatedUserEnvPkgs ? [],
    meta ? {},
  }:
    pkgs.stdenvNoCC.mkDerivation {
      inherit pname src nativeBuildInputs buildInputs propagatedUserEnvPkgs meta;
      version = "unstable-${src.shortRev or "unknown"}";
      installPhase =
        (pkgs.lib.optionalString (style == "fausto") ''
          cd themes
          bash ./install.sh ${installFlags} -d $out/share/themes
          cd $out/share/themes
          for d in *; do
            if [[ "$d" =~ ^${themeFolder}-unstable- ]]; then
              mv "$d" "${themeFolder}"
            fi
          done
        '')
        + (pkgs.lib.optionalString (style == "eliver") ''
          bash ./install.sh ${installFlags} -d $out/share/themes
          cd $out/share/themes
          for d in *; do
            if [[ "$d" =~ ^${themeFolder}-unstable- ]]; then
              mv "$d" "${themeFolder}"
            fi
          done
        '')
        + (pkgs.lib.optionalString (style == "vince" && themeFolder != null) ''
          mkdir -p $out/share/themes/${themeFolder}
          shopt -s dotglob
          dir=$(find . -maxdepth 1 -type d ! -name '.' | head -n1)
          cp -r "$dir"/* $out/share/themes/${themeFolder}/
          shopt -u dotglob
        '');
    };

in
{
  packages.${system} = {
    # Fausto themes
    catppuccin-gtk-theme = makeTheme {
      pname = "catppuccin-gtk-theme";
      src = catppuccin-theme;
      style = "fausto";
      themeFolder = "Catppuccin-gtk-theme";
      installFlags = "--tweaks outline";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Catppuccin GTK theme (Fausto, always latest)";
        homepage = "https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };
    gruvbox-gtk-theme = makeTheme {
      pname = "gruvbox-gtk-theme";
      src = gruvbox-theme;
      style = "fausto";
      themeFolder = "Gruvbox-gtk-theme";
      installFlags = "-t orange --tweaks outline";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Gruvbox GTK theme (Fausto, always latest)";
        homepage = "https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };
    everforest-gtk-theme = makeTheme {
      pname = "everforest-gtk-theme";
      src = everforest-theme;
      style = "fausto";
      themeFolder = "Everforest-gtk-theme";
      installFlags = "-t grey --tweaks outline";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Everforest GTK theme (Fausto, always latest)";
        homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };
    tokyonight-gtk-theme = makeTheme {
      pname = "tokyonight-gtk-theme";
      src = tokyonight-theme;
      style = "fausto";
      themeFolder = "Tokyonight-gtk-theme";
      installFlags = "--tweaks outline storm";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Tokyonight GTK theme (Fausto, always latest)";
        homepage = "https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };
    osaka-gtk-theme = makeTheme {
      pname = "osaka-gtk-theme";
      src = osaka-theme;
      style = "fausto";
      themeFolder = "Osaka-gtk-theme";
      installFlags = "--tweaks outline solarized";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Osaka GTK theme (Fausto, always latest)";
        homepage = "https://github.com/Fausto-Korpsvart/Osaka-GTK-Theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };

    # Kanagawa
    kanagawa-gtk-theme = makeTheme {
      pname = "kanagawa-gtk-theme";
      src = kanagawa-theme;
      style = "fausto";
      themeFolder = "Kanagawa-gtk-theme";
      installFlags = "-s compact --tweaks dragon";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Kanagawa GTK theme (Fausto, always latest)";
        homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };

    # Orchis
    orchis-orange-compact = makeTheme {
      pname = "orchis-orange-compact";
      src = orchis-theme;
      style = "eliver";
      themeFolder = "Orchis-orange-compact";
      installFlags = "-t orange -c light --tweaks compact";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      buildInputs = [ pkgs.gnome-themes-extra ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Orchis GTK theme (orange, compact, always latest)";
        homepage = "https://github.com/vinceliuice/Orchis-theme";
        license = licenses.gpl3Plus;
        platforms = platforms.linux;
      };
    };

    # Nordic Polar - only the standard-buttons variant, custom derivation
    nordic-polar-gtk-theme = pkgs.stdenvNoCC.mkDerivation rec {
      pname = "nordic-polar-gtk-theme";
      version = "2.2.0-unstable-2025-03-21";
      src = pkgs.fetchFromGitHub {
        owner = "EliverLara";
        repo = "Nordic-polar";
        rev = "ca23b9460713e72defae777162175921beae6e27";
        hash = "sha256-wkmmpviQBGoE/+/tPTIIgkWFUYtYney5Yz12m8Zlak8=";
        name = "Nordic-Polar-standard-buttons";
      };
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      nativeBuildInputs = [ pkgs.jdupes ];
      dontCheckForBrokenSymlinks = true;
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/themes/Nordic-Polar-standard-buttons
        cp -a ./* $out/share/themes/Nordic-Polar-standard-buttons/

        # Clean up extraneous files
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/.gitignore
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/Art
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/FUNDING.yml
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/LICENSE
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/README.md
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/{package.json,package-lock.json,Gulpfile.js}
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/src
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/cinnamon/*.scss
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/gnome-shell/{earlier-versions,extensions,*.scss}
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/gtk-2.0/{assets.svg,assets.txt,links.fish,render-assets.sh}
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/gtk-3.0/{apps,widgets,*.scss}
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/gtk-4.0/{apps,widgets,*.scss}
        rm -rf $out/share/themes/Nordic-Polar-standard-buttons/xfwm4/{assets,render_assets.fish}

        # Link duplicates to save space
        jdupes --quiet --link-soft --recurse $out/share/themes/Nordic-Polar-standard-buttons || true

        runHook postInstall
      '';
      meta = with pkgs.lib; {
        description = "Nordic Polar GTK theme (standard buttons variant only)";
        homepage = "https://github.com/EliverLara/Nordic-polar";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };

    # Juno Mirage only!
    juno-mirage-gtk-theme = pkgs.stdenvNoCC.mkDerivation rec {
      pname = "juno-mirage-gtk-theme";
      version = "0.0.2";
      src = pkgs.fetchurl {
        url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-mirage-standard-buttons.tar.xz";
        sha256 = "EQmIOJeooOYrc74UfTq0z/51FHd6/QzN5+Ga56j3l6M="; # <-- FIX ME after first build!
      };
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      unpackPhase = ''
        tar xf $src
      '';
      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/themes/Juno-mirage-standard-buttons
        cp -a Juno-mirage-standard-buttons/* $out/share/themes/Juno-mirage-standard-buttons/
        rm -f $out/share/themes/Juno-mirage-standard-buttons/{LICENSE,README.md}
        runHook postInstall
      '';
      meta = with pkgs.lib; {
        description = "Juno Mirage GTK theme (standard buttons, official)";
        homepage = "https://github.com/gvolpe/Juno";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };

    nordfox-gtk-theme = makeTheme {
      pname = "nordfox-gtk-theme";
      src = nordfox-theme;
      style = "fausto";
      themeFolder = "Nordfox-gtk-theme";
      installFlags = "-s compact --tweaks outline nord";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Nordfox GTK theme (Fausto, always latest)";
        homepage = "https://github.com/jaycee1285/Nightfox-GTK-Theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };

    magnetic-gtk-theme = makeTheme {
      pname = "magnetic-gtk-theme";
      src = magnetic-theme;
      style = "eliver";
      themeFolder = "Magnetic";
      installFlags = "-t grey,orange --tweaks nord,gruvbox,compact";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Magnetic GTK theme (Eliver, always latest)";
        homepage = "https://github.com/jaycee1285/magnetic-gtk-theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };
    graphite-gtk-theme = makeTheme {
      pname = "graphite-gtk-theme";
      src = graphite-theme;
      style = "eliver";
      themeFolder = "Graphite";
      installFlags = "-t orange,default --tweaks compact,normal,nord";
      nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc ];
      propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
      meta = with pkgs.lib; {
        description = "Graphite GTK theme (Eliver, always latest)";
        homepage = "https://github.com/jaycee1285/graphite-gtk-theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };
  };
};
```

}
