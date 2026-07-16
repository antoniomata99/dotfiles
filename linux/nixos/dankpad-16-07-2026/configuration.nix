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

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "dankpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [22];
  # Set your time zone.
  time.timeZone = "America/Bogota";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_CO.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

	services.openssh = {
		enable = true;
		ports = [22];
		settings = {
			PasswordAuthentication = true;
			PermitRootLogin = "no";
	};

};

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."amata" = {
    isNormalUser = true;
    description = "Antonio Mata";
    extraGroups = [ "networkmanager" "wheel" "input"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	micro
	alsa-utils
	pavucontrol
	wireplumber
	pciutils
	mesa-demos
	nautilus
	file-roller
	ntfs3g
	exfatprogs
	hfsprogs
	firefox-devedition
	ffmpeg-full
	gst_all_1.gst-plugins-base
	gst_all_1.gst-plugins-good
	gst_all_1.gst-plugins-bad
	gst_all_1.gst-plugins-ugly
	gst_all_1.gst-libav
	libva-utils
	vlc
	loupe
	papers
	fastfetch
	spotify
	git
  ];

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

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = [ "gnome" "gtk" ];
  };

  services.flatpak.enable = true;

  ## Firefox ##
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
  ## Fuentes ##
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
  	noto-fonts
  	noto-fonts-cjk-sans
  	noto-fonts-color-emoji
  	inter
  	adwaita-fonts
  	material-symbols
  	nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.defaultFonts = {
  	sansSerif = [ "Adwaita Sans" "Noto Sans" ];
  	serif     = [ "Noto Serif" ];
  	monospace = [ "JetBrainsMono Nerd Font" ];
  	emoji     = [ "Noto Color Emoji" ];
  };
  ## Graficos ##
  hardware.graphics = {
  	enable = true;
  	enable32Bit = true;
  	extraPackages = with pkgs; [
  		intel-media-driver
  		libva-vdpau-driver
  		libvdpau-va-gl
  	];
  };

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
  	modesetting.enable = true;
  	open = false;
  	nvidiaSettings = true;
  	powerManagement.enable = false;
  	package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

	prime = {
	  offload.enable = true;
	  offload.enableOffloadCmd = true;
	  intelBusId  = "PCI:0:2:0";
	  nvidiaBusId = "PCI:1:0:0";
	};
  };

  ## Red ##
  hardware.enableRedistributableFirmware = true;

  ## Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  ## Audio
  services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

  ## Servicios de Energía ##
    services.power-profiles-daemon.enable = true;
    services.thermald.enable = true;
    services.upower.enable = true;
    powerManagement.enable = true;

  ## DMS ##
  programs.niri.enable = true;

  programs.dms-shell = {
  	enable = true;
  	systemd = {
  		enable = true;
  		restartIfChanged = true;
  	};
  	enableSystemMonitoring = true;
  	enableVPN = true;
  	enableDynamicTheming = true;
  	enableAudioWavelength = true;
  	enableCalendarEvents = true;
  };

  # DankGreeter (login)

  services.displayManager.dms-greeter = {
  	enable = true;
  	compositor.name = "niri";
  	configHome = "/home/amata";
  };
  
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
  system.stateVersion = "26.05"; # Did you read the comment?

}
