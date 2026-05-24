{ pkgs, options, ... }:
{
  networking.hosts = {
    "127.0.0.1" = [
      "localhost"
      "testtruff.org"
    ];
  };

  networking = {
    hostName = "nixos";
    timeServers = [ "ntp.ubuntu.com" ] ++ options.networking.timeServers.default;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        3000
        80
        443
        17500
        8080
        9100
        50001
        57621
      ];
      # 50001: codeium
      # 57621: spotify
      allowedUDPPorts = [
        17500
        8080
        5353
      ]; # 175000 for Dropbox
      # 5353: spotify
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # KDE Connect
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # KDE Connect
    };
  };
  services = {

    httpd = {
      enable = true;
      adminAddr = "admin@website.org";
      enablePHP = true;
      virtualHosts."localhost" = {
        documentRoot = "/var/www/html";
        serverAliases = [ "testtruff.org" ];
      };

    };
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          security = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          "path" = "/mnt/Shares/Public";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "username";
          "force group" = "groupname";
        };
        "private" = {
          "path" = "/mnt/Shares/Private";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "username";
          "force group" = "groupname";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
