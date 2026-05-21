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
