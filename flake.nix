{
  description = "Darwin Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, ... }:
  {
    darwinConfigurations = {
        "MacBook-Pro-de-Tiba-2" = nix-darwin.lib.darwinSystem {
        system = "aaarch64-darwin";
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
            {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	    home-manager.backupFileExtension = "bak";
            home-manager.users."GabrielAraujo" = import ./home.nix;
            }
        nix-homebrew.darwinModules.nix-homebrew
            {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "GabrielAraujo";
              autoMigrate = true;
            };
          }
        ];
        };
      };
  };
}
