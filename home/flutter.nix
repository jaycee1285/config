# ~/.config/home-manager/modules/flutter.nix
{ pkgs, ... }:
let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "11.0";
    toolsVersion = "26.1.1";
    platformToolsVersion = "35.0.1";
    buildToolsVersions = [ "34.0.0" "33.0.2" ];
    includeEmulator = false;
    emulatorVersion = "34.1.9";
    platformVersions = [ "34" "33" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.22.1" ];
    includeNDK = true;
    ndkVersions = ["25.1.8937393"];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;gcm"
    ];
    extraLicenses = [
      "android-sdk-license"
      "android-sdk-preview-license"
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };
  
  androidSdk = androidComposition.androidsdk;
in
{
  home.packages = [
    pkgs.flutter
    pkgs.jdk17
    androidSdk
    # Additional tools that might be needed
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    # Script to set up Flutter projects
    (pkgs.writeScriptBin "flutter-setup-project" ''
      #!${pkgs.stdenv.shell}
      if [ -d "android" ]; then
        echo "sdk.dir=${androidSdk}/libexec/android-sdk" > android/local.properties
        echo "Flutter project configured for NixOS!"
      else
        echo "No android directory found. Run this from your Flutter project root."
      fi
    '')
  ];
  
  home.sessionVariables = {
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    JAVA_HOME = "${pkgs.jdk17}";
    ANDROID_AVD_HOME = "$HOME/.android/avd";
  };
  
  home.sessionPath = [
    "${androidSdk}/libexec/android-sdk/platform-tools"
    "${androidSdk}/libexec/android-sdk/cmdline-tools/latest/bin"
    "${androidSdk}/libexec/android-sdk/build-tools/34.0.0"
  ];
  
  # Create local.properties automatically
  home.file.".local/share/flutter-local-properties" = {
    text = ''
      sdk.dir=${androidSdk}/libexec/android-sdk
      flutter.sdk=${pkgs.flutter}
      flutter.buildMode=release
      flutter.versionName=1.0.0
      flutter.versionCode=1
    '';
  };
}