# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  hardware.bluetooth.enable = true;
  boot.supportedFilesystems = ["ntfs"];
  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  virtualisation.docker.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    # LC_ADDRESS = "fil_PH";
    LC_IDENTIFICATION = "fil_PH";
    # LC_MEASUREMENT = "fil_PH";
    LC_MONETARY = "fil_PH";
    # LC_NAME = "fil_PH";
    # LC_NUMERIC = "fil_PH";
    LC_PAPER = "fil_PH";
    LC_TELEPHONE = "fil_PH";
    # LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  xdg.portal.enable = true;
  services.flatpak.enable = true;
  services.blueman.enable = true;

  programs.hyprland.enable = true;
  services.xserver = {
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
    enable = true;
    displayManager = {
      defaultSession = "none+xmonad";
      lightdm = {
        enable = true;
      };
    };
    windowManager = {
      xmonad = {
        enable = true;
      };
    };
    desktopManager.plasma5 = {
      enable = true;
    };
    layout = "us";
    xkbVariant = "";
  };

  services.upower.enable = true;

  services.postgresql = {
    enable = true;
    ensureDatabases = ["sandboxdb"];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  services.gnome = {
    gnome-keyring.enable = true;
    at-spi2-core.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.truff = {
    isNormalUser = true;
    description = "Home";
    extraGroups = ["networkmanager" "video" "docker" "wheel"];
    shell = pkgs.zsh;
    packages = [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  systemd.services.brightness = {
    enable = true;
    description = "Set brightness writable to everybody";
    unitConfig = {
      Type = "oneshot";
      Before = "nodered.service";
    };
    serviceConfig = {
      User = "root";
      ExecStart = ''
        /bin/sh -c "chgrp -R -H video /sys/class/backlight/intel_backlight && chmod g+w /sys/class/backlight/intel_backlight/brightness"
      '';
    };
    wantedBy = ["multi-user.target"];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    home-manager
    kitty
  ];

  environment.shells = with pkgs; [bashInteractive zsh];

  nix = {
    settings = {
      trusted-users = ["root" "truff"];
      allow-import-from-derivation = "true";
      experimental-features = ["nix-command" "flakes"];
      trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
      substituters = ["https://cache.iog.io"];
    };
  };

  # programs.light.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.zsh.enable = true;

  programs.dconf.enable = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  hardware.opentabletdriver.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  sound.enable = true;
  sound.mediaKeys.enable = true;

  hardware.pulseaudio.enable = false;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Open ports in the firewall.

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [3000 80 17500];
      allowedUDPPorts = [17500]; # 175000 for Dropbox
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # KDE Connect
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # KDE Connect
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}