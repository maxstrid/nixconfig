{ pkgs, ... }:

{
   imports = [
    ./nginx.nix
    ./homepage.nix
    ./docker.nix
  ]; 
}
