# home.nix — entorno del usuario amata en dankpad
# Correcciones aplicadas:
#   - initExtraBeforeCompInit/initExtra → initContent (deprecados en HM actual)
#   - git userName/userEmail/extraConfig/delta → nueva sintaxis
#   - programs.delta separado de programs.git
#   - aliases de NixOS con # protegido con comillas simples
#   - F-Sy-H con colores Kanagawabones distintivos
#   - Un único bloque home.packages

{ config, pkgs, lib, inputs, ... }:
{
  home.username    = "amata";
  home.homeDirectory = "/home/amata";
  home.stateVersion  = "26.05";
  programs.home-manager.enable = true;

  # ──────────────────────────────────────────────
  # Paquetes del usuario
  # ──────────────────────────────────────────────
  home.packages = with pkgs; [
    nautilus
    ghostty
    spotify
    # Terminal
    eza
    ripgrep
    fd
    lazygit
    yazi
    btop
    unzip
    p7zip
    tldr
    papers
    nil
    obsidian
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    languagePacks = [ "es-MX" ];
    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        # Idioma español México
        "intl.locale.requested"          = "es-MX";
        "intl.accept_languages"          = "es-MX, es, en-US, en";
        # VAAPI — aceleración Intel HD 630
        "media.ffmpeg.vaapi.enabled"                  = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.hardware-video-decoding.enabled"       = true;
        # Portales XDG (Wayland)
        "widget.use-xdg-desktop-portal.mime-handler"  = 1;
        "widget.use-xdg-desktop-portal.file-picker"   = 1;
        # DNS sobre HTTPS — Cloudflare
        "network.trr.mode" = 2;
        "network.trr.uri"  = "https://mozilla.cloudflare-dns.com/dns-query";
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg"    = "org.gnome.Loupe.desktop";
      "image/png"     = "org.gnome.Loupe.desktop";
      "image/gif"     = "org.gnome.Loupe.desktop";
      "image/webp"    = "org.gnome.Loupe.desktop";
      "image/tiff"    = "org.gnome.Loupe.desktop";
      "image/bmp"     = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";

      "application/pdf"      = "org.gnome.Papers.desktop";
      "application/epub+zip" = "org.gnome.Papers.desktop";
    };
  };

  programs.vscode = {
      enable  = true;
      package = pkgs.vscode;  # ← versión propietaria Microsoft
      # package = pkgs.vscodium;  # alternativa libre si algún día prefieres
  
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # ── Nix ───────────────────────────────
          jnoortheen.nix-ide          # syntax, formatting y LSP para .nix
  
          # ── Tema visual ───────────────────────
          catppuccin.catppuccin-vsc        # tema Catppuccin (coherente con tu sistema)
          catppuccin.catppuccin-vsc-icons  # íconos Catppuccin
  
          # ── Git ───────────────────────────────
          eamodio.gitlens             # historial git inline, blame, etc.
  
          # ── Utilidades ────────────────────────
          esbenp.prettier-vscode      # formateador universal
          streetsidesoftware.code-spell-checker  # corrector ortográfico
          usernamehw.errorlens        # errores inline en el código
        ];
  
        userSettings = {
          "editor.fontFamily"        = "JetBrainsMono Nerd Font";
          "editor.fontSize"          = 14;
          "editor.fontLigatures"     = true;
          "editor.tabSize"           = 2;
          "editor.formatOnSave"      = true;
          "editor.minimap.enabled"   = false;
          "workbench.colorTheme"     = "Catppuccin Mocha";
          "workbench.iconTheme"      = "catppuccin-mocha";
          "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
          "telemetry.telemetryLevel" = "off";  # desactivar telemetría Microsoft
          "update.mode"              = "none"; # NixOS gestiona las actualizaciones
          "nix.enableLanguageServer" = true;
          "nix.serverPath"           = "nil";  # LSP de Nix
        };
      };
    };

  # ──────────────────────────────────────────────
  # GTK — apariencia GNOME vanilla
  # ──────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name    = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name    = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name    = "Cantarell";
      size    = 11;
      package = pkgs.cantarell-fonts;
    };
    cursorTheme = {
      name    = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size    = 24;
    };
  };

  home.pointerCursor = {
    name    = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size    = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # ──────────────────────────────────────────────
  # Noctalia Shell v4
  # ⚠ settings.json = symlink read-only.
  #   Para sincronizar cambios de GUI:
  #   Ajustes → General → Copy Settings
  # ──────────────────────────────────────────────
  programs.noctalia-shell = {
    enable = true;
    settings = {

      colorSchemes = {
        predefinedScheme = "Kanagawa Paper";
        darkMode         = true;
        useWallpaperColors = false;
        syncGsettings    = true;
      };

      ui = {
        fontDefault          = "Inter";
        fontFixed            = "JetBrainsMono Nerd Font";
        fontDefaultScale     = 1;
        fontFixedScale       = 1;
        tooltipsEnabled      = true;
        scrollbarAlwaysVisible = true;
        panelBackgroundOpacity = 0.93;
      };

      bar = {
        barType         = "simple";
        position        = "top";
        displayMode     = "always_visible";
        backgroundOpacity = 0.93;
        marginVertical  = 4;
        marginHorizontal = 4;
        frameRadius     = 12;
        showCapsule     = true;
        widgets = {
          left = [
            { id = "Launcher"; icon = "rocket"; }
            {
              id = "Clock";
              formatHorizontal = "dddd dd MMMM yyyy - h:mm:ss AP";
              formatVertical   = "HH mm - dd MM";
              tooltipFormat    = "HH:mm ddd, MMM dd";
              useCustomFont    = false;
            }
            {
              id             = "SystemMonitor";
              compactMode    = true;
              diskPath       = "/";
              showCpuTemp    = true;
              showCpuUsage   = true;
              showMemoryUsage = true;
              useMonospaceFont = true;
            }
            {
              id            = "ActiveWindow";
              hideMode      = "hidden";
              maxWidth      = 145;
              scrollingMode = "hover";
              showIcon      = true;
              showText      = true;
            }
            {
              id              = "MediaMini";
              hideMode        = "hidden";
              hideWhenIdle    = false;
              maxWidth        = 145;
              showAlbumArt    = true;
              showArtistFirst = true;
              showProgressRing = true;
            }
          ];
          center = [
            {
              id             = "Workspace";
              labelMode      = "index";
              focusedColor   = "primary";
              occupiedColor  = "secondary";
              fontWeight     = "bold";
              enableScrollWheel = true;
              showBadge      = true;
              showLabelsOnlyWhenOccupied = true;
            }
          ];
          right = [
            { id = "Tray";                drawerEnabled = true;  hidePassive = false; }
            { id = "NotificationHistory"; showUnreadBadge = true; unreadBadgeColor = "primary"; }
            { id = "Battery";             displayMode = "graphic-clean"; hideIfNotDetected = true; }
            { id = "Volume";              displayMode = "onhover"; middleClickCommand = "pwvucontrol || pavucontrol"; }
            { id = "Brightness";          displayMode = "onhover"; applyToAllMonitors = false; }
            { id = "ControlCenter";       icon = "noctalia"; }
          ];
        };
      };

      location = {
        name                 = "Bogotá";
        autoLocate           = true;
        weatherEnabled       = true;
        useFahrenheit        = false;
        use12hourFormat      = true;
        showWeekNumberInCalendar = false;
        showCalendarEvents   = true;
        showCalendarWeather  = true;
      };

      dock = {
        enabled       = true;
        position      = "bottom";
        displayMode   = "auto_hide";
        dockType      = "floating";
        onlySameOutput = true;
        pinnedApps    = [];
      };

      appLauncher = {
        position            = "center";
        sortByMostUsed      = true;
        terminalCommand     = "ghostty -e";
        viewMode            = "list";
        showCategories      = true;
        enableClipboardHistory = false;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        enableSessionSearch = true;
      };

      wallpaper = {
        enabled               = true;
        overviewEnabled       = false;
        directory             = "/home/amata/Pictures/Wallpapers";
        fillMode              = "crop";
        setWallpaperOnAllMonitors = true;
        transitionDuration    = 1500;
        transitionType        = [ "fade" "disc" "stripes" "wipe" "pixelate" "honeycomb" ];
      };

      notifications = {
        enabled                  = true;
        location                 = "top_right";
        lowUrgencyDuration       = 3;
        normalUrgencyDuration    = 8;
        criticalUrgencyDuration  = 15;
        enableBatteryToast       = true;
        enableKeyboardLayoutToast = true;
      };

      general = {
        lockOnSuspend        = true;
        enableBlurBehind     = true;
        enableShadows        = true;
        telemetryEnabled     = false;
        showChangelogOnStartup = true;
        clockStyle           = "custom";
        clockFormat          = "hh\\nmm";
      };
    };
  };

  # ──────────────────────────────────────────────
  # Starship — prompt Rust, 5-15ms
  # Reemplaza Powerlevel10k (abandonado 2024)
  # ──────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        $directory$git_branch$git_status$nodejs$python$rust$golang$java$nix_shell$cmd_duration
        $character'';

      character = {
        success_symbol = "[❯](bold #98BC6D)";
        error_symbol   = "[❯](bold #E46A78)";
        vimcmd_symbol  = "[❮](bold #957FB8)";
      };

      directory = {
        style             = "bold #E5C283";
        truncation_length = 3;
        truncate_to_repo  = true;
        read_only         = " 󰌾";
        read_only_style   = "#E46A78";
      };

      git_branch = {
        symbol = " ";
        style  = "bold #7EB3C9";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        style      = "#E46A78";
        conflicted = "⚡";
        ahead      = "⇡\${count}";
        behind     = "⇣\${count}";
        diverged   = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "[✓](bold #98BC6D)";
        untracked  = "?";
        stashed    = "≡";
        modified   = "!";
        staged     = "+";
        renamed    = "»";
        deleted    = "✘";
      };

      nodejs = {
        symbol = " ";
        style  = "#98BC6D";
        format = "[$symbol($version)]($style) ";
      };

      python = {
        symbol = " ";
        style  = "#E5C283";
        format = "[\${symbol}\${pyenv_prefix}(\${version})(\($virtualenv\))]($style) ";
      };

      rust = {
        symbol = " ";
        style  = "#E46A78";
        format = "[$symbol($version)]($style) ";
      };

      golang = {
        symbol = " ";
        style  = "#7EB3C9";
        format = "[$symbol($version)]($style) ";
      };

      java = {
        symbol = " ";
        style  = "#957FB8";
        format = "[$symbol($version)]($style) ";
      };

      nix_shell = {
        symbol     = " ";
        style      = "bold #7EB3C9";
        format     = "[$symbol$state(\($name\))]($style) ";
        impure_msg = "[impure](bold #E46A78)";
        pure_msg   = "[pure](bold #98BC6D)";
      };

      cmd_duration = {
        min_time = 2000;
        style    = "#A8A48D";
        format   = "[$duration]($style) ";
      };

      package.disabled  = true;
      aws.disabled      = true;
      gcloud.disabled   = true;
      azure.disabled    = true;
    };
  };

  # ──────────────────────────────────────────────
  # Zsh — shell completo con rice Kanagawabones
  # ──────────────────────────────────────────────
  programs.zsh = {
    enable             = true;
    enableCompletion   = true;
	completionInit = "autoload -U compinit && compinit -u";

    autosuggestion.enable      = true;

    syntaxHighlighting = {
      enable = true;   # ← activar, ya no usamos F-Sy-H manual
      styles = {
        # Comandos
        "command"                = "fg=#98BC6D,bold";
        "unknown-token"          = "fg=#E46A78,bold,underline";
        "alias"                  = "fg=#9EC967,bold";
        "builtin"                = "fg=#7EB3C9,bold";
        "function"               = "fg=#957FB8,bold";
        "precommand"             = "fg=#E5C283,bold,italic";
        # Argumentos
        "single-quoted-argument" = "fg=#E5C283";
        "double-quoted-argument" = "fg=#E5C283";
        "dollar-quoted-argument" = "fg=#F1C982";
        # Flags
        "single-hyphen-option"   = "fg=#7BC2DF,bold";
        "double-hyphen-option"   = "fg=#7BC2DF,bold";
        # Rutas y otros
        "path"                   = "fg=#DDD8BB,underline";
        "comment"                = "fg=#3C3C51,italic";
        "redirection"            = "fg=#F1C982,bold";
        "commandseparator"       = "fg=#E46A78";
        "globbing"               = "fg=#957FB8";
        "history-expansion"      = "fg=#957FB8,bold";
      };
    };
    
    plugins = [
      {
        # Búsqueda en historial con flechas ↑↓
        name = "zsh-history-substring-search";
        src  = "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search";
      }
      {
        # Completions adicionales para muchas herramientas CLI
        name = "zsh-completions";
        src  = "${pkgs.zsh-completions}/share/zsh/site-functions";
      }
    ];

    history = {
      size        = 50000;
      save        = 50000;
      ignoreDups  = true;
      ignoreSpace = true;
      share       = true;
    };

    shellAliases = {
      # ── eza reemplaza ls ──────────────────
      ls  = "eza --icons=auto --group-directories-first --color=auto";
      ll  = "eza --icons=auto --group-directories-first -l --git --color=auto";
      la  = "eza --icons=auto --group-directories-first -la --git --color=auto";
      lt  = "eza --icons=auto --tree --level=2 --group-directories-first";
      lta = "eza --icons=auto --tree --level=2 --group-directories-first -a";

      # ── bat reemplaza cat ─────────────────
      cat  = "bat --paging=never --style=numbers,changes,header-filename";
      catp = "bat --style=numbers,changes,header-filename";

      # ── Navegación ────────────────────────
      ".."   = "cd ..";
      "..."  = "cd ../..";
      "...." = "cd ../../..";

      # ── Utilidades ────────────────────────
      grep = "grep --color=auto";
      df   = "df -h";
      du   = "du -h";
      free = "free -h";

      # ── NixOS shortcuts ───────────────────
      # Comillas simples protegen el # de ser interpretado como comentario por zsh
      nrs = "sudo nixos-rebuild switch --flake '/etc/nixos#dankpad'";
      nrt = "sudo nixos-rebuild test   --flake '/etc/nixos#dankpad'";
      nfu = "sudo nix flake update /etc/nixos";
      ngc = "sudo nix-collect-garbage --delete-older-than 30d";
      nse = "nix search nixpkgs";

      # ── Git shortcuts ─────────────────────
      g  = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph --decorate";
      lg = "lazygit";

      # ── Editor ────────────────────────────
      m = "micro";
    };

    # initContent reemplaza initExtraBeforeCompInit e initExtra (deprecados)
    # lib.mkMerge combina bloques con distinta prioridad de orden
    initContent = lib.mkMerge [

    (lib.mkOrder 550 ''
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#957FB8"
    '')

      # Orden por defecto (900) — se ejecuta DESPUÉS de compinit
      ''
        # ── Flechas para buscar en historial ──
        bindkey "^[[A" history-substring-search-up
        bindkey "^[[B" history-substring-search-down
        bindkey "$terminfo[kcuu1]" history-substring-search-up
        bindkey "$terminfo[kcud1]" history-substring-search-down

        # ── Completion con menú y colores ──
        zstyle ":completion:*" list-colors "''${(s.:.)LS_COLORS}"
        zstyle ":completion:*" menu select
        zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
        zstyle ":completion:*:descriptions" format "[%d]"

        # ── Opciones de Zsh ─────────────────
        setopt AUTO_CD
        setopt GLOB_DOTS
        setopt NO_BEEP

        # ── Variables de entorno ────────────
        export EDITOR="micro"
        export VISUAL="micro"
        export PAGER="bat --paging=always"
        export MANPAGER="sh -c 'col -bx | bat -l man --paging=always'"

        # ── FZF con colores Kanagawabones ──
        export FZF_DEFAULT_OPTS="
          --color=bg+:#3C3C51,bg:#1F1F28,spinner:#957FB8,hl:#E46A78
          --color=fg:#DDD8BB,header:#E46A78,info:#7EB3C9,pointer:#957FB8
          --color=marker:#98BC6D,fg+:#DDD8BB,prompt:#7EB3C9,hl+:#E46A78
          --border rounded --height 40% --layout reverse
        "
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

        # ── EZA con colores Kanagawabones ──
        export EZA_COLORS="da=#7EB3C9:di=1;33:ln=36:ex=32:*.nix=35"
      ''
    ];
  };

  # ──────────────────────────────────────────────
  # bat — cat con syntax highlighting
  # base16 hereda los colores ANSI del terminal (Kanagawabones desde Ghostty)
  # ──────────────────────────────────────────────
  programs.bat = {
    enable = true;
    config = {
      theme       = "base16";
      style       = "numbers,changes,header-filename,grid";
      italic-text = "always";
      pager       = "less -FR";
    };
  };

  # ──────────────────────────────────────────────
  # fzf — fuzzy finder
  # Ctrl+R → historial | Ctrl+T → archivos | Alt+C → directorios
  # ──────────────────────────────────────────────
  programs.fzf = {
    enable              = true;
    enableZshIntegration = true;
  };

  # ──────────────────────────────────────────────
  # zoxide — cd inteligente (aprende carpetas frecuentes)
  # ──────────────────────────────────────────────
  programs.zoxide = {
    enable              = true;
    enableZshIntegration = true;
    options             = [ "--cmd cd" ];
  };

  # ──────────────────────────────────────────────
  # eza — ls moderno con iconos y git
  # ──────────────────────────────────────────────
  programs.eza = {
    enable              = true;
    enableZshIntegration = false;  # aliases manuales definidos arriba
    icons               = "auto";
    git                 = true;
    extraOptions        = [ "--group-directories-first" "--color=auto" ];
  };

  # ──────────────────────────────────────────────
  # git — nueva sintaxis de Home Manager
  # ──────────────────────────────────────────────
  programs.git = {
    enable   = true;
    settings = {
      user.name          = "Antonio Mata";
      user.email         = "antoniomata99@hotmail.com";
      core.editor        = "micro";
      pull.rebase        = false;
      init.defaultBranch = "main";
    };
  };

  # delta — diff bonito (separado de programs.git en HM actual)
  programs.delta = {
    enable               = true;
    enableGitIntegration = true;
    options = {
      navigate     = true;
      side-by-side = false;
      syntax-theme = "base16";
      line-numbers = true;
    };
  };

  # ──────────────────────────────────────────────
  # Fuentes
  # ──────────────────────────────────────────────
  fonts.fontconfig.enable = true;

  # ──────────────────────────────────────────────
  # Carpetas XDG en español
  # ──────────────────────────────────────────────
  xdg.userDirs = {
    enable            = true;
    createDirectories = true;
    desktop     = "${config.home.homeDirectory}/Escritorio";
    documents   = "${config.home.homeDirectory}/Documentos";
    download    = "${config.home.homeDirectory}/Descargas";
    music       = "${config.home.homeDirectory}/Música";
    videos      = "${config.home.homeDirectory}/Vídeos";
    pictures    = "${config.home.homeDirectory}/Imágenes";
    templates   = "${config.home.homeDirectory}/Plantillas";
    publicShare = "${config.home.homeDirectory}/Público";
  };
}
