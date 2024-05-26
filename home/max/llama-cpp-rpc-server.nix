{ config, lib, pkgs, utils, ... }:

let
  cfg = config.services.llama-cpp-rpc-server;
in {

  options = {

    services.llama-cpp-rpc-server = {
      enable = lib.mkEnableOption "LLaMA C++ rpc server";

      package = lib.mkPackageOption pkgs "llama-cpp" {
        description = "Package for the rpc-server to use. Should be a llama-cpp compiled with -DLLAMA_RPC";
        default = llama-cpp.override { rpcSupport = true; };
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Extra flags passed to llama-cpp-rpc-server.";
        example = ["-m 1024"];
        default = [];
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Listen port for LLaMA C++ rpc server.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for LLaMA C++ rpc server.";
      };
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.llama-cpp-rpc-server = {
      description = "LLaMA C++ server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "idle";
        KillSignal = "SIGINT";
        ExecStart = "${cfg.package}/bin/llama-server --log-disable --host ${cfg.host} --port ${builtins.toString cfg.port} -m ${cfg.model} ${utils.escapeSystemdExecArgs cfg.extraFlags}";
        Restart = "on-failure";
        RestartSec = 300;

        # for GPU acceleration
        PrivateDevices = false;

        # hardening
        DynamicUser = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        SystemCallErrorNumber = "EPERM";
        ProtectProc = "invisible";
        ProtectHostname = true;
        ProcSubset = "pid";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

  };

  meta.maintainers = with lib.maintainers; [ newam ];
}
