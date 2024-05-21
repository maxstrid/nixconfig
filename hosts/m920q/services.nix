{ config, lib, pkgs, ... }:

{
  # Ollama
  users.groups.ollama = {};

  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    createHome = true;
    home = "/srv/ollama";
  };

  services.ollama = {
    enable = true;
    home = "/srv/ollama";
    models = "/srv/ollama/models";
    listenAddress="0.0.0.0:11434";
    writablePaths = [
      "/srv/ollama"
    ];
  };

  systemd.services.ollama.serviceConfig = {
    User = "ollama";
    Group = "ollama";
  };

  # llama.cpp
  nixpkgs.overlays = [
    (self: super: {
      llama-cpp = super.llama-cpp.override {
        openclSupport = true;
      };
    })
  ];

  environment.systemPackages = [
    llama-cpp
  ];
}
