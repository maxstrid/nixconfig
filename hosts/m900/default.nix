{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-hardware.nixosModules.common-cpu-intel

    ./hardware-configuration.nix
    ./sops.nix
    ./services.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = [ "bcachefs" ];
  };

  networking.hostName = "m900";
  time.timeZone = "US/Pacific";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      git
    ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRDyXDfuw4T+zKEoPOQZU8hiNrsoT+gD+nmAELqqhHC max@t480"
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
      LogLevel = "VERBOSE";
      PasswordAuthentication = false;
    };
  };

  systemd.services.mount-disks = {
    description = "Mounts bcachefs disks";
    script = "[ ! \"$(/run/current-system/sw/bin/findmnt -no source -T /mnt)\" = \"/dev/sda:/dev/sdb\" ] && /run/current-system/sw/bin/mount -t bcachefs /dev/sda:/dev/sdb /mnt || true";
    wantedBy = [ "multi-user.target" ];
    requires = [ "dev-sda.device" "dev-sdb.device" ];
    after = [ "dev-sda.device" "dev-sdb.device" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
