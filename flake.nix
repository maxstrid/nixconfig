{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixgl.url = "github:nix-community/nixGL";
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [ inputs.nixgl.overlay ];
      };
    in {
      homeConfigurations = {
        max = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/max ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
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

        m920q = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/m920q ];
          specialArgs = { inherit inputs; };
        };

        m75q = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/m75q ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
