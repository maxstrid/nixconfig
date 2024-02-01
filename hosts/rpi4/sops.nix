{ config, pkgs, ... }:

{
  sops.defaultSopsFile = ../../secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."gluetun/wireguard_private_key" = {};
  sops.secrets."gluetun/wireguard_adresses" = {};
}
