{ inputs, pkgs, ... }:
let
  saveLastWorkspace = pkgs.writeShellApplication {
    name = "save-last-workspace";
    runtimeInputs = [ pkgs.socat ];
    text = pkgs.lib.readFile ./scripts/save-last-workspace.sh;
  };

in {
  wayland.windowManager.hyprland = {
    enable = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # plugins = [ inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars ];

    settings = {
      "exec-once" = [
        "${saveLastWorkspace}/bin/save-last-workspace"
        "[workspace special:obsidian silent] ${pkgs.obsidian}/bin/obsidian"
      ];
    };

    extraConfig = pkgs.lib.readFile ./hyprland.conf;
  };

}
