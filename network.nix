{ pkgs, ... }: {
  services.httpd = {
    enable = true;
    adminAddr = "admin@website.org";
    enablePHP = true;
    virtualHosts."*:80" = {
      documentRoot = "/var/www/html";
      serverAliases = [ "testtruff.org" ];
    };
  };
}
