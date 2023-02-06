{pkgs, ...}: {
  imports = [./zsh.nix ./git.nix ./firefox.nix ./kitty.nix ./rofi.nix];

  programs = {
    bat = {
      enable = true;
      themes = {
        dracula = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "c5de15a0ad654a2c7d8f086ae67c2c77fda07c5f";
            sha256 = "m/MHz4phd3WR56I5jfi4hMXnFf4L4iXVpMFwtd0L0XE=";
          }
          + "/Dracula.tmTheme");
      };
    };

    xmobar.enable = true;
    obs-studio.enable = true;
    lazygit.enable = true;
    readline.enable = true;
    emacs.enable = true;
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      defaultEditor = true;
      withNodeJs = true;
    };

    btop.enable = true;
    fzf = {
      enable = true;
    };
    yt-dlp.enable = true;
    gh = {
      enable = true;
      settings = {
        editor = "${pkgs.neovim}/bin";
      };
    };
  };
}
