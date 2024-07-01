{ config, pkgs, ... }:

{
    # Setup cloudflare ddns for vpn.maxwellh.dev
    services.cloudflare-dyndns = {
        enable = true;
        ipv6 = true;
        ipv4 = true;
        domains = [ "vpn.maxwellh.dev" ];
        apiTokenFile = "${config.sops.secrets.cloudflare-api-key.path}";
    };
}
