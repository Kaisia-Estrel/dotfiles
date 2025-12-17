{ inputs, pkgs, ... }:
let
  saveLastWorkspace = pkgs.writeShellApplication {
    name = "save-last-workspace";
    runtimeInputs = [ pkgs.socat ];
    text = pkgs.lib.readFile ./scripts/save-last-workspace.sh;
  };

in {

  systemd.user.services.save-last-workspace = {
    Unit = {
      Description = "Save last visited workspace";
      Restart = "on-failure";
    };
    Service = { ExecStart = "${saveLastWorkspace}/bin/save-last-workspace"; };
  };

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
