{ config, pkgs, ... }:

{
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "end0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];

      listenPort = 51820;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o end0 -j MASQUERADE
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o end0 -j MASQUERADE
      '';

      privateKeyFile = "${config.sops.secrets.wireguard-private-key.path}";

      peers = [
        {
          publicKey = "0rAu2Nfqe71Q7NEGNVWgqzTmmmH3Rlk5HPXxXTKhSEM=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          publicKey = "kVl6rZc50ByZJC1COkFMmYV6krRY1hMh3HhqFG+OQyg=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };
}
