{ inputs, pkgs, ... }: 

{
  imports = [
    ./river.nix
    ./kitty.nix
    ./waybar.nix
  ];

  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
