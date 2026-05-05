{ pkgs, config, ... }:
{

  home.file.".local/share/dict" = {
    recursive = true;
    source = "${pkgs.scowl}/share/dict";
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = import ./mimetypes.nix;

    };
    desktopEntries = {
      "Doom Emacs" = {
        type = "Application";
        terminal = false;
        name = "Doom Emacs";
        icon = "emacs";
        mimeType = [
          "text/english"
          "text/plain"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
        exec = "${config.xdg.configHome}/emacs/bin/doom run";
        categories = [
          "Development"
          "TextEditor"
        ];
      };
      "PureRef" = {
        type = "Application";
        terminal = false;
        name = "PureRef";
        icon = ./data/PureRef.png;
        exec =
          let
            pureRef = pkgs.requireFile {
              name = "PureRef-2.1.2_x64.Appimage";
              sha256 = "16fwpxw402wrxlbb66lrhsgacmvyjbpjrglpl5ps7kvkamb9cpav";
              url = "https://www.pureref.com/download.php";
            };
          in
          "${pkgs.appimage-run}/bin/appimage-run ${pureRef}";
      };
    };
  };

  qt = {
    enable = true;
    # style.package = pkgs.adwaita-qt;
    # style.name = "adwaita-dark";
    # platformTheme.name = "gtk3";
  };

  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.theme = config.gtk.theme;
  };
}
