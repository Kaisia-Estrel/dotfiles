{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # plugins = [ inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars ];

    settings = {
      "exec-once" =
        [ "[workspace special:obsidian silent] ${pkgs.obsidian}/bin/obsidian" ];
    };

    extraConfig = pkgs.lib.readFile ./hyprland.conf;
  };

}
