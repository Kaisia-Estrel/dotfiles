# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, options, config, username, inputs, overlays, ... }: {

  imports = [ ./hardware-configuration.nix ./network.nix ];

  boot = {
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    supportedFilesystems = [ "ntfs" ];
    plymouth = { enable = true; };
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
      magicOrExtension = "\\x7fELF....AI\\x02";
    };

  };

  stylix = {
    enable = true;
    targets = {
      grub = { enable = true; };
      # firefox.profileNames = [ ];

      gtk.enable = true;
      lightdm.enable = false;
    };
    image = ./data/background.png;
    polarity = "dark";
    cursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 12;
      name = "catppuccin-mocha-dark-cursors";
    };
    opacity.terminal = 0.8;
    base16Scheme = {
      base00 = "1e1e2e"; # base
      base01 = "181825"; # mantle
      base02 = "313244"; # surface0
      base03 = "45475a"; # surface1
      base04 = "585b70"; # surface2
      base05 = "cdd6f4"; # text
      base06 = "f5e0dc"; # rosewater
      base07 = "b4befe"; # lavender
      base08 = "f38ba8"; # red
      base09 = "fab387"; # peach
      base0A = "f9e2af"; # yellow
      base0B = "a6e3a1"; # green
      base0C = "94e2d5"; # teal
      base0D = "89b4fa"; # blue
      base0E = "cba6f7"; # mauve
      base0F = "f2cdcd"; # flamingo
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      sansSerif = {
        package = pkgs.roboto;
        name = "Roboto";
      };

      serif = {
        package = pkgs.roboto-serif;
        name = "Roboto Serif";
      };

      sizes = {
        applications = 12;
        terminal = 11;
        desktop = 11;
        popups = 12;
      };
    };
  };

  networking = {
    hostName = "nixos";
    timeServers = [ "ntp.ubuntu.com" ]
      ++ options.networking.timeServers.default;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3000 80 443 17500 8080 9100 50001 57621 ];
      # 50001: codeium
      # 57621: spotify
      allowedUDPPorts = [ 17500 8080 5353 ]; # 175000 for Dropbox
      # 5353: spotify
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }]; # KDE Connect
      allowedUDPPortRanges = [{
        from = 1714;
        to = 1764;
      }]; # KDE Connect
    };
  };

  services = {

    udisks2.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 80;

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
    };

    locate = { enable = true; };
    xserver = {
      enable = true;
      xkb = {
        options = "caps:escape_shifted_capslock";
        layout = "us";
      };
    };
    touchegg.enable = true;
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        middleEmulation = true;
      };
      mouse = {
        middleEmulation = false;
        accelProfile = "flat";
        accelSpeed = "-0.5";
      };
    };
    flatpak.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "where-is-my-sddm-theme-catppuccin";
        package = pkgs.kdePackages.sddm;
      };
      defaultSession = "hyprland";
    };
    upower.enable = true;
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandleLidSwitch = "suspend-then-hibernate";
    };
    gnome = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true;
    };
    openssh.enable = true;

    pipewire = {
      enable = true;
      wireplumber = { enable = true; };
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    resolved = { enable = true; };

    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 pkgs.gutenprint ];
    };
    ipp-usb.enable = true;

    blueman.enable = true;
    # Did you read the comment?

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          security = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          "path" = "/mnt/Shares/Public";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "username";
          "force group" = "groupname";
        };
        "private" = {
          "path" = "/mnt/Shares/Private";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "username";
          "force group" = "groupname";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=15m
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  powerManagement.enable = true;

  programs = {
    # nm-applet = {
    #   enable = true;
    #   indicator = true;
    # };
    sway = { enable = true; };
    # river = { enable = true; };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    waybar = { enable = true; };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    zsh.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
  };
  virtualisation = {

    docker.enable = true;
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    waydroid.enable = true;
    libvirtd.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_IDENTIFICATION = "fil_PH";
    LC_MONETARY = "fil_PH";
    LC_PAPER = "fil_PH";
    LC_TELEPHONE = "fil_PH";
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "Home";
    extraGroups = [
      "networkmanager"
      "video"
      "docker"
      "wheel"
      "libvirtd"
      "input"
      "kvm"
      "adbusers"
    ];
    shell = pkgs.zsh;
    packages = [ ];
  };

  environment = {

    etc."dict.conf".text = "server dict.org";
    systemPackages = with pkgs; [
      vim
      kitty
      killall
      eza
      git
      dict
      libinput-gestures
      qpwgraph
      wmctrl
      wl-clipboard
      pciutils
      ripgrep
      hyprpicker
      ninja
      wlogout
      brightnessctl
      appimage-run
      networkmanagerapplet
      playerctl
      file-roller
      swaynotificationcenter
      pavucontrol
      lxqt.lxqt-policykit
      where-is-my-sddm-theme-catppuccin
    ];
    shells = with pkgs; [ bashInteractive zsh ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      font-awesome
      material-icons
      liberation_ttf_v1
      iosevka
      raleway-overlay
      etBook
      times-newer-roman
      nerd-fonts.jetbrains-mono
      (google-fonts.override {
        fonts = [ "Space Grotesk" "Roboto" "Bebas Neue" "Anton" ];
      })
      newcomputermodern
      source-sans-pro
      feather
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  hardware = {

    # Scanners 
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };

    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        intel-compute-runtime
        vpl-gpu-rt
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  security.rtkit.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";

  networking.firewall.allowPing = true;

  nixpkgs.overlays = overlays;
  nixpkgs.config.allowUnfree = true;
  nix = {

    settings = {
      trusted-users = [ "root" username ];
      auto-optimise-store = true;
      allow-import-from-derivation = "true";
      experimental-features = [ "nix-command" "flakes" ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      substituters = [ "https://cache.iog.io" "https://hyprland.cachix.org" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

}
