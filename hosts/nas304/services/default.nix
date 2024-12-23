{ pkgs, ... }:

{
   imports = [
    ./nginx.nix
    ./homepage.nix
    ./nextcloud.nix
    ./docker.nix
  ]; 
}
