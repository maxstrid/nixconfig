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
      };
    };
  };
}
