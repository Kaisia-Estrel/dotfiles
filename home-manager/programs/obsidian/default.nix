{ pkgs, ... }:

let
  plugin_settings = {

  };

  communityPlugins = pkgs.lib.mapAttrsToList (
    plugin-id: release:
    let
      assets = pkgs.lib.strings.concatMapAttrsStringSep "\n" (
        filename: source:
        let
          storefile = pkgs.fetchurl {
            inherit (source) url sha256;
          };
        in
        "ln -s ${storefile} $out/${filename}"
      ) release.assets;
    in
    {
      enable = true;
      settings = plugin_settings.${plugin-id} or null;
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = plugin-id;
        inherit (release) version;
        dontUnpack = true;
        buildCommand = ''
          mkdir -p "$out"
          ${assets}
        '';
      };
    }
  ) (pkgs.lib.importJSON ./plugin-urls.json);
  # makePackage =
  #   file:
  #   let
  #     manifest = pkgs.lib.importJSON (pkgs.lib.path.append file "manifest.json");
  #   in
  #   pkgs.stdenv.mkDerivation {
  #     name = manifest.id;
  #     src = file;
  #
  #     installPhase = ''
  #       mkdir -p "$out"
  #       install -D * "$out"
  #     '';
  #   };
in
{

  programs.obsidian = {
    enable = true;
    cli = {
      enable = true;
    };
    defaultSettings = {
      inherit communityPlugins;
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
