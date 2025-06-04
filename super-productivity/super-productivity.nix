{ buildNpmPackage
, copyDesktopItems
, electron
, lib
, makeDesktopItem
, nix-update-script
, npm-lockfile-fix
, python3
, stdenv
, src  # Provided by flake input!
}:

buildNpmPackage rec {
  pname = "super-productivity";
  version = "unstable-${src.shortRev or "unknown"}";
  inherit src;

  npmDepsHash = "sha256-0000000000000000000000000000000000000000000000000000"; # Let Nix tell you the right hash on build, or replace with a real one if you want it locked.

  npmFlags = [ "--legacy-peer-deps" ];
  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    CHROMEDRIVER_SKIP_DOWNLOAD = "true";
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
  };

  nativeBuildInputs =
    [ copyDesktopItems ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      (python3.withPackages (ps: [ ps.setuptools ]))
    ];

  postPatch = ''
    substituteInPlace electron-builder.yaml \
      --replace-fail "notarize: true" "notarize: false"
    substituteInPlace src/polyfills.ts \
      --replace-fail "import 'core-js/es/object';" ""
  '';

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm run buildFrontend:prod:es6
    npm run electron:build
    npm exec electron-builder -- --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r "app-builds/mac"*"/Super Productivity.app" "$out/Applications"
          makeWrapper "$out/Applications/Super Productivity.app/Contents/MacOS/Super Productivity" "$out/bin/super-productivity"
        ''
      else
        ''
          mkdir -p $out/share/super-productivity/{app,defaults,static/plugins,static/resources/plugins}
          cp -r app-builds/*-unpacked/{locales,resources{,.pak}} "$out/share/super-productivity/app"

          for size in 16 32 48 64 128 256 512 1024; do
            local sizexsize="''${size}x''${size}"
            mkdir -p $out/share/icons/hicolor/$sizexsize/apps
            cp -v build/icons/$sizexsize.png \
              $out/share/icons/hicolor/$sizexsize/apps/super-productivity.png
          done

          makeWrapper '${lib.getExe electron}' "$out/bin/super-productivity" \
            --add-flags "$out/share/super-productivity/app/resources/app.asar" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
            --inherit-argv0
        ''
    }

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "super-productivity";
      desktopName = "superProductivity";
      exec = "super-productivity %u";
      terminal = false;
      type = "Application";
      icon = "super-productivity";
      startupWMClass = "superProductivity";
      comment = builtins.replaceStrings [ "\n" ] [ " " ] meta.longDescription;
      categories = [ "Utility" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "To Do List / Time Tracker with Jira Integration";
    longDescription = ''
      Experience the best ToDo app for digital professionals and get more done!
      Super Productivity comes with integrated time-boxing and time tracking capabilities
      and you can load your task from your calendars and from
      Jira, Gitlab, GitHub, Open Project and others all into a single ToDo list.
    '';
    homepage = "https://super-productivity.com";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "super-productivity";
  };
}
