{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "26.05";
  home.sessionVariables.TERMINAL = "ghostty";

  imports = [ inputs.danksearch.homeModules.dsearch ];

  programs.dsearch = {
  	enable = true;
  	config = {
  		index_paths = [
  			{path = "~/Documentos"; max_depth = 6; exclude_hidden = true;}
  			{path = "~/Descargas"; max_depth = 4; exclude_hidden = true;}
  		];	
  	};
  };

  programs.ghostty = {
  	enable = true;
    settings = {
      # Font
      font-size = 12;

      # Window
      window-decoration = false;
      window-padding-x = 12;
      window-padding-y = 12;
      background-opacity = 1.0;
      background-blur-radius = 32;

      # Cursor
      cursor-style = "block";
      cursor-style-blink = true;

      # Scrollback
      scrollback-limit = 3023;

      # Terminal features
      mouse-hide-while-typing = true;
      copy-on-select = false;
      confirm-close-surface = false;
      app-notifications = "no-clipboard-copy,no-config-reload";

      # Material 3 / tabs
      unfocused-split-opacity = 0.7;
      unfocused-split-fill = "#44464f";
      gtk-titlebar = false;
      gtk-single-instance = true;

      # Shell integration
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title,no-cursor";

      # Tema generado por DMS
      theme = "dankcolors";

      # Keybinds (lista porque hay varios)
      keybind = [
        "ctrl+shift+n=new_window"
        "ctrl+t=new_tab"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+zero=reset_font_size"
        "shift+enter=text:\\n"
      ];
    };
  };
  
  xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox-devedition.desktop";
        "x-scheme-handler/http" = "firefox-devedition.desktop";
        "x-scheme-handler/https" = "firefox-devedition.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/avif" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "application/pdf" = "org.gnome.Papers.desktop";
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
      };
    };

    xdg.userDirs = {
         enable = true;
         createDirectories = true;
         desktop     = "$HOME/Escritorio";
         documents   = "$HOME/Documentos";
         download    = "$HOME/Descargas";
         music       = "$HOME/Música";
         pictures    = "$HOME/Imágenes";
         videos      = "$HOME/Vídeos";
         publicShare = "$HOME/Público";
         templates   = "$HOME/Plantillas";
       };
  home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Antonio Mata";
        email = "antoniomata99@hotmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
