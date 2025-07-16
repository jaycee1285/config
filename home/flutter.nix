{ pkgs, ... }:
let
  # 1. compose the lean SDK (unchanged)
  androidComp = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion  = "11.0";
    toolsVersion         = "26.1.1";
    platformToolsVersion = "35.0.1";
    buildToolsVersions   = [ "34.0.0" "33.0.2" ];
    platformVersions     = [ "34" "33" ];
    includeNDK           = true;
    ndkVersions          = [ "25.1.8937393" ];
    includeEmulator      = false;
    includeSources       = false;
    includeSystemImages  = false;
  };
  
  # Create the sdkmanager wrapper script
  sdkmanagerWrapper = pkgs.writeScriptBin "sdkmanager-wrapper" ''
    #!${pkgs.bash}/bin/bash
    # Remove any --sdk_root arguments from the original call and add our own
    SDK_ROOT="$HOME/.local/share/android-sdk"
    export ANDROID_SDK_ROOT="$SDK_ROOT"
    export ANDROID_HOME="$SDK_ROOT"
    
    # Filter out any existing --sdk_root arguments
    args=()
    skip_next=false
    for arg in "$@"; do
        if [[ "$arg" == "--sdk_root" ]]; then
            skip_next=true
        elif [[ "$arg" == --sdk_root=* ]]; then
            continue
        elif [[ "$skip_next" == true ]]; then
            skip_next=false
        else
            args+=("$arg")
        fi
    done
    
    # Call the wrapped sdkmanager with our SDK root
    exec ${androidComp.androidsdk}/libexec/android-sdk/cmdline-tools/11.0/bin/.sdkmanager-wrapped_ --sdk_root="$SDK_ROOT" "''${args[@]}"
  '';
  
  androidSdk = pkgs.runCommand "android-sdk-with-licenses" { } ''
    mkdir -p $out
    # copy the 'androidsdk' output itself
    cp -rL --no-preserve=mode,ownership \
        ${androidComp.androidsdk}/libexec $out/
    # copy the standalone platform-tools so adb exists - SIMPLE WORKING FIX
    mkdir -p $out/libexec/android-sdk/platform-tools
    
    # Just symlink the tools from android-tools package since it's already in your packages
    ln -sf ${pkgs.android-tools}/bin/adb $out/libexec/android-sdk/platform-tools/adb
    ln -sf ${pkgs.android-tools}/bin/fastboot $out/libexec/android-sdk/platform-tools/fastboot
    # Ensure build-tools directory exists and has proper permissions
    if [ -d "$out/libexec/android-sdk/build-tools" ]; then
      chmod -R +x $out/libexec/android-sdk/build-tools/*/
    fi
    # cmdline-tools/latest → 11.0
    ln -s $out/libexec/android-sdk/cmdline-tools/11.0 \
          $out/libexec/android-sdk/cmdline-tools/latest
    # licences (pre-populate common ones to minimize prompts)
    licDir=$out/libexec/android-sdk/licenses
    mkdir -p "$licDir"
    
    # Android SDK License
    cat > "$licDir/android-sdk-license" <<'EOF'
8933bad161af4178b1185d1a37fbf41ea5269c55
d56f5187479451eabf01fb78af6dfcb131a6481e
24333f8a63b6825ea9c5514f83c2829b004d1fee
EOF
    # Android SDK Preview License
    cat > "$licDir/android-sdk-preview-license" <<'EOF'
84831b9409646a918e30573bab4c9c91346d8abd
EOF
  '';
  
  sdkRoot   = "${androidSdk}/libexec/android-sdk";
  cmdBin    = "${sdkRoot}/cmdline-tools/latest/bin";
  platBin   = "${sdkRoot}/platform-tools";
  flutterBin = "${pkgs.flutter}/bin/flutter";
in
{
  home.packages = [
    pkgs.jdk17
    androidSdk
    pkgs.android-tools
    pkgs.cmake pkgs.ninja pkgs.pkg-config pkgs.sqlite
    pkgs.ungoogled-chromium
    # Libraries needed for Flutter Linux builds
    pkgs.zlib
    pkgs.libGL
    pkgs.xorg.libX11
    pkgs.gtk3
    pkgs.glib
    pkgs.nss
    pkgs.nspr
    pkgs.atk
    pkgs.cairo
    pkgs.pango
    pkgs.gdk-pixbuf
    pkgs.libepoxy
    (pkgs.writeShellScriptBin "flutter" ''
      # Create a writable Android SDK in user's home if it doesn't exist
      WRITABLE_SDK="$HOME/.local/share/android-sdk"
      
      if [ ! -d "$WRITABLE_SDK" ]; then
        echo "Setting up writable Android SDK at $WRITABLE_SDK..."
        mkdir -p "$(dirname "$WRITABLE_SDK")"
        cp -rL '${sdkRoot}' "$WRITABLE_SDK"
        chmod -R u+w "$WRITABLE_SDK"
        
        # Fix cmdline-tools symlink (cp -L dereferences it, so we need to recreate)
        if [ -d "$WRITABLE_SDK/cmdline-tools/11.0" ]; then
          rm -rf "$WRITABLE_SDK/cmdline-tools/latest"
          ln -s "$WRITABLE_SDK/cmdline-tools/11.0" "$WRITABLE_SDK/cmdline-tools/latest"
        fi
        
        # Fix NDK location (move ndk-bundle to proper location)
        if [ -d "$WRITABLE_SDK/ndk-bundle" ] && [ ! -d "$WRITABLE_SDK/ndk/25.1.8937393" ]; then
          mkdir -p "$WRITABLE_SDK/ndk"
          mv "$WRITABLE_SDK/ndk-bundle" "$WRITABLE_SDK/ndk/25.1.8937393"
        fi
        
        # Create sdkmanager wrapper that uses the writable SDK
        # This is CRITICAL - without this, sdkmanager will use the read-only Nix store paths
        # and Flutter won't be able to verify licenses
        cp ${sdkmanagerWrapper}/bin/sdkmanager-wrapper "$WRITABLE_SDK/cmdline-tools/latest/bin/sdkmanager"
        chmod +x "$WRITABLE_SDK/cmdline-tools/latest/bin/sdkmanager"
        
        # Ensure cmdline-tools binaries are executable
        chmod +x "$WRITABLE_SDK/cmdline-tools/latest/bin/"* 2>/dev/null || true
        chmod +x "$WRITABLE_SDK/cmdline-tools/11.0/bin/"* 2>/dev/null || true
        
        # Ensure .android directory exists for SDK manager
        mkdir -p "$HOME/.android"
        
        # Create repositories.cfg if it doesn't exist (sdkmanager needs this)
        touch "$HOME/.android/repositories.cfg"
      fi
      
      # Also check if all licenses are accepted
      if [ ! -f "$WRITABLE_SDK/.licenses_accepted" ]; then
        echo "Accepting Android SDK licenses..."
        # Run sdkmanager --licenses with yes piped in
        if yes 2>/dev/null | "$WRITABLE_SDK/cmdline-tools/latest/bin/sdkmanager" --licenses; then
          touch "$WRITABLE_SDK/.licenses_accepted"
          echo "✓ Licenses accepted successfully"
        else
          echo "⚠ Note: Some licenses may need manual acceptance. Run 'flutter doctor --android-licenses'"
        fi
      fi
      
      export ANDROID_SDK_ROOT="$WRITABLE_SDK"
      export ANDROID_HOME="$ANDROID_SDK_ROOT"
      export JAVA_HOME='${pkgs.jdk17}'
      export PATH="$WRITABLE_SDK/platform-tools:$WRITABLE_SDK/cmdline-tools/latest/bin:$PATH"
      export CHROME_EXECUTABLE='${pkgs.ungoogled-chromium}/bin/chromium'
      
      # Set up library paths for Linux builds
      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
        pkgs.zlib
        pkgs.libGL
        pkgs.xorg.libX11
        pkgs.gtk3
        pkgs.glib
        pkgs.nss
        pkgs.nspr
        pkgs.atk
        pkgs.cairo
        pkgs.pango
        pkgs.gdk-pixbuf
        pkgs.libepoxy
      ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      
      exec '${flutterBin}' "$@"
    '')
  ];
  home.sessionVariables = {
    # Note: These will still point to the Nix store version for other tools
    # The Flutter wrapper overrides them with the writable version
    ANDROID_SDK_ROOT  = sdkRoot;
    ANDROID_HOME      = sdkRoot;
    JAVA_HOME         = "${pkgs.jdk17}";
    CHROME_EXECUTABLE = "${pkgs.ungoogled-chromium}/bin/chromium";
  };
  home.sessionPath = [
    "${pkgs.android-tools}/bin"
    "${sdkRoot}/cmdline-tools/latest/bin"
  ];
}