{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    # packet
    kdePackages.dolphin

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
    # xmlstarlet
    # (ags.overrideAttrs (old: {
    #   buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
    # }))
    imagemagick
    neovim
    # python312Packages.python-lsp-server
    ruff
    # davinci-resolve
    losslesscut-bin
    # switcheroo
    simple-scan
    # hyprlock
    socat
    # satty
    d2
    # hyprpaper
    lua51Packages.luarocks-nix
    brightnessctl
    playerctl
    lua51Packages.lua
    alsa-utils
    # hyprcursor
    # bitwarden-cli
    # (discord.override { withVencord = true; })
    # betterdiscordctl
    element-desktop
    bash-language-server
    kdePackages.kdenlive
    krita
    zathura
    # texlab
    gimp
    blender
    libreoffice
    vscode-langservers-extracted
    bun
    inotify-tools
    # graphviz
    # nautilus
    # loupe
    wineWow64Packages.stable
    # eza
    ffmpeg
    ncdu
    handbrake
    taplo

    prismlauncher
    typescript
    ispell
    texlive.combined.scheme-full
    imagemagick
    qalculate-gtk
    libqalculate
    kdePackages.okular
    pavucontrol

    # unclutter
    xclip
    libnotify
    gnuplot
    # ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]))
    # exercism
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
    # grex
    # fastfetch
    trash-cli
    jq
    rlwrap
    gnumake
    python314
    gcc
    beautysh
    steam-run

    # antidote
    acpi

    shellcheck
    appimage-run
    wakatime-cli

    cbqn

    nix-prefetch-github
    statix
    alejandra
    nixfmt
    nil
    deadnix
    devenv

    marksman
    cspell
    nodejs
    gpick
    wordnet
    xmodmap

    swaynotificationcenter
    wl-clipboard
    killall

    python312Packages.pygments

    usbutils

    typst
    typstyle
    tinymist
    typst-live
    websocat
    wtype

    inputs.tree-sitter.packages.${stdenv.hostPlatform.system}.cli
    nix-index
    pairdrop

    rofi
    dmenu
    alacritty
    timg
    act
    flameshot
  ];
}
