{ stdenvNoCC, qt6 }:
stdenvNoCC.mkDerivation {
  pname = "where-is-my-sddm-theme-catppuccin";
  version = "1.9.1";
  src = ./.;
  propagatedUserEnvPkgs = [ qt6.qt5compat qt6.qtsvg ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r $src $out/share/sddm/themes/where-is-my-sddm-theme-catppuccin
  '';
}
