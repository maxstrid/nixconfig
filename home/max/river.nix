{ pkgs, lib, ... }:

let
  helpers = import ./helpers.nix {
    inherit pkgs;
    inherit lib;
  };
in {
    wayland.windowManager.river = {
        enable = true;
        package = (helpers.nixGLWrap pkgs.river);
    };
}
