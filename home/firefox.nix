{ config, pkgs, ... }:

let
  myProfile = "default";

  mkAddon = { name, url, sha256 }: pkgs.fetchurl {
    inherit url sha256;
    name = "${name}.xpi";
  };

  extensions = [
    (mkAddon {
      name = "single-file";
      url = "https://addons.mozilla.org/firefox/downloads/file/4465739/single_file-1.22.81.xpi";
      sha256 = "19q55v4xshssb4p2caacl079msfixiqvgjl1h0m1jrly67i7xhmc";
    })
    (mkAddon {
      name = "sidebery";
      url = "https://addons.mozilla.org/firefox/downloads/file/4442132/sidebery-5.3.3.xpi";
      sha256 = "0ss7lzis7x1smjz05f75z9rjfhix3g6kx517bywxddwkbwqaiyd4";
    })
    (mkAddon {
      name = "fireshot";
      url = "https://addons.mozilla.org/firefox/downloads/file/4120150/fireshot-1.12.18.xpi";
      sha256 = "08vzv8caqp52fzbjq7q2z9flsxw1krbw4x1a05mmzlsnf6vln230";
    })
    (mkAddon {
      name = "session-sync";
      url = "https://addons.mozilla.org/firefox/downloads/file/3352792/session_sync-3.1.12.xpi";
      sha256 = "04vdnml87ypaw80zngn0q42qdg2s784j3bqprkc1rybwm0rj3lq8";
    })
    (mkAddon {
      name = "gruvbox-dark";
      url = "https://addons.mozilla.org/firefox/downloads/file/3887660/gruvbox_material_dark_official-1.0.xpi";
      sha256 = "1lh0h7c4sqqdin3bbmvlm5x0xv7k1aw959a7fs3bxyndz5b78xkn";
    })
    (mkAddon {
      name = "link-md";
      url = "https://addons.mozilla.org/firefox/downloads/file/4030775/link_md-1.3.xpi";
      sha256 = "06i67m10p7qaj4lalayppym3ph5nkskxifnmiskj7xiaz41lfk9x";
    })
    (mkAddon {
      name = "catppuccin";
      url = "https://addons.mozilla.org/firefox/downloads/file/3990313/catppuccin_latte_lavender_git-2.0.xpi";
      sha256 = "1mx3xgiafj5llqhhj9zr20lhgfwk7z2d0irgxl3scvis4sk7x667";
    })
    (mkAddon {
      name = "ayu-dark";
      url = "https://addons.mozilla.org/firefox/downloads/file/4032690/ayu_dark_mirage-2.1.xpi";
      sha256 = "1w0d1iig33pspw57clalpfjr65j8laidskmdqqii0rnzibhhkari";
    })
    (mkAddon {
      name = "kanagawa";
      url = "https://addons.mozilla.org/firefox/downloads/file/3934169/kanagawa_theme-1.0.xpi";
      sha256 = "188v4cqxda5vr3g9ncdn93k86qn5qvwsga4higlz11dpfg3qjrbx";
    })
    (mkAddon {
      name = "graphite";
      url = "https://addons.mozilla.org/firefox/downloads/file/3943013/graphite_flat-1.0.xpi";
      sha256 = "1dydp2dv29p8b2iqv7dg0w2aicdnv3lm99kkbrl5146c60nrdjly";
    })
    (mkAddon {
      name = "gruvbox-light";
      url = "https://addons.mozilla.org/firefox/downloads/file/3887892/gruvbox_material_light_officia-1.1.xpi";
      sha256 = "1q804zcl9rqj9b6syj9hc5qvcny2zic2k9qzrbzhvpzyqx1mbag5";
    })
    (mkAddon {
      name = "nord-light";
      url = "https://addons.mozilla.org/firefox/downloads/file/4232230/nord_light-2.11.xpi";
      sha256 = "1sxkvbn1asdq1ly0dy20iqrrf4fnhr51k8kq75px1qacax9kzjrn";
    })
    (mkAddon {
      name = "minimalist-ayu";
      url = "https://addons.mozilla.org/firefox/downloads/file/4119635/minimalist_ayu-1.0.xpi";
      sha256 = "1ibdb9fzq5cvgi1z056l26fgnfl178g0nmcxz1l1jixga6fd7qz0";
    })
  ];
in {
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    profiles.${myProfile} = {
      id = 0;
      isDefault = true;
      name = myProfile;

      settings = {
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

      extensions.packages = extensions;

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
