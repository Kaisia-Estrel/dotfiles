{ username, config, inputs, ... }: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    preferXdgDirectories = true;
    stateVersion = "23.05";
    sessionVariables = with config.xdg; {
      HISTFILE = "${stateHome}/bash/history";
      CABAL_CONFIG = "${configHome}/cabal/config";
      CABAL_DIR = "${dataHome}/cabal";
      CARGO_HOME = "${dataHome}/cargo";
      GNUPGHOME = "${dataHome}/gnupg";
      XCOMPOSECACHE = "${cacheHome}/x11/xcompose";
      ERRFILE = "${cacheHome}/X11/xsession-errors";
    };
  };

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
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

  xsession = { numlock.enable = true; };
}
