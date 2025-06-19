# ~/.config/home-manager/modules/flutter.nix
{ pkgs, ... }:

let
  sdk = pkgs.androidsdk;   # vanilla SDK package from nixpkgs
in
{
  home.packages = [
    pkgs.flutter
    pkgs.jdk17
    sdk
  ];

  home.sessionVariables = {
    ANDROID_SDK_ROOT = "${sdk}/libexec/android-sdk";
    ANDROID_HOME     = "${sdk}/libexec/android-sdk";
    JAVA_HOME        = "${pkgs.jdk17}";
  };

  home.sessionPath = [
    "${sdk}/libexec/android-sdk/platform-tools"
    "${sdk}/libexec/android-sdk/cmdline-tools/latest/bin"
    "${sdk}/libexec/android-sdk/tools/bin"   # some old build scripts still look here
  ];
}
