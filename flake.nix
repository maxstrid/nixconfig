{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixos-hardware, sops-nix, ... }:
    {
      nixosConfigurations = {
        rpi4 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            sops-nix.nixosModules.sops
            nixos-hardware.nixosModules.raspberry-pi-4 

            ./hosts/rpi4
          ];
        };
      };
    };
}
