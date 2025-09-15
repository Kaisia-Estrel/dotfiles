{ pkgs, ... }: {
  home.packages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    bacon
    android-studio
    androidenv.androidPkgs.platform-tools
    calibre
    p7zip
    lldb
    brave
    codeium
    grim
    manix
    dart-sass
    xmlstarlet
    (ags.overrideAttrs
      (old: { buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ]; }))
    imagemagick
    python312Packages.python-lsp-server
    ruff
    # davinci-resolve
    losslesscut-bin
    switcheroo
    simple-scan
    hyprlock
    socat
    satty
    d2
    hyprpaper
    rust-analyzer-nightly
    lua51Packages.luarocks-nix
    brightnessctl
    playerctl
    lua51Packages.lua
    alsa-utils
    hyprcursor
    # bitwarden-cli
    (discord.override { withVencord = true; })
    # betterdiscordctl
    element-desktop
    nodePackages_latest.bash-language-server
    libsForQt5.kdenlive
    krita
    zathura
    texlab
    gimp
    blender
    libreoffice
    vscode-langservers-extracted
    bun
    inotify-tools
    # graphviz
    nautilus
    loupe
    wineWowPackages.stable
    eza
    ffmpeg
    ncdu
    handbrake
    taplo

    prismlauncher
    nodePackages.typescript
    ispell
    texlive.combined.scheme-full
    imagemagick
    qalculate-gtk
    libqalculate
    libsForQt5.okular
    pavucontrol

    # unclutter
    xclip
    libnotify
    gnuplot
    ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]))
    exercism
    sqlite

    # zoom-us
    qemu
    virt-manager
    gtk-engine-murrine
    gtkmm4
    gtkmm3
    aseprite

    tldr
    zip
    ripgrep
    asciinema
    asciinema-agg
    pandoc
    file
    unzip
    fd
    grex
    neofetch
    trash-cli
    jq
    rlwrap
    gnumake
    python314
    gcc
    beautysh
    steam-run

    antibody
    acpi

    shellcheck
    appimage-run
    wakatime

    cbqn

    fennel

    nix-prefetch-github
    statix
    alejandra
    nixfmt-classic
    nil
    deadnix
    devenv

    marksman
    nodePackages.cspell
    # nodePackages.vscode-json-languageserver
    nodejs
    gpick
    wordnet
    xorg.xmodmap

    swaynotificationcenter
    wl-clipboard
    killall

    python312Packages.pygments

    usbutils
  ];
}
