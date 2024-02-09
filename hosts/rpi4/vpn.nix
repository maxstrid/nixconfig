{ config, pkgs, ... }:

{
  networking = {
    firewall.allowedUDPPorts = [51820];
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "${config.sops.secrets.wireguard-private-key.path}";
          ListenPort = 51820;
        };
        wireguardPeers = [
          {
            wireguardPeerConfig = {
              PublicKey = "rDBlbA9JNyrPEOO7n9bNNP2jD7Trx5+j3VMJU+7rhn0=";
              AllowedIPs = ["10.100.0.2"];
            };
          }
        ];
      };
    };
  };

  networks.wg0 = {
    matchConfig.Name = "wg0";
    address = ["10.100.0.1/24"];
    networkConfig = {
      IPMasquerade = "ipv4";
      IPForward = true;
    };
  };
}
