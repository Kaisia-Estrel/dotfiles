{ pkgs, inputs, ... }: {
  imports = [
    ./zsh.nix
    ./git.nix
    ./firefox.nix
    ./kitty.nix
    ./wofi
    ./wlogout.nix
    ./swaync.nix
  ];

  programs = {
    bat = { enable = true; };

    obsidian = { enable = true; };

    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
    };

    spicetify =
      let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          shuffle
          keyboardShortcut
          fullAppDisplay
          copyLyrics
        ];
      };

    mpv.enable = true;

    # eww.enable = true;

    lazygit.enable = true;
    readline.enable = true;

    neovim = {
      enable = true;
      extraLuaPackages = ps: [ ps.magick ];
      defaultEditor = true;
    };

    btop.enable = true;
    fzf = { enable = true; };
    yt-dlp.enable = true;
    gh = { enable = true; };

    # vscode = {
    #   enable = true;
    #   extensions = with pkgs.vscode-extensions; [
    #     mikestead.dotenv
    #     jnoortheen.nix-ide
    #     christian-kohler.path-intellisense
    #     ms-dotnettools.csharp
    #     oderwat.indent-rainbow
    #   ];
    # };
  };
}
