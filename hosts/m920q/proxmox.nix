{ inputs, pkgs, lib, ...}:

{
  services.proxmos-ve.enable = true;
  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays."x86_64-linux"
  ];
}
