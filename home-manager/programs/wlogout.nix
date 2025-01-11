{ config, ... }:

{

  home.file.".config/wlogout/icons" = {
    source = ./wlogout-icons;
    recursive = true;
  };
}
