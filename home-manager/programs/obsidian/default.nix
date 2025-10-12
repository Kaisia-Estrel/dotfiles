{ pkgs, ... }:

let
  vim-yank-highlight = pkgs.fetchFromGitHub {
    owner = "aleksey-rowan";
    repo = "obsidian-vim-yank-highlight";
    rev = "914c83c508823a29796a1e271c91e9b88e1fb0d0";
    hash = "sha256-Z10vHpVFntbT7lg6oA9YnxnIBIN0AG6ez/lgso06EhQ=";
  };

  obsidian-vimium = pkgs.fetchFromGitHub {
    owner = "karstenpedersen";
    repo = "obsidian-vimium";
    rev = "f2227f5532e267a7549400dde85a185a6dc1b41b";
    hash = "sha256-Qu9P+KVlazlHzEK4+9zQ4sbBgO1GXFqPgU66/TpVqNg=";
  };

  quickswitcher = pkgs.fetchFromGitHub {
    owner = "darlal";
    repo = "obsidian-switcher-plus";
    rev = "4fa97fa21bf62f3cdfbb15378576caebd07fc410";
    hash = "sha256-BI4LMZdYPZ8PeD/TMCtOdQCi+7999JLXnXZj8nZAmYo=";
  };

  obsidian-latex-suite = pkgs.fetchFromGitHub {
    owner = "artisticat1";
    repo = "obsidian-latex-suite";
    rev = "ce31511a47949e3d4d0b3a43444949fd5a6a69f6";
    hash = "sha256-kDW6lJnRUFtERRmTck8bJ65u6EwAaT2D01h8OELCiRw=";
  };

  obsidian-latex-math = pkgs.fetchFromGitHub {
    owner = "zarstensen";
    repo = "obsidian-latex-math";
    rev = "1e822a0a5375cdd1facff0130eb7a9ab80a45f7e";
    hash = "sha256-6XMEIivbZSPEepfyRsG/LBzhp+XeIHGRWrwsmaRhDSY=";
  };

  obsidian-git = pkgs.fetchFromGitHub {
    owner = "Vinzent03";
    repo = "obsidian-git";
    rev = "0f3d368fea440f4a703ea8db21798c2af6d64557";
    hash = "sha256-CxeqFMLQ0nDwY7W/oVfcDIRRV4yM+8ncaLl5fWiVNg8=";
  };

  folder-notes = pkgs.fetchFromGitHub {
    owner = "xpgo";
    repo = "obsidian-folder-note-plugin";
    rev = "272bbdc9a674fd333e6a97b02611868797648585";
    hash = "sha256-MOvf89nvOQHXdXH0rk5tHkR7/XBBkJkoxhxbvMyQjQc=";
  };

  calendar = pkgs.fetchFromGitHub {
    owner = "liamcain";
    repo = "obsidian-calendar-plugin";
    rev = "ef3f2696da11aa1d11a272179caea062d6144640";
    hash = "sha256-isOcRV21CCHc6tj49y08f0F1tTYhuQMCUdvr/NIL/rY=";
  };
in {

  programs.obsidian = {
    enable = true;
    defaultSettings = {
      communityPlugins = [
        { pkg = vim-yank-highlight; }
        { pkg = obsidian-vimium; }
        { pkg = obsidian-latex-suite; }
        { pkg = quickswitcher; }
        { pkg = obsidian-latex-math; }
        { pkg = obsidian-git; }
        { pkg = folder-notes; }
        { pkg = calendar; }
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
