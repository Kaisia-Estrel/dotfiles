{
  pkgs,
  username,
  config,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    preferXdgDirectories = true;
    stateVersion = "23.05";
    shell = {
      enableNushellIntegration = true;
    };
    # pointerCursor.size = 64;
    sessionVariables = with config.xdg; {
      HISTFILE = "${stateHome}/bash/history";
      CABAL_CONFIG = "${configHome}/cabal/config";
      CABAL_DIR = "${dataHome}/cabal";
      CARGO_HOME = "${dataHome}/cargo";
      GNUPGHOME = "${dataHome}/gnupg";
      XCOMPOSECACHE = "${cacheHome}/x11/xcompose";
      ERRFILE = "${cacheHome}/X11/xsession-errors";
      NEOVIDE_MULTIGRID = "true";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      NIXOS_OZONE_WL = "1";
    };

    shellAliases = {
      ytmp3 = "yt-dlp -f 'ba' -x --audio-format mp3";
      detach = "kitten @ detach-window";
      clone = "kitty --detach";
      cat = "bat";
      cd = "z";
      icat = "kitty +kitten icat";
      py = "python";
    };

    sessionSearchVariables = {
      XDG_DATA_DIRS = [
        "/var/lib/flatpak/exports/share"
        "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
      ];
    };
  };

  imports = [
    ./packages.nix
    ./programs
    ./services
    ./share
    ./hyprland
  ];

  stylix.enable = true;
  stylix.targets.neovim.enable = false;

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  manual.json.enable = true;

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  xsession = {
    numlock.enable = true;
  };
}
