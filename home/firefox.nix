{ config, pkgs, ... }:

let
  myProfile = "default";
in {
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    profiles.${myProfile} = {
      id = 0;

      isDefault = true;
      name = myProfile;

      # Allow custom chrome styling
      userChrome = ''
/* Modify these values to match your preferences
These reserve extra space on both sides of the nav-bar to be able to drag the window */
:root:is([tabsintitlebar], [sizemode="fullscreen"]) {
  --uc-window-drag-space-pre: 30px; /* left side*/
  --uc-window-drag-space-post: 30px; /* right side*/
}

:root:is([tabsintitlebar][sizemode="maximized"], [sizemode="fullscreen"]) {
  --uc-window-drag-space-pre: 0px; /* Remove pre space */
}

@media (-moz-gtk-csd-minimize-button) and (-moz-gtk-csd-maximize-button) and (-moz-gtk-csd-close-button) {
  :root:is([tabsintitlebar],[sizemode="fullscreen"]) {
    --uc-window-control-width: 84px;
  }
}

.titlebar-buttonbox{ color: var(--toolbar-color) }
:root[sizemode="fullscreen"] .titlebar-buttonbox-container{ display: none }

:root[sizemode="fullscreen"] #TabsToolbar > .titlebar-buttonbox-container:last-child{
  position: absolute;
  display: flex;
  top: 0;
  right:0;
  height: 40px;
}

:root[sizemode="fullscreen"] #TabsToolbar > .titlebar-buttonbox-container:last-child{ height: 32px }

#nav-bar{
  border-inline: var(--uc-window-drag-space-pre,0px) solid transparent;
  border-inline-style: solid !important;
  border-right-width: calc(var(--uc-window-control-width,0px) + var(--uc-window-drag-space-post,0px));
  background-clip: border-box !important;
}
      '';

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.link.open_newwindow" = 3;
        "browser.warnOnQuitShortcut" = true;
        "browser.tabs.warnOnCloseMultipleTabs" = true;
        "signon.rememberSignons" = true;
        "middlemouse.paste" = true;
        "services.sync.engine.bookmarks" = true;
        "services.sync.username" = "your@email.com"; # Replace if using sync
        "network.dns.disableIPv6" = true;

        # Font settings
        "font.name.sans-serif.x-western" = "Iosevka Aile";
        "font.size.variable.x-western" = 20;
        "font.name.monospace.x-western" = "Iosevka Aile";
        "font.size.fixed.x-western" = 18;
      };

      extensions = with nur.repos.rycee.firefox-addons; [
        sidebery
        single-file
        session-sync
        better-darker-docs
        copy-selection-as-markdown
      ];
    };
  };
}
