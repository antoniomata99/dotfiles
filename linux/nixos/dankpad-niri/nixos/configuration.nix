# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

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

  # Set your time zone.
  time.timeZone = "America/Bogota";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_CO.UTF-8";

  i18n.supportedLocales = [
    "es_CO.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

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

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."amata" = {
    isNormalUser = true;
    description = "Antonio Mata";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "audio" "input"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	micro
	git
	mesa-demos
	libva-utils
	pciutils
	polkit_gnome
    wl-clipboard
    cliphist
    udiskie
    xdg-user-dirs
    brightnessctl
    pavucontrol
    papirus-icon-theme   # íconos bonitos compatibles con GNOME/Nautilus
    adwaita-icon-theme   # íconos base de GNOME (respaldo)
    gnome-themes-extra   # temas GTK extra
    imagemagick        # requerido por Noctalia internamente para wallpapers
    ntfs3g             # soporte NTFS para Nautilus
    exfatprogs         # soporte exFAT para Nautilus
    jq
    ffmpeg-full                     # ffmpeg con todos los codecs habilitados
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good      # VP8/VP9, FLAC, MP3, Ogg, etc.
    gst_all_1.gst-plugins-bad       # H.265/HEVC, AV1, etc.
    gst_all_1.gst-plugins-ugly      # H.264, MP3 (patentes)
    gst_all_1.gst-libav             # ffmpeg backend para GStreamer
    gst_all_1.gst-vaapi             # aceleración VAAPI para GStreamer

    # Chrome (unfree)
    # Chrome (unfree)
    (google-chrome.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })

    tree
    fastfetch
    gnome-text-editor
    loupe
    vlc
    desktop-file-utils
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
  services.openssh = {
  	enable = true;
  	settings = {
  		PermitRootLogin = "yes";
  		PasswordAuthentication = true;
  	};
  };

  # ──────────────────────────────────────────────
  # Intel HD 630 - iGPU
  # ──────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # ──────────────────────────────────────────────
  # NVIDIA GTX 1050 Mobile (Pascal)
  # ──────────────────────────────────────────────
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # ──────────────────────────────────────────────
  # Audio - PipeWire + WirePlumber
  # ──────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

  # ──────────────────────────────────────────────
  # Firmware, Bluetooth y grupos del usuario
  # ──────────────────────────────────────────────
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;

  # ──────────────────────────────────────────────
    # Niri - compositor Wayland
    # ──────────────────────────────────────────────
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri; # versión 25.11 de nixpkgs
  
    # ──────────────────────────────────────────────
    # Polkit - requerido para agentes de autenticación
    # ──────────────────────────────────────────────
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
  
    # ──────────────────────────────────────────────
    # XDG Portals - screencast, selectores de archivos
    # ──────────────────────────────────────────────
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome  # screencast para Niri
        xdg-desktop-portal-gtk    # selectores de archivos GTK
      ];
      configPackages = with pkgs; [ xdg-desktop-portal-gnome ];
    };
  
    # ──────────────────────────────────────────────
    # Variables de sesión Wayland (para toda la sesión)
    # ──────────────────────────────────────────────
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND              = "1";
      QT_QPA_PLATFORM                 = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER                 = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT    = "auto";
      NIXOS_OZONE_WL                  = "1";
      XDG_SESSION_TYPE                = "wayland";
      XDG_CURRENT_DESKTOP             = "niri";
      TERMINAL                        = "ghostty";
      LIBVA_DRIVER_NAME               = "iHD";
    };

    # ──────────────────────────────────────────────
    # greetd + sysc-greet (reemplaza tuigreet)
    # ──────────────────────────────────────────────
    services.sysc-greet = {
      enable = true;
      compositor = "niri";  # lanza Niri como greeter
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

# ──────────────────────────────────────────────
  # Sobreescribir el niri-greeter-config.kdl generado por sysc-greet
  # para añadir configuración de monitores y teclado latam
  # ──────────────────────────────────────────────
  environment.etc."greetd/niri-greeter-config.kdl" = lib.mkForce {
    text =
      let
        sysc-greet-pkg = inputs.sysc-greet.packages.${pkgs.stdenv.hostPlatform.system}.default;
      in ''
        hotkey-overlay {
            skip-at-startup
        }

        input {
            keyboard {
                xkb {
                    layout "latam"
                    options "grp:alt_shift_toggle"
                }
                repeat-delay 400
                repeat-rate 40
                numlock
            }
            touchpad {
                tap
                natural-scroll
                click-method "clickfinger"
            }
        }

        gestures {
            hot-corners {
                off
            }
        }

        // Render en Intel — igual que la sesión de usuario
        debug {
            render-drm-device "/dev/dri/by-path/pci-0000:00:02.0-render"
        }

        // Monitores — greeter aparece en HDMI-A-2 (centro)
        output "eDP-1" {
            mode "1920x1080@60.052"
            scale 1.0
            transform "normal"
            position x=0 y=180
        }
        output "HDMI-A-2" {
            mode "2560x1440@59.951"
            scale 1.0
            transform "normal"
            position x=1920 y=0
            focus-at-startup
        }
        output "DP-1" {
            mode "1920x1080@120.000"
            scale 1.0
            transform "normal"
            position x=4480 y=180
        }

        layer-rule {
            match namespace="^wallpaper$"
            place-within-backdrop true
        }

        layout {
            gaps 0
            center-focused-column "never"
            focus-ring {
                off
            }
            border {
                off
            }
        }

        animations {
            off
        }

        window-rule {
            match app-id="kitty"
            opacity 0.90
        }

        spawn-at-startup "gslapper" "-f" "-I" "/tmp/sysc-greet-wallpaper.sock" "*" "/usr/share/sysc-greet/wallpapers/sysc-greet-default.png"
        spawn-sh-at-startup "XDG_CACHE_HOME=/tmp/greeter-cache HOME=/var/lib/greeter ${pkgs.kitty}/bin/kitty --start-as=fullscreen --config=/etc/greetd/kitty.conf ${sysc-greet-pkg}/bin/sysc-greet; ${pkgs.niri}/bin/niri msg action quit --skip-confirmation"

        binds {
            Mod+Shift+E { quit; }
        }
      '';
  };

  # ──────────────────────────────────────────────
  # Zsh — shell por defecto del usuario amata
  # ──────────────────────────────────────────────
  programs.zsh.enable = true;
  users.users."amata".shell = pkgs.zsh;

  # ──────────────────────────────────────────────
  # Fuentes — JetBrainsMono Nerd Font para Ghostty y Noctalia
  # ──────────────────────────────────────────────
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      cantarell-fonts
      inter
      corefonts
      carlito
      caladea
      liberation_ttf
      roboto
      source-sans-pro
      lato
      open-sans
      montserrat
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Inter" "Noto Sans" "Liberation Sans" ];
        serif     = [ "Liberation Serif" "Caladea" "Noto Serif" ];
        monospace = [ "JetBrainsMono Nerd Font" "Liberation Mono" ];
        emoji     = [ "Noto Color Emoji" ];
      };
    };
  };

  

  # ──────────────────────────────────────────────
    # Servicios requeridos por Noctalia
    # (wifi, bluetooth y batería ya activos; añadir estos dos)
    # ──────────────────────────────────────────────
    services.power-profiles-daemon.enable = true;  # widget de perfil de energía
    services.upower.enable = true;                 # widget de batería
  
    # ──────────────────────────────────────────────
    # gvfs + udisks2 — auto-montaje para Nautilus y udiskie
    # ──────────────────────────────────────────────
    services.gvfs.enable = true;
    services.udisks2.enable = true;
  
    # ──────────────────────────────────────────────
    # PAM — lockscreen de Noctalia (Super+L)
    # Noctalia no incluye su propio módulo PAM; apuntamos al servicio "login"
    # ──────────────────────────────────────────────
    security.pam.services.noctalia = {};  # crea /etc/pam.d/noctalia usando la config por defecto
    environment.sessionVariables.NOCTALIA_PAM_SERVICE = "noctalia";
  
  system.stateVersion = "26.05"; # Did you read the comment?

}
