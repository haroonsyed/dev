{
  description = "Haroon's Unified NixOS Flake (Desktop & Laptop)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
      # Desktop configuration
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
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
          ./common.nix
          ./laptop.nix
          ./hardware-laptop.nix
        ];
      };
      };
    };
}