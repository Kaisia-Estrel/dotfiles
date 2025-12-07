{ config, pkgs, ... }:
let
  shyfox = pkgs.fetchFromGitHub {
    owner = "Naezr";
    repo = "ShyFox";
    rev = "6488ff1934c184a7b81770c67f5c3b5e983152e3";
    sha256 = "sha256-9InO33jS+YP+aupQc8OadvGSyXEIBcTbN8kTo91hAbY=";
  };
in {

  stylix.targets.firefox.profileNames = [ "default" ];

  home.file."${config.programs.firefox.configPath}/default/chrome/ShyFox" = {
    recursive = true;
    source = "${shyfox}/chrome/ShyFox";
  };

  home.file."${config.programs.firefox.configPath}/default/chrome/icons" = {
    recursive = true;
    source = "${shyfox}/chrome/icons";
  };
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;

      search = {
        default = "ddg";
        engines = {
          "NLab" = {
            urls = [{
              template =
                "https://www.google.com/search?as_q={searchTerms}&as_sitesearch=https%3A%2F%2Fncatlab.org%2Fnlab%2F";
            }];
            icon = "https://ncatlab.org/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@nlab" ];
          };
          "Stack Overflow" = {
            urls = [{
              template = "https://stackoverflow.com/search?q={searchTerms}";
            }];
            icon = "https://scholar.google.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@stack" ];
          };
          "Google Scholar" = {
            urls = [{
              template = "https://scholar.google.com/scholar?q={searchTerms}";
            }];
            icon = "https://scholar.google.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@edu" ];
          };
          "Webster Thesaurus" = {
            urls = [{
              template =
                "https://www.merriam-webster.com/thesaurus/{searchTerms}";
            }];
            icon = "https://www.merriam-webster.com/favicon.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@th" ];
          };
          "Webster Dictionary" = {
            urls = [{
              template =
                "https://www.merriam-webster.com/dictionary/{searchTerms}";
            }];
            icon = "https://www.merriam-webster.com/favicon.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@di" ];
          };
          "Hackage" = {
            urls = [{
              template =
                "https://hackage.haskell.org/packages/search?terms={searchTerms}";
            }];
            icon = "https://hackage.haskell.org/static/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@hkg" ];
          };
          "Hoogle" = {
            urls = [{
              template = "https://hoogle.haskell.org/?hoogle={searchTerms}";
            }];
            icon = "https://hoogle.haskell.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@hs" ];
          };
          "Nix" = {
            urls =
              [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
            icon = "https://mynixos.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@nix" ];
          };
          "NixOS Wiki" = {
            urls = [{
              template =
                "https://wiki.nixos.org/index.php?search={searchTerms}";
            }];
            icon = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nixw" ];
          };
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nixp" ];
          };
        };
      };

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      extraConfig = pkgs.lib.readFile "${shyfox}/user.js";
      userChrome = pkgs.lib.readFile "${shyfox}/chrome/userChrome.css";
      userContent = pkgs.lib.readFile "${shyfox}/chrome/userContent.css";
    };
  };
}
