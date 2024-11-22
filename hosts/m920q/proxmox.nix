{ inputs, pkgs, lib, ...}:

{
  imports = [
    inputs.proxmox-nixos.nixosModules.proxmox-ve
  ];
  services.proxmos-ve.enable = true;
  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays."x86_64-linux"
  ];
}
