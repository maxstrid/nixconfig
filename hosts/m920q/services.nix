{ config, lib, pkgs, ... }:

{
  users.groups.services = {};

  users.users.ollama = {
    isSystemUser = true;
    group = "services";
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
    Group = "services";
  };
}
