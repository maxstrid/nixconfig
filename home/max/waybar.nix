{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 16;
        output = [
            "eDP-1"
            "HDMA-A-1"
        ];

        modules-center = [ "clock" ];
        modules-left = [ "river/tags" ];
        modules-right = [ "battery#bat0" "battery#bat1" ];

        "battery#bat0" = {
          bat = "BAT0";
          interval = 10;
        };

        "battery#bat1" = {
          bat = "BAT1";
          interval = 10;
        };
      };
    };
    style = ''
      window#waybar {
        font-family: JetBrainsMono NF;
        font-size: 12px;
        margin: 0;
        padding: 0;
      }

      #tags button {
        padding-top: 0px;
        padding-bottom: 0px;
        padding-left: 5px;
        padding-right: 5px;

        margin-top: 0px;
        margin-bottom: 0px;
      }

      #tags button.focused {
        background-color: #FFFFFF;
        color: #000000;
      }

      #battery {
        padding-top: 0px;
        padding-bottom: 0px;
        padding-left: 5px;
        padding-right: 5px;
      }

    '';
  };
}
