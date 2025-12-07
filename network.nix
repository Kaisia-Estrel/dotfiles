{ pkgs, ... }: {

  networking.hosts = {
    "127.0.0.1" = [ "localhost" "testtruff.org" "ITC127-CS2A-Flores" ];
  };

  services.httpd = {
    enable = true;
    adminAddr = "admin@website.org";
    enablePHP = true;
    virtualHosts."localhost" = {
      documentRoot = "/var/www/html";
      serverAliases = [ "testtruff.org" ];
    };

    virtualHosts."ITC127-CS2A-Flores" = {
      documentRoot = "/home/truff/Documents/School/ITC127-CS2A-Flores";
    };

  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
