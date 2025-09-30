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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];

    settings = {
      "exec-once" = [
        "${saveLastWorkspace}"
        "[workspace special:obsidian silent] ${pkgs.obsidian}/bin/obsidian"
      ];
    };

    extraConfig = pkgs.lib.readFile ./hyprland.conf;
  };

}
