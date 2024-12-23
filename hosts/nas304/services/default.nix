{ pkgs, ... }:

{
   imports = [
    ./nginx.nix
    ./homepage.nix
    # ./nextcloud.nix
    ./samba.nix
    ./docker.nix
  ]; 
}
