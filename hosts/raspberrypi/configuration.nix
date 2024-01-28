{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;

        generic-extlinux-compatible.enable = false;
        grub.enable = false;
    };
  };

  networking.hostName = "nixos"; # Define your hostname.

  time.timeZone = "US/Pacific";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
    ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRDyXDfuw4T+zKEoPOQZU8hiNrsoT+gD+nmAELqqhHC max@t480"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
    ];
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "24.05";
}

