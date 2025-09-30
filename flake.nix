{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    eza.url = "github:eza-community/eza";
    devenv.url = "github:cachix/devenv/latest";

  };

  outputs = { nixpkgs, fenix, home-manager, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "truff";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ fenix.overlays.default (import ./overlays) ];
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            # inherit pkgs;
            overlays = [ fenix.overlays.default (import ./overlays) ];
            inherit system;
            inherit username;
          };

          modules = [
            ./configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "bk";
                extraSpecialArgs = {
                  inherit inputs;
                  inherit username;
                  inherit pkgs;
                };
                # useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./home-manager/home.nix;
              };
            }
          ];
        };
      };
    };
}
