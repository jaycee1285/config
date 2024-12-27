# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
# add unstable channel declaratively
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in

{
  imports =
	[ # Include the results of the hardware scan.
  	./hardware-configuration.nix
	];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "x13"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
	LC_ADDRESS = "en_US.UTF-8";
	LC_IDENTIFICATION = "en_US.UTF-8";
	LC_MEASUREMENT = "en_US.UTF-8";
	LC_MONETARY = "en_US.UTF-8";
	LC_NAME = "en_US.UTF-8";
	LC_NUMERIC = "en_US.UTF-8";
	LC_PAPER = "en_US.UTF-8";
	LC_TELEPHONE = "en_US.UTF-8";
	LC_TIME = "en_US.UTF-8";
  };

services.thermald.enable = true;
	services.tlp = {
		enable = true;
		settings.STOP_CHARGE_THRESH_BAT0 = 80;
                settings.START_CHARGE_THRESH_BAT0 = 50;
	};


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the LXQT Desktop Environment.
  # services.xserver.displayManager.lightdm.enable = true;
services.xserver.displayManager.gdm = {
      enable = true;
      wayland= true;
    };

environment.etc."gdm/wayland-sessions/lxqt-wayland.desktop".source = "/nix/store/gkicvl61zb5ggy57qc4s5ybsa9kwm3zh-lxqt-wayland-session-0.1.0/share/wayland-sessions/lxqt-wayland.desktop";


#    services.xserver.desktopManager.xfce.enable = true;
services.xserver.desktopManager.cinnamon.enable=true;

#    services.greetd.enable = true;

#   services.greetd.settings = {
#       default_session={
#          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu -rti --asterisks --cmd labwc";
#          user = "greeter";
#        };
#      };

#  systemd.services.greetd.serviceConfig = {
#   Type = "idle";
#    StandardInput = "tty";
#    StandardOutput = "tty";
#    StandardError = "journal"; # Without this errors will spam on screen
    
    # Without these bootlogs will spam on screen
#    TTYReset = true;
#    TTYVHangup = true;
#    TTYVTDisallocate = true;
# };

#services.tlp = {
#      enable = true;
#      settings = {
#        CPU_SCALING_GOVERNOR_ON_AC = "performance";
#        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

#        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
#        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

#        CPU_MIN_PERF_ON_AC = 0;
#        CPU_MAX_PERF_ON_AC = 80;
#        CPU_MIN_PERF_ON_BAT = 0;
#        CPU_MAX_PERF_ON_BAT = 40;

       #Optional helps save long term battery health
      # START_CHARGE_THRESH_BAT0 = 45;
      # STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

#     };
#};
  
  # Configure keymap in X11
  services.xserver = {
	layout = "us";
	xkbVariant = "";
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	# If you want to use JACK applications, uncomment this
	#jack.enable = true;

	# use the example session manager (no others are packaged yet so this is enabled by default,
	# no need to redefine it in your config for now)
	#media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.john = {
	isNormalUser = true;
	description = "john";
	extraGroups = [ "networkmanager" "wheel" ];
	packages = with pkgs; [
	#  thunderbird
	];
  };

  security.sudo.wheelNeedsPassword = false;


  # Install firefox.

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

environment.etc."sddm/wayland-sessions/lxqt-wayland.desktop".source = "/nix/store/gkicvl61zb5ggy57qc4s5ybsa9kwm3zh-lxqt-wayland-session-0.1.0/share/wayland-sessions/lxqt-wayland.desktop";


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim 
  # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget

  onedriver
  openssl
  themix-gui
  gtk-engine-murrine
  gdk-pixbuf
  sassc
  gruvbox-kvantum
  catppuccin-kvantum
  orchis-theme
  catppuccin-gtk
  libreoffice

  #coding
  unstable.vscodium-fhs
  nodejs_22
  unstable.bun
  github-desktop
#  unstable.lite-xl
#  unstable.zed-editor


  #internet
  librewolf  

  qbittorrent
  unstable.chromium
  unstable.onedrivegui
  unstable.onedrive

  #mis
  neothesia
  celeste
  fclones-gui
  unstable.labwc-tweaks-gtk
  unstable.labwc-menu-generator
  vlc 
  matugen
  usbimager
  unetbootin
  gtypist
  unstable.obsidian
  yazi

  #gaming
#  unstable.wineWowPackages.wayland  steam
  mupen64plus

  #bluetooth
  unstable.blueman

  #wayland
  unstable.labwc
  unstable.waybar
  fuzzel
  bemenu
  swww
  grim
  slurp
  swappy
  imagemagick
  swaylock-fancy
  wlsunset
  shotman
#  unstable.niri
  espanso-wayland
  wpgtk
  swayidle
  android-tools
  swaylock-effects
  unstable.xwayland
  kdePackages.qt6ct
  kdePackages.qtwayland
  libsForQt5.qt5.qtwayland
  
  #office
  inkscape
  pencil
  koreader

  #utilities
  xdg-desktop-portal-wlr
  xdg-desktop-portal-gtk
  kitty
  fontfinder
  git
  wget
  p7zip
  unzip
  nixos-generators
  gnome-keyring
  libgnome-keyring
  home-manager
  brightnessctl
  featherpad
  labwc-gtktheme
  fusuma
  networkmanagerapplet
  xfce.thunar-volman
  xfce.thunar-archive-plugin
  appimage-run
  libappimage
  xarchiver
  greetd.tuigreet
  pavucontrol
  unrar
  syncthingtray
  syncthing

  #iconsandcursors
  kanagawa-icon-theme
  phinger-cursors

  #theming
  themechanger
  kdePackages.qtstyleplugin-kvantum
 
  #themes
  kanagawa-gtk-theme
  unstable.graphite-gtk-theme
  numix-solarized-gtk-theme
  unstable.juno-theme
  papirus-icon-theme
  unstable.nordic
  unstable.tokyonight-gtk-theme
  fluent-icon-theme
  flat-remix-icon-theme
  unstable.gruvbox-plus-icons
  gruvbox-gtk-theme

  #llmgpt
#  gpt4all
#  local-ai
#  private-gpt
#  ollama
];

    programs.thunar.enable = true; # File manager
    programs.xfconf.enable = true; # Xfce configuration to allow storing preferences
    services.tumbler.enable = true; # Thumbnail support for images
    services.gvfs.enable = true; # Mount, trash, and other functionalities

  #fonts
fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "IosevkaTermSlab" ]; })
  (google-fonts.override {fonts = [ "Buenard" "Libre Franklin" "Overpass" "Overpass Mono" "Philosopher" "Mulish" "Tenor Sans" "Gentium Book Plus" "Sintony" "Poppins" "Oswald"
  "Merriweather" "Quattrocento" "Lora" "Raleway" "Cormorant Garamond" "Changa" "Merriweather Sans" "Arsenal"  ]; })
# lexend
  aileron
  font-awesome
  material-icons
];

nix.settings.experimental-features = [ "nix-command" "flakes" ];

services.gnome.gnome-keyring.enable = true;
services.onedrive.enable = true;
services.flatpak.enable = true;
xdg.portal.wlr.enable = true;
services.system-config-printer.enable = true;
services.syncthing.enable = true;
services.blueman.enable = true;
hardware.bluetooth.enable = true;
hardware.bluetooth.powerOnBoot = true;
services.dbus.enable = true;



programs.labwc.enable = true;
programs.wayfire.enable = true;
#programs.niri.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}

