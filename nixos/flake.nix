{
  description = "Haroon's Unified NixOS Flake (Desktop & Laptop)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    multiverse.url = "github:fzakaria/nixpkgs-multiverse";
  };

  outputs = { self, nixpkgs, home-manager, multiverse, ... }@inputs:
    let
      system = "x86_64-linux";
      homeManagerModule = {
        imports = [ inputs.home-manager.nixosModules.home-manager ];
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          backupFileExtension = "backup";
          extraSpecialArgs = { inherit inputs; };
          users.haroonsyed = ./home.nix;
        };
      };
    in {
      nixosConfigurations = {
      # Desktop configuration
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          homeManagerModule
          ./common.nix
          ./desktop.nix
          ./hardware-desktop.nix
        ];
      };

      # Laptop configuration
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          homeManagerModule
          ./common.nix
          ./laptop.nix
          ./hardware-laptop.nix
        ];
      };
      };
    };
}