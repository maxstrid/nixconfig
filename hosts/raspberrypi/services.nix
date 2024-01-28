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
        };
      };
    };
  };
}
