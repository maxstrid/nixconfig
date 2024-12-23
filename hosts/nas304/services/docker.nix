{ config, lib, pkgs, ... }:

{
  users.users.docker = {
    isSystemUser = true;
    group = "docker";
  };

  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        jellyfin = {
          autoStart = true;
          image = "jellyfin/jellyfin";
          volumes = [
            "/vault/jellyfin/config:/config"
            "/vault/media:/media"
          ];
          ports = [
            "8096:8096"
          ];
        };

        gluetun = {
          autoStart = true;
          image = "qmcgaw/gluetun:v3.37.0";
          ports = [
            # Qbittorrent
            "8083:8083"
            "41198:41198"
            "41198:41198/udp"
          ];
          volumes = [
            "${config.sops.secrets."wg0.conf".path}:/gluetun/wireguard/wg0.conf"
          ];
          environment = {
            VPN_SERVICE_PROVIDER = "airvpn";
            VPN_TYPE = "wireguard";
          };
          extraOptions = [
            "--cap-add=NET_ADMIN"
          ];
        };

        qbittorrent = {
          autoStart = true;
          image = "lscr.io/linuxserver/qbittorrent:latest";
          environment = {
            PUID = "1000";
            PGID = "1000";
            TZ = "US/Pacific";
            WEBUI_PORT = "8083";
          };
          volumes = [
            "/vault/qbittorrent/config/:/config"
            "/vault/media:/downloads"
          ];
          dependsOn = ["gluetun"];
          extraOptions = [
            "--network=container:gluetun"
          ];
        };
      };
    };
  };
}
