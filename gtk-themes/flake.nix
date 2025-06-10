{
  description = "Always-latest GTK theme bundle (Fausto, Vince, Orchis, Kanagawa, Juno Mirage)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    # No juno-theme input
  };

  outputs = { self, nixpkgs
    , catppuccin-theme, gruvbox-theme, everforest-theme, tokyonight-theme, osaka-theme
    , kanagawa-theme, nordfox-theme, orchis-theme
    , nordic-polar-theme
    , ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      makeTheme = {
        pname,
        src,
        style,     # "fausto", "eliver", "vince"
        themeFolder ? null,
        installFlags ? "",
        nativeBuildInputs ? [pkgs.gtk3 pkgs.sassc ],
        buildInputs ? [],
        propagatedUserEnvPkgs ? [],
        meta ? {},
      }:
        pkgs.stdenvNoCC.mkDerivation {
          inherit pname src nativeBuildInputs buildInputs propagatedUserEnvPkgs meta;
          version = "unstable-${src.shortRev or "unknown"}";

          installPhase =
            # Fausto themes: run install.sh from ./themes
            (pkgs.lib.optionalString (style == "fausto") ''
              cd themes
              bash ./install.sh ${installFlags} -d $out/share/themes
            '')
            # Orchis (eliver): run install.sh from root
            + (pkgs.lib.optionalString (style == "eliver") ''
              bash ./install.sh ${installFlags} -d $out/share/themes
            '')
            # Vince themes: copy all contents to a single subfolder
            + (pkgs.lib.optionalString (style == "vince" && themeFolder != null) ''
              mkdir -p $out/share/themes/${themeFolder}
              shopt -s dotglob
              cp -r * $out/share/themes/${themeFolder}/
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
          installFlags = "--tweaks outline";
          nativeBuildInputs = [ pkgs.gtk3 pkgs.sassc  ];
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
          installFlags = "--tweaks outline storm";
          nativeBuildInputs = [ pkgs.gtk3  pkgs.sassc ];
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

        # Vince themes (now with custom folder logic)
        nordic-polar-gtk-theme = makeTheme {
          pname = "nordic-polar-gtk-theme";
          src = nordic-polar-theme;
          style = "vince";
          themeFolder = "Nordic-Polar";
          nativeBuildInputs = [ pkgs.gtk3 ];
          propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
          meta = with pkgs.lib; {
            description = "Nordic Polar GTK theme (Vince, always latest)";
            homepage = "https://github.com/EliverLara/Nordic-Polar";
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

        # Nordfox GTK Theme
        nordfox-gtk-theme = makeTheme {
          pname = "nordfox-gtk-theme";
          src = nordfox-theme;
          style = "fausto";
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
      };
    };
}
