{ pkgs, ... }:
{
  imports = [
    ./niri
    ./nushell
    ./git.nix
    ./firefox.nix
    ./kitty.nix
    ./wofi
    ./wlogout.nix
    ./swaync.nix
    ./obsidian
  ];

  programs = {
    bat = {
      enable = true;
    };

    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
    };

    mpv.enable = true;

    lazygit.enable = true;
    readline.enable = true;

    btop.enable = true;
    fzf = {
      enable = true;
    };
    yt-dlp.enable = true;
    gh = {
      enable = true;
    };

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
