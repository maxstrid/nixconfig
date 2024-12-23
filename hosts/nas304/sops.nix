{ config, pkgs, ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets = {
      "wg0.conf" = {};
      nextcloud-adminpass = {};
  };
}
