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
            "/home/docker/jellyfin/config:/config"
            "/home/docker/jellyfin/media:/media"
          ];
          ports = [
            "8096:8096"
          ];
        };

        uptime-kuma = {
          autoStart = true;
          image = "louislam/uptime-kuma";
          volumes = [
            "/home/docker/uptime-kuma/:/app/data"
          ];
          ports = [
            "3001:3001"
          ];
        };

        gluetun = {
          autoStart = true;
          image = "qmcgaw/gluetun:v3.37.0";
          ports = [
            # Qbittorrent
            "8080:8080"
            "6881:6881"
            "6881:6881/udp"
          ];
          environment = {
            VPN_SERVICE_PROVIDER = "mullvad";
            VPN_TYPE = "wireguard";
            WIREGUARD_PRIVATE_KEY = config.sops.secrets.wireguard_private_key;
            WIREGUARD_ADDRESSES = config.sops.secrets.wireguard_addresses;
          };
          extraOptions = [
            "--cap-add=NET_ADMIN"
          ];
        };

        qbittorrent = {
          autoStart = true;
          image = "lscr.io/linuxserver/qbittorrent:latest";
          environment = {
            PUID = 1000;
            PGID = 1000;
            TZ = "US/Pacific";
            WEBUI_PORT = 8080;
          };
          volumes = [
            "/home/docker/qbittorrent/config/:/config"
            "/mnt/hdd/downloads:/downloads"
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
