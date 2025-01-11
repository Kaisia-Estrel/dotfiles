self: super: {
  raleway-overlay = super.callPackage ./Raleway.nix { };
  feather = super.callPackage ./Feather.nix { };
  glsl_analyzer = super.callPackage ./glsl_analyzer.nix { };
  codeium = super.callPackage ./codeium.nix { };
  where-is-my-sddm-theme-catppuccin =
    super.callPackage ./where-is-my-sddm-theme-catppuccin { };
}
