{ pkgs, ... }:

let
  makePackage = file:
    pkgs.stdenv.mkDerivation {
      name = "${pkgs.lib.path.removePrefix ./plugins file}";
      src = file;

      installPhase = ''
        mkdir -p "$out"
        install -D * "$out"
      '';
    };

  obsidian-git = pkgs.fetchzip {
    url =
      "https://github.com/Vinzent03/obsidian-git/releases/download/2.35.1/obsidian-git-2.35.1.zip";
    sha256 = "sha256-3YgfNEKmmWGAiEnWUI4+5nuFJV7Y1r1Uc4RKjHzZ9QQ=";
  };

  obsidian-switcher-plus = pkgs.fetchzip {
    url =
      "https://github.com/darlal/obsidian-switcher-plus/releases/download/5.3.1/dist.zip";
    sha256 = "sha256-pkMubvbIOVM89CwA3D+QW+T/1i0Tqv8A0G4JU4nEVI4=";
  };

  obsidian-latex-suite = pkgs.fetchzip {
    url =
      "https://github.com/artisticat1/obsidian-latex-suite/releases/download/1.9.8/obsidian-latex-suite-1.9.8.zip";
    sha256 = "sha256-sg+GwsWfkczPgtMh+xkwd49+HLui755QRNe7RygLe18=";
  };

in {

  programs.obsidian = {
    enable = true;
    defaultSettings = {
      communityPlugins = [
        {
          enable = true;
          pkg = makePackage ./plugins/obsidian-vim-yank-highlight;
        }
        {
          enable = true;
          pkg = makePackage ./plugins/obsidian-vimium;
        }
        {
          enable = true;
          pkg = makePackage ./plugins/obsidian-calendar-plugin;
        }
        {
          enable = true;
          pkg = obsidian-git;
        }
        {
          enable = true;
          pkg = obsidian-switcher-plus;
        }
        {
          enable = true;
          pkg = obsidian-latex-suite;
        }
      ];
      app = { vimMode = true; };
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
