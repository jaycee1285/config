{ pkgs, ... }:
{
  programs.android-sdk = {
    enable = true;
    platformTools = true;
    tools          = true;
    buildToolsVersions = [ "34.0.0" ];
    platforms       = [ "android-34" ];
    accept_license  = true;
  };

  home.packages = with pkgs; [ flutter ];

  home.sessionVariables = {
    ANDROID_SDK_ROOT = "${pkgs.android-sdk}/libexec/android-sdk";
    ANDROID_HOME     = "${pkgs.android-sdk}/libexec/android-sdk";
  };
}
