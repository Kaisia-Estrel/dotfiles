{ pkgs, ... }: {
  services = {
    # clipman.enable = true;
    gnome-keyring.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;
    };

    status-notifier-watcher.enable = true;
    # blueman-applet.enable = true;
    mpris-proxy.enable = true;

  };

}
