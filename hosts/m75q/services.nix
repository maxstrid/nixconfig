{ pkgs, ... }:

{
    environment.systemPackages = [
        pkgs.llama-cpp
    ];
}
