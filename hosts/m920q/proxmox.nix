{ pkgs, lib, ...}:

{
  services.proxmos-ve.enable = true;
  nixpkgs.overlays = [
    proxmox-nixos.overlays."x86_64-linux"
  ];
}
