{ pkgs, ... }: {
  services.httpd = {
    enable = true;
    adminAddr = "admin@website.org";
    enablePHP = true;
    virtualHosts."localhost" = {
      documentRoot = "/var/www/html";
      serverAliases = [ "testtruff.org" ];
    };
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
