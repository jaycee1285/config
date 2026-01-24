{ config, pkgs, ... }:

let
  myProfile = "default";
  amoLatestById = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf-bin;

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

        # Solarize Fox
        "{467c0f66-2faa-4636-93bb-9a5eda23389f}" = {
          install_url = amoLatestById "{467c0f66-2faa-4636-93bb-9a5eda23389f}";
          installation_mode = "force_installed";
        };

        # Session Sync
        "session-sync@gabrielivanica.com" = {
          install_url = amoLatestById "session-sync@gabrielivanica.com";
          installation_mode = "force_installed";
        };

        # Solarized Light
        "{cbaf2ab0-4b85-44b3-81c8-b99d609974b0}" = {
          install_url = amoLatestById "{cbaf2ab0-4b85-44b3-81c8-b99d609974b0}";
          installation_mode = "force_installed";
        };

        # kanagawa
        "{53cc1853-5ebd-41c8-8c89-6524cb99b99e}" = {
          install_url = amoLatestById "{53cc1853-5ebd-41c8-8c89-6524cb99b99e}";
          installation_mode = "force_installed";
        };

        # ColorPick Eyedropper
        "jid1-kCS67LPIOiGf2Q@jetpack" = {
          install_url = amoLatestById "jid1-kCS67LPIOiGf2Q@jetpack";
          installation_mode = "force_installed";
        };

        # Graphite Flat
        "{67118a6e-ca52-4bcf-8da8-93b3d2e23cb6}" = {
          install_url = amoLatestById "{67118a6e-ca52-4bcf-8da8-93b3d2e23cb6}";
          installation_mode = "force_installed";
        };

        # Catppuccin Latte - Lavender
        "{bc6fdbef-4c18-4967-9899-7803fdcaf3b4}" = {
          install_url = amoLatestById "{bc6fdbef-4c18-4967-9899-7803fdcaf3b4}";
          installation_mode = "force_installed";
        };

        # Gruvbox Material Light
        "{9525ead3-fe6e-41c4-8220-ca9941b3b77d}" = {
          install_url = amoLatestById "{9525ead3-fe6e-41c4-8220-ca9941b3b77d}";
          installation_mode = "force_installed";
        };

        # Minimalist Ayu
        "{fd07a33f-8807-49d5-848c-8a1a09f74a7f}" = {
          install_url = amoLatestById "{fd07a33f-8807-49d5-848c-8a1a09f74a7f}";
          installation_mode = "force_installed";
        };

        # Gruvbox Material Dark
        "{f9be3857-6894-4d6e-90e0-64451bdf7655}" = {
          install_url = amoLatestById "{f9be3857-6894-4d6e-90e0-64451bdf7655}";
          installation_mode = "force_installed";
        };

        # oneclick-theme-switcher
        "oneclick-theme-switch@janstuemmel.github.io" = {
          install_url = amoLatestById "oneclick-theme-switch@janstuemmel.github.io";
          installation_mode = "force_installed";
        };

        # SimilarWeb - Traffic Rank & Website Analysis
        "FirefoxAddon@similarWeb.com" = {
          install_url = amoLatestById "FirefoxAddon@similarWeb.com";
          installation_mode = "force_installed";
        };

        # Nord Polar Dark
        "{758478b6-29f3-4d69-ab17-c49fe568ed80}" = {
          install_url = amoLatestById "{758478b6-29f3-4d69-ab17-c49fe568ed80}";
          installation_mode = "force_installed";
        };

        # Rose Pine Dawn
        "{2e6bfba0-33c2-4bf5-9aaf-15bf09f8fa2f}" = {
          install_url = amoLatestById "{2e6bfba0-33c2-4bf5-9aaf-15bf09f8fa2f}";
          installation_mode = "force_installed";
        };

        # Ayu Mirage Single Accent
        "{1faf2b8b-cb9f-4cf7-a685-58d97d3c7115}" = {
          install_url = amoLatestById "{1faf2b8b-cb9f-4cf7-a685-58d97d3c7115}";
          installation_mode = "force_installed";
        };

        # Kanagawa Lotus
        "{22cfb1ea-c625-488a-a9a0-5747dcbd94e1}" = {
          install_url = amoLatestById "{22cfb1ea-c625-488a-a9a0-5747dcbd94e1}";
          installation_mode = "force_installed";
        };

        # Nord Light
        "{27d711f8-65ea-4fbb-ab26-cd326efdad75}" = {
          install_url = amoLatestById "{27d711f8-65ea-4fbb-ab26-cd326efdad75}";
          installation_mode = "force_installed";
        };

        # Everforest Light
        "{08400cc9-1bf6-4e3e-b175-2d2650bc3104}" = {
          install_url = amoLatestById "{08400cc9-1bf6-4e3e-b175-2d2650bc3104}";
          installation_mode = "force_installed";
        };

        # Flexoki Light
        "{cb1e6534-4545-429e-9ee6-bc50c22ad5e2}" = {
          install_url = amoLatestById "{cb1e6534-4545-429e-9ee6-bc50c22ad5e2}";
          installation_mode = "force_installed";
        };

        # Flexoki Dark
        "{2f0596eb-26b7-45bb-addb-ab56eb7c97dc}" = {
          install_url = amoLatestById "{2f0596eb-26b7-45bb-addb-ab56eb7c97dc}";
          installation_mode = "force_installed";
        };

        # Sidebery (pinned)
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          install_url = amoLatestById "{3c078156-979c-498b-8990-85f7987dd929}";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

        # Google Chrome Light
        "{1fd1213e-dcb2-48d9-806f-c0a8a7d0a8e7}" = {
          install_url = amoLatestById "{1fd1213e-dcb2-48d9-806f-c0a8a7d0a8e7}";
          installation_mode = "force_installed";
        };

        # Link-Md
        "{11ea90de-7c7d-4f1f-a5a4-9baf3f519a6b}" = {
          install_url = amoLatestById "{11ea90de-7c7d-4f1f-a5a4-9baf3f519a6b}";
          installation_mode = "force_installed";
        };

        # Internet Archive Downloader
        "internet_archive_downloader@timelegend.net" = {
          install_url = amoLatestById "internet_archive_downloader@timelegend.net";
          installation_mode = "force_installed";
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

        # RSSHub Radar
        "i@diygod.me" = {
          install_url = amoLatestById "i@diygod.me";
          installation_mode = "force_installed";
        };

        # BetterViewer
        "ademking@betterviewer" = {
          install_url = amoLatestById "ademking@betterviewer";
          installation_mode = "force_installed";
        };

        # Firefox Color
        "FirefoxColor@mozilla.com" = {
          install_url = amoLatestById "FirefoxColor@mozilla.com";
          installation_mode = "force_installed";
        };

        # Dark Reader (pinned)
        "addon@darkreader.org" = {
          install_url = amoLatestById "addon@darkreader.org";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

        # Tab Session Manager
        "Tab-Session-Manager@sienori" = {
          install_url = amoLatestById "Tab-Session-Manager@sienori";
          installation_mode = "force_installed";
        };

        # floccus bookmarks sync
        "floccus@handmadeideas.org" = {
          install_url = amoLatestById "floccus@handmadeideas.org";
          installation_mode = "force_installed";
        };

        # ---- Optional: Bitwarden (NOT in your extensions.json, but you used it earlier) ----
        # If you want it, leave this in; if not, delete it.
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = amoLatestById "{446900e4-71c2-419f-a6a7-df9c091e268b}";
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
    };
  };
}