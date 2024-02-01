{ config, pkgs, ... }:

{
  sops.defaultSopsFile = ../../secrets/rpi4.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."gluetun/wireguard_private_key" = {};
  sops.secrets."gluetun/wireguard_adresses" = {};
}
