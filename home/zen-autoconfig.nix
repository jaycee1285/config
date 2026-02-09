{ config, pkgs, lib, ... }:

let
  zenProfile = ".zen/n4msclie.default";

  # Fetch fx-autoconfig files at build time (reproducible)
  fxAutoconfig = pkgs.fetchFromGitHub {
    owner = "MrOtherGuy";
    repo = "fx-autoconfig";
    rev = "76232083171a8d609bf0258549d843b0536685e1";  # 2026-02-06
    sha256 = "sha256-xiCikg8c855w+PCy7Wmc3kPwIHr80pMkkK7mFQbPCs4=";
  };
in {
  # Set up chrome folder via activation script
  home.activation.setupZenAutoconfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROFILE="${config.home.homeDirectory}/${zenProfile}"
    CHROME_UTILS="$PROFILE/chrome/utils"
    CHROME_JS="$PROFILE/chrome/JS"

    run mkdir -p "$CHROME_UTILS" "$CHROME_JS"

    # chrome.manifest
    run cat > "$CHROME_UTILS/chrome.manifest" << 'EOF'
content userchromejs ./
EOF

    # Copy fx-autoconfig utility files (fetched at build time)
    run cp "${fxAutoconfig}/profile/chrome/utils/boot.sys.mjs" "$CHROME_UTILS/"
    run cp "${fxAutoconfig}/profile/chrome/utils/fs.sys.mjs" "$CHROME_UTILS/"
    run cp "${fxAutoconfig}/profile/chrome/utils/utils.sys.mjs" "$CHROME_UTILS/"

    # Copy sidebery integration script
    run cp "${./zen-autoconfig/zen-sidebery-integration.uc.mjs}" "$CHROME_JS/zen-sidebery-integration.uc.mjs"

    # Clear startup cache to force reload
    run rm -rf "$PROFILE/startupCache" 2>/dev/null || true

    echo "Zen autoconfig setup complete!"
  '';
}
