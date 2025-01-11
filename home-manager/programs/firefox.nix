{ config, pkgs, ... }:
let
  shyfox = pkgs.fetchFromGitHub {
    owner = "Naezr";
    repo = "ShyFox";
    rev = "6488ff1934c184a7b81770c67f5c3b5e983152e3";
    sha256 = "sha256-9InO33jS+YP+aupQc8OadvGSyXEIBcTbN8kTo91hAbY=";
  };
in {

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
        default = "DuckDuckGo";
        engines = {
          "Stack Overflow" = {
            urls = [{
              template = "https://stackoverflow.com/search?q={searchTerms}";
            }];
            iconUpdateURL = "https://scholar.google.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@stack" ];
          };
          "Google Scholar" = {
            urls = [{
              template = "https://scholar.google.com/scholar?q={searchTerms}";
            }];
            iconUpdateURL = "https://scholar.google.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@edu" ];
          };
          "Webster Thesaurus" = {
            urls = [{
              template =
                "https://www.merriam-webster.com/thesaurus/{searchTerms}";
            }];
            iconUpdateURL = "https://www.merriam-webster.com/favicon.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@th" ];
          };
          "Webster Dictionary" = {
            urls = [{
              template =
                "https://www.merriam-webster.com/dictionary/{searchTerms}";
            }];
            iconUpdateURL = "https://www.merriam-webster.com/favicon.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@di" ];
          };
          "Hackage" = {
            urls = [{
              template =
                "https://hackage.haskell.org/packages/search?terms={searchTerms}";
            }];
            iconUpdateURL = "https://hackage.haskell.org/static/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@hkg" ];
          };
          "Hoogle" = {
            urls = [{
              template = "https://hoogle.haskell.org/?hoogle={searchTerms}";
            }];
            iconUpdateURL = "https://hoogle.haskell.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@hs" ];
          };
          "Nix" = {
            urls =
              [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
            iconUpdateURL = "https://mynixos.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@nix" ];
          };
          "NixOS Wiki" = {
            urls = [{
              template =
                "https://wiki.nixos.org/index.php?search={searchTerms}";
            }];
            iconUpdateURL = "https://wiki.nixos.org/favicon.png";
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
