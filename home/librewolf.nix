{ pkgs, ... }:

let
  myProfile = "default";
  amoLatestById = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
  librewolfPkg =
    if pkgs.unstable ? librewolf
    then pkgs.unstable.librewolf
    else pkgs.unstable.librewolf-bin;
in
{
  programs.firefox = {
    enable = true;
    package = librewolfPkg;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;

      Preferences = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.link.open_newwindow" = 3;
        "browser.warnOnQuitShortcut" = true;
        "browser.tabs.warnOnCloseMultipleTabs" = true;
        "signon.rememberSignons" = true;
        "middlemouse.paste" = true;
        "services.sync.engine.bookmarks" = true;
        "network.dns.disableIPv6" = true;
        "font.name.sans-serif.x-western" = "Iosevka Aile";
        "font.size.variable.x-western" = 20;
        "font.name.monospace.x-western" = "Iosevka Aile";
        "font.size.fixed.x-western" = 18;
      };

      ExtensionSettings = {
        # ---- From your extensions.json (all converted to /latest/<ID>/latest.xpi) ----

        # Take Webpage Screenshots Entirely - FireShot
        "{0b457cAA-602d-484a-8fe7-c1d894a011ba}" = {
          install_url = amoLatestById "{0b457cAA-602d-484a-8fe7-c1d894a011ba}";
          installation_mode = "force_installed";
        };

        # Session Sync
        "session-sync@gabrielivanica.com" = {
          install_url = amoLatestById "session-sync@gabrielivanica.com";
          installation_mode = "force_installed";
        };

        # Sidebery (pinned)
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          install_url = amoLatestById "{3c078156-979c-498b-8990-85f7987dd929}";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

        # SingleFile
        "{531906d3-e22f-4a6c-a102-8057b88a1a63}" = {
          install_url = amoLatestById "{531906d3-e22f-4a6c-a102-8057b88a1a63}";
          installation_mode = "force_installed";
        };

        # uBlock Origin (pinned)
        "uBlock0@raymondhill.net" = {
          install_url = amoLatestById "uBlock0@raymondhill.net";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

        # ChatGPT Ctrl+Enter Sender
        "chatgpt-ctrl-enter-sender@chatgpt-extension.io" = {
          install_url = amoLatestById "chatgpt-ctrl-enter-sender@chatgpt-extension.io";
          installation_mode = "force_installed";
        };

        # BetterViewer
        "ademking@betterviewer" = {
          install_url = amoLatestById "ademking@betterviewer";
          installation_mode = "force_installed";
        };


        # Dark Reader (pinned)
        "addon@darkreader.org" = {
          install_url = amoLatestById "addon@darkreader.org";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

      };
    };

    profiles.${myProfile} = {
      id = 0;
      isDefault = true;
      name = myProfile;

      userChrome = ''

@import url("file:///home/john/.config/base16changer/librewolf/colors.css");

/* Minimum UI font size */
* { font-size: 14pt !important; }

:root:is([tabsintitlebar], [sizemode="fullscreen"]) {
  --uc-window-drag-space-pre: 30px;
  --uc-window-drag-space-post: 30px;
}
:root:is([tabsintitlebar][sizemode="maximized"], [sizemode="fullscreen"]) {
  --uc-window-drag-space-pre: 0px;
}
@media (-moz-gtk-csd-minimize-button) and (-moz-gtk-csd-maximize-button) and (-moz-gtk-csd-close-button) {
  :root:is([tabsintitlebar],[sizemode="fullscreen"]) {
    --uc-window-control-width: 84px;
  }
}
.titlebar-buttonbox { color: var(--toolbar-color) }
:root[sizemode="fullscreen"] .titlebar-buttonbox-container { display: none }
:root[sizemode="fullscreen"] #TabsToolbar > .titlebar-buttonbox-container:last-child {
  position: absolute;
  display: flex;
  top: 0;
  right: 0;
  height: 40px;
}
:root[sizemode="fullscreen"] #TabsToolbar > .titlebar-buttonbox-container:last-child {
  height: 32px;
}
#nav-bar {
  border-inline: var(--uc-window-drag-space-pre,0px) solid transparent;
  border-inline-style: solid !important;
  border-right-width: calc(var(--uc-window-control-width,0px) + var(--uc-window-drag-space-post,0px));
  background-clip: border-box !important;
}
      '';

      userContent = "";
    };
  };
}
