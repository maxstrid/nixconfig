{ config, lib, pkgs, ... }:

{
  users.users.docker = {
    isSystemUser = true;
    group = "docker";
  };

  # Enable llama-cpp to use the iGPU
  hardware.opengl = {
    enable = true;
    extraPackages = [
      pkgs.clblast
      pkgs.intel-media-driver
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  nixpkgs.config = {
    llama-cpp = {
      openclSupport = true;
    };
  };

  environment.systemPackages = [
    pkgs.llama-cpp.override {
      openclSupport = true;
    }
  ];

  services.ollama = {
      enable = true;
      home = "/home/services/ollama";
      models = "/home/services/ollama/models";
      listenAddress="0.0.0.0:11434";
      writablePaths = [
        "/home/services/ollama"
      ];
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
            "/mnt/jellyfin/config:/config"
            "/mnt/media:/media"
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
            "8080:8080"
            "6881:6881"
            "6881:6881/udp"
          ];
          volumes = [
            "${config.sops.secrets."wg0.conf".path}:/gluetun/wireguard/wg0.conf"
          ];
          environment = {
            VPN_SERVICE_PROVIDER = "mullvad";
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
            WEBUI_PORT = "8080";
          };
          volumes = [
            "/mnt/qbittorrent/config/:/config"
            "/mnt/media:/downloads"
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
