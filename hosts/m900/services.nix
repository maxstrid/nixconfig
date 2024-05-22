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
      pkgs.intel-ocl
      pkgs.ocl-icd
      pkgs.intel-media-driver
    ];
  };

  nixpkgs.config = {
    llama-cpp = {
      openclSupport = true;
    };

    # Needed for intel-ocl
    # Not really sure if I even need ocl, llama-cpp only installs clblast
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    (self: super: {
      llama-cpp = super.llama-cpp.override {
        openclSupport = true;
      };
    })
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";

    # This is to make llama-cpp find the libOpenCL.so.1 library
    LD_LIBRARY_PATH="${pkgs.ocl-icd}/lib:$LD_LIBRARY_PATH";
  };

  services.llama-cpp = {
    enable = true;
    port = 8081;
    openFirewall = true;
    model = "/home/services/ollama/models/neuralhermes-2.5-mistral-7b.Q6_K.gguf";
    host = "0.0.0.0";
  };

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
            "6543:6881"
            "6543:6881/udp"
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
