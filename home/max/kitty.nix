{ pkgs, lib, ... }:

let
  helpers = import ./helpers.nix {
    inherit pkgs;
    inherit lib;
  };
in {
  programs.kitty = {
    enable = true;
    package = (helpers.nixGLWrap pkgs.kitty);
    font = {
      package = (pkgs.nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      });
      name = "JetBrainsMono NF";
      size = 10;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      cursor_shape = "beam"; 
    };
    shellIntegration.enableBashIntegration = true;
    theme = "Gruvbox Dark";
  };
}
