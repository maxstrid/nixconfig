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
    inputs: {
      nixosConfigurations = {
        rpi4 = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./hosts/rpi4 ];
          specialArgs = { inherit inputs; };
        };

        m900 = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/m900 ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
