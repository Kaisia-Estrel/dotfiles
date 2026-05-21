{ replaceVarsWith, perl }:
replaceVarsWith {
  name = "command-not-found";
  dir = "bin";
  src = ./command-not-found.pl;
  isExecutable = true;
  replacements = {
    dbPath = /nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite;
    perl = perl.withPackages (p: [
      p.DBDSQLite
      p.StringShellQuote
    ]);
  };
}
