{ pkgs, config, ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.command-not-found.enable = true;

  programs.zsh = {
    history.expireDuplicatesFirst = true;

    enable = true;
    syntaxHighlighting.enable = true;

    enableVteIntegration = true;
    autocd = true;

    dotDir = ".config/zsh";

    shellAliases = {
      luashell = "nix-shell -p stylua sumneko-lua-language-server stylua";
      ytmp3 = "${pkgs.yt-dlp}/bin/yt-dlp -f 'ba' -x --audio-format mp3";

      grep = "rg";

      py = "python";

      detach = "kitten @ detach-window";
      ls =
        "${pkgs.eza}/bin/eza -hF --color=always --icons --sort=size --group-directories-first";
      la =
        "${pkgs.eza}/bin/eza -haF --color=always --icons --sort=size --group-directories-first";
      l =
        "${pkgs.eza}/bin/eza -lhF --color=always --icons --sort=size --group-directories-first";
      ll =
        "${pkgs.eza}/bin/eza -lahF --color=always --icons --sort=size --group-directories-first";
      lst =
        "${pkgs.eza}/bin/eza -lahTF --color=always --icons --sort=size --group-directories-first";
      mkignore = "forgit::ignore";

      cd = "z";
      clipCopy = "xclip -sel clip";
      clipPaste = "xclip -sel clip -o";
      cat = "${pkgs.bat}/bin/bat";
      rm = "${pkgs.trash-cli}/bin/trash";
      open = "xdg-open";
      icat = "kitty +kitten icat";
    };

    autosuggestion = { enable = true; };
    enableCompletion = true;
    completionInit = ''
      autoload -U +X compinit && compinit
      autoload -U +X bashcompinit && bashcompinit
      zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}"
    '';

    sessionVariables = {
      HISTFILE = "${config.xdg.stateHome}/zsh/history";
      NEOVIDE_MULTIGRID = "true";
      AUTO_NOTIFY_IGNORE = import ./auto-notify-ignore.nix;
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };

    oh-my-zsh.enable = true;

    plugins = [
      {
        name = "perigord";
        file = "perigord.zsh-theme";
        src = ./perigord;
      }
      {
        name = "auto-notify;";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-auto-notify";
          rev = "71e8da986f24ffc864c7ee6e4b710a9350e35f79";
          sha256 = "oPg/XAV+8/KALKAfbUduQFvNEOyG/p3TRaoaiJuMDks=";
        };
      }
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
          sha256 = "PXHxPxFeoYXYMOC29YQKDdMnqTO0toyA7eJTSCV6PGE=";
        };
      }
      {
        name = "zsh-colored-man-pages";
        src = pkgs.fetchFromGitHub {
          owner = "ael-code";
          repo = "zsh-colored-man-pages";
          rev = "57bdda68e52a09075352b18fa3ca21abd31df4cb";
          sha256 = "087bNmB5gDUKoSriHIjXOVZiUG5+Dy9qv3D69E8GBhs=";
        };
      }
      {
        name = "forgit";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "5642a1a7307c17d452271b9e7aaa8bcec6a47f53";
          sha256 = "0QiyZL/2AcAEM4WsCsaTxYfJ0GfAFr2xG0kaSsynVTg=";
        };
      }
      {
        name = "helpers";
        src = pkgs.fetchFromGitHub {
          owner = "zpm-zsh";
          repo = "helpers";
          rev = "dcbffa97d71b0f3dc30025385ec5e5bd5a063a4b";
          sha256 = "ag3NCgyGisKCchlqJm7VefuxWgZJUILwH6Tv+Ktzg0U=";
        };
      }
      {
        name = "haskell";
        src = pkgs.fetchFromGitHub {
          owner = "coot";
          repo = "zsh-haskell";
          rev = "df8b68726d614ddbe198318b616fc1415a5201ee";
          sha256 = "yRlMERxetB637hpAAI23+DmeFHNkdS1VmCAkUa41Dn4=";
        };
      }
    ];

    initContent = ''
      export XDG_DATA_DIRS="$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"

      autoload -U history-search-end
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end

      bindkey -e
      bindkey ";5D" backward-word
      bindkey ";5C" forward-word
      bindkey \^u backward-kill-line
      bindkey "^[[A" history-beginning-search-backward-end
      bindkey "^[[B" history-beginning-search-forward-end
      bindkey \^h backward-word
      bindkey \^l forward-word
      bindkey \^j history-search-forward
      bindkey \^k history-search-backward

      WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"
      export PATH=$PATH:$HOME/.local/bin/:${config.xdg.configHome}/emacs/bin
      eval "$(zoxide init zsh)"

      function plot {
      cat <<HEREDOC | gnuplot
          set terminal pngcairo enhanced font 'Fira Sans,10'
          set autoscale
          set samples 1000
          set output '|kitty +kitten icat --stdin yes'
          set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb"#fdf6e3" behind
          plot $@
          set output '/dev/null'
      HEREDOC
      }

      function swap_esc() {
                cat <<HEREDOC | xmodmap -
                    clear lock
                    keycode 9 = Caps_Lock
                    keycode 66 = Escape
      HEREDOC
      }
      function unswap_esc() {
                cat <<HEREDOC | xmodmap -
                    keycode 66 = Caps_Lock
                    keycode 9 = Escape
      HEREDOC
      }

      function copyTxt() {
        echo -n "$1" | xclip -sel clip
      }

      function run() {
        nix run "nixpkgs#$1" -- ''${*[@]:2}
      }

      compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
    '';
  };
}
