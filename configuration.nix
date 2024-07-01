# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
	[ # Include the results of the hardware scan.
  	./hardware-configuration.nix
	];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nano"; # Define your hostname.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the LXQT Desktop Environment.
  # services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;  
  services.xserver.desktopManager.lxqt.enable = true;

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
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim 
  # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget

  #coding
  vscodium-fhs
  nodejs_22
  bun
  github-desktop


  #internet
  librewolf
  qbittorrent
  joplin-desktop
  brave
  onedriver

  #mis
  neothesia
  drawio
  celeste
  fclones-gui
  labwc
  labwc-tweaks-gtk
  labwc-menu-generator
  waybar
  fuzzel
  niri
  bemenu
  abiword
  vlc
  swww
  nwg-bar
  rustdesk
  matugen
  usbimager

  
  #office
  mailspring
  apostrophe
  inkscape
  pencil

  #utilities
  gparted
  kitty
  fontfinder
  git
  wget
  p7zip
  unzip
  nixos-generators
  gnome.gnome-keyring
  libgnome-keyring
  home-manager
  brightnessctl
  featherpad
  labwc-gtktheme
  fusuma
  ventoy-full
  networkmanagerapplet
  nwg-panel
  nwg-look
  nwg-menu

  #iconsandcursors
  kanagawa-icon-theme
  gruvbox-dark-icons-gtk
  phinger-cursors
  graphite-kde-theme
  vimix-icon-theme

  #theming
  themechanger
  kdePackages.qtstyleplugin-kvantum
 
  #themes
  kanagawa-gtk-theme
  graphite-gtk-theme
  gruvbox-gtk-theme
  matcha-gtk-theme
  numix-solarized-gtk-theme
  colloid-gtk-theme
  colloid-kde
  colloid-icon-theme
  papirus-icon-theme
  lightly-qt
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
  lexend
  aileron
];

nix.settings.experimental-features = [ "nix-command" "flakes" ];

services.gnome.gnome-keyring.enable = true;
services.onedrive.enable = true;

programs.labwc.enable = true;

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
