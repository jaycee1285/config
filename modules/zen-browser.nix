{ config, pkgs, lib, zen-browser, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  # fx-autoconfig's config.js loader
  configJs = pkgs.writeText "config.js" ''
    // skip 1st line
    try {
      let cmanifest = Cc['@mozilla.org/file/directory_service;1'].getService(Ci.nsIProperties).get('UChrm', Ci.nsIFile);
      cmanifest.append('utils');
      cmanifest.append('chrome.manifest');

      if(cmanifest.exists()){
        Components.manager.QueryInterface(Ci.nsIComponentRegistrar).autoRegister(cmanifest);
        ChromeUtils.importESModule('chrome://userchromejs/content/boot.sys.mjs');
      }
    } catch(ex) {};
  '';

  # Preference file that enables the config.js loader
  configPrefsJs = pkgs.writeText "config-prefs.js" ''
    pref("general.config.obscure_value", 0);
    pref("general.config.filename", "config.js");
    pref("general.config.sandbox_enabled", false);
  '';

  # Get the base zen-browser package
  zenBase = zen-browser.packages.${system}.default;

  # Create zen-browser with fx-autoconfig by copying (not symlinking) the lib
  zenWithAutoconfig = pkgs.stdenv.mkDerivation {
    pname = "zen-browser-with-autoconfig";
    version = zenBase.version or "1.0";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Copy the entire zen package structure
      mkdir -p $out
      cp -r ${zenBase}/share $out/share 2>/dev/null || true

      # Copy lib directory (actual copy, not symlink)
      mkdir -p $out/lib
      cp -rL ${zenBase}/lib/zen-* $out/lib/

      # Make writable so we can add files
      chmod -R u+w $out/lib

      # Find our lib directory
      ZEN_LIB=$(find $out/lib -maxdepth 1 -name "zen-*" -type d | head -1)
      ZEN_LIB_NAME=$(basename "$ZEN_LIB")

      # Remove conflicting autoconfig.js (points to mozilla.cfg instead of config.js)
      rm -f "$ZEN_LIB/defaults/pref/autoconfig.js"

      # Add config.js to the lib root
      cp ${configJs} "$ZEN_LIB/config.js"

      # Add config-prefs.js to defaults/pref
      cp ${configPrefsJs} "$ZEN_LIB/defaults/pref/config-prefs.js"

      # Create bin directory with wrapper
      mkdir -p $out/bin

      # Copy the original wrapper and fix the paths
      substitute ${zenBase}/bin/zen-beta $out/bin/zen-beta \
        --replace "${zenBase}" "$out"
      chmod +x $out/bin/zen-beta

      # Create zen symlink
      ln -s zen-beta $out/bin/zen

      # Create the .zen-beta-wrapped symlink pointing to our lib
      ln -s ../lib/$ZEN_LIB_NAME/zen $out/bin/.zen-beta-wrapped

      runHook postInstall
    '';

    meta = zenBase.meta or {};
  };

in {
  environment.systemPackages = [
    zenWithAutoconfig
  ];
}
