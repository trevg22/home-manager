{
  description = "Home Manager configuration of trevor";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self,nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarch64-linux";
      #pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
          system = system;
        config = {
          allowUnfree = true; # Enable unfree packages
        };
    };
    in {
      homeConfigurations={
        "trevor" = home-manager.lib.homeManagerConfiguration {
          pkgs=pkgs;
          extraSpecialArgs = {inherit inputs; };

                    modules=[
        {
          #wayland.windowManager.hyprland = {
          #  enable = true;
          #  # set the flake package
          #  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          #};
            }
            ./dev.nix
            ./prod.nix
          ];
          
        };
      };
          };
}
