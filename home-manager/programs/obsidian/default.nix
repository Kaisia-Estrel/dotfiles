{ pkgs, ... }:

let
  makePackage =
    file:
    let
      manifest = pkgs.lib.importJSON (pkgs.lib.path.append file "manifest.json");
    in
    pkgs.stdenv.mkDerivation {
      name = manifest.id;
      src = file;

      installPhase = ''
        mkdir -p "$out"
        install -D * "$out"
      '';
    };

in
{

  programs.obsidian = {
    enable = true;
    defaultSettings = {
      communityPlugins = map (x: {
        enable = true;
        pkg = makePackage (pkgs.lib.path.append ./plugins x);
      }) (builtins.attrNames (builtins.readDir ./plugins));
      app = {
        vimMode = true;
      };
      hotkeys = import ./hotkeys.nix;
    };
    vaults = {
      "Perigord Brain Repository" = {
        enable = true;
        target = "Documents/Perigord Brain Repository";
      };
      "Perigord-Studies" = {
        enable = true;
        target = "Documents/Perigord-Studies";
      };
      "Ouvreland" = {
        enable = true;
        target = "Documents/Ouvreland";
      };
    };

  };
}
