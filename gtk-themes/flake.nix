{
  description = "Always-latest GTK theme bundle (Fausto, Vince, Orchis, Kanagawa)";

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

    # Orchis
    orchis-theme.url = "github:jaycee1285/Orchis-theme";

    # Vince themes
    nordic-polar-theme.url = "github:jaycee1285/Nordic-Polar";
    juno-theme.url = "github:jaycee1285/Juno";
  };

  outputs = { self, nixpkgs
    , catppuccin-theme, gruvbox-theme, everforest-theme, tokyonight-theme, osaka-theme
    , kanagawa-theme, orchis-theme
    , nordic-polar-theme, juno-theme
    , ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      makeTheme = {
        pname,
        src,
        style,     # "fausto", "vince"
        installFlags ? "",
        nativeBuildInputs ? [],
        buildInputs ? [],
        propagatedUserEnvPkgs ? [],
        meta ? {},
      }:
        pkgs.stdenvNoCC.mkDerivation {
          inherit pname src nativeBuildInputs buildInputs propagatedUserEnvPkgs meta;
          version = "unstable-${src.shortRev or "unknown"}";
          installPhase = pkgs.lib.optionalString (style == "fausto") ''
            cd themes
          '' + ''
            bash ./install.sh ${installFlags} -d $out/share/themes
          '';
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
          nativeBuildInputs = [ pkgs.gtk3 ];
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
          nativeBuildInputs = [ pkgs.gtk3 ];
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
          installFlags = "-t gray --tweaks outline";
          nativeBuildInputs = [ pkgs.gtk3 ];
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
          nativeBuildInputs = [ pkgs.gtk3 ];
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
          nativeBuildInputs = [ pkgs.gtk3 ];
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
          nativeBuildInputs = [ pkgs.gtk3 ];
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
          style = "vince";
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

        # Vince themes
        nordic-polar-gtk-theme = makeTheme {
          pname = "nordic-polar-gtk-theme";
          src = nordic-polar-theme;
          style = "vince";
          # no installFlags
          nativeBuildInputs = [ pkgs.gtk3 ];
          propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
          meta = with pkgs.lib; {
            description = "Nordic Polar GTK theme (Vince, always latest)";
            homepage = "https://github.com/EliverLara/Nordic-Polar";
            license = licenses.gpl3Only;
            platforms = platforms.linux;
          };
        };
        juno-gtk-theme = makeTheme {
          pname = "juno-gtk-theme";
          src = juno-theme;
          style = "vince";
          # no installFlags
          nativeBuildInputs = [ pkgs.gtk3 ];
          propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];
          meta = with pkgs.lib; {
            description = "Juno GTK theme (Vince, always latest)";
            homepage = "https://github.com/EliverLara/Juno";
            license = licenses.gpl3Only;
            platforms = platforms.linux;
          };
        };
      };
    };
}
