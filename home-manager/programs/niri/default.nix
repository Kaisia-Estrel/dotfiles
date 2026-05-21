{
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    awww
    inputs.niri-float-sticky.packages.${stdenv.hostPlatform.system}.niri-float-sticky
  ];

  home.file = {
    "config.kdl" = {
      target = "${config.xdg.configHome}/niri/config.kdl";
      source = ./config.kdl;
      force = true;
    };
    "on-workspace-change.sh" = {
      target = "${config.xdg.configHome}/niri/on-workspace-change.sh";
      source = ./on-workspace-change.sh;
      force = true;
    };
    "toggle-workspace.sh" = {
      target = "${config.xdg.configHome}/niri/toggle-workspace.sh";
      source = ./toggle-workspace.sh;
      force = true;
    };
    "backgrounds" = {
      target = "${config.xdg.configHome}/niri/backgrounds";
      source = ./backgrounds;
      force = true;
    };
  };
}
