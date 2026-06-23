{ pkgs, config, ... }:
let
  command-not-found = pkgs.callPackage ./command-not-found.nix { };
in

{
  home.packages = [
    pkgs.direnv
    pkgs.starship
    pkgs.carapace
    pkgs.zoxide
    (pkgs.callPackage ./command-not-found.nix { })
  ];

  home.file."config-user.nu" = {
    target = "${config.programs.nushell.configDir}/config-user.nu";
    source = ./config-user.nu;
    force = true;
  };

  programs.starship = {
    enable = true;
    presets = [ "nerd-font-symbols" ];
    enableNushellIntegration = true;
    settings = {
      battery = {
        display = [
          {
            style = "bold white";
            threshold = 30;
          }
          {
            style = "bold orange";
            threshold = 20;
          }
          {
            style = "bold red";
            threshold = 10;
          }
        ];
      };
      character = {
        error_symbol = "[󰘧](bold red)";
        success_symbol = "[󰘧](bold green)";
      };
      cmd_duration = {
        show_notifications = true;
      };
      direnv = {
        disabled = false;
      };
    };
  };

  programs.nushell =
    let
      zoxideSetup = pkgs.runCommand ".zoxide.nu" {
        buildInputs = [ pkgs.zoxide ];
      } "${pkgs.zoxide}/bin/zoxide init nushell >> $out";

      niri-completions = pkgs.runCommand "niri-completions.nu" {
        buildInputs = [ pkgs.zoxide ];
      } "${pkgs.niri}/bin/niri completions nushell > $out";
    in
    {
      enable = true;
      settings = {
        edit_mode = "vi";
        use_kitty_protocol = true;
        show_banner = false;
        cursor_shape = {
          vi_insert = "blink_line";
          vi_normal = "blink_block";
        };
        buffer_editor = "${pkgs.neovim}/bin/nvim";
        rm = {
          always_trash = true;
        };
      };

      extraEnv = ''
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
        mkdir $"($nu.cache-dir)"
        carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
        source $"($nu.cache-dir)/carapace.nu"
        $env.PATH = ($env.PATH | append ${config.home.homeDirectory}/.local/bin)
      '';

      extraConfig = ''
        $env.PROMPT_INDICATOR_VI_NORMAL = "┃"
        $env.PROMPT_INDICATOR_VI_INSERT = "┆"

        $env.config.hooks.env_change.PWD = [{ ||
            if (which direnv | is-empty) {
                return
            }

            direnv export json | from json | default {} | load-env
        }]
        $env.config.hooks.command_not_found = { |e|
          let out = (${command-not-found}/bin/command-not-found $e | complete)
          if not ($out.stderr =~ $"($e): command not found") {
            print $out.stderr
          }
        }

        source ${zoxideSetup}
        source ${niri-completions}
        source ${config.xdg.configHome}/nushell/config-user.nu

        mkdir ($nu.data-dir | path join "vendor/autoload")
        starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
      '';
    };
}
