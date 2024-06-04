{ pkgs, lib, ... }:

let
  helpers = import ./helpers.nix {
    inherit pkgs;
    inherit lib;
  };

  pow = n: i: if i == 1 then n else if i == 0 then 1 else n * pow n (i - 1);

  # We have to recreate a bitshift here.
  generateFocusTags = id: {
    "Super ${toString id}" =
      "set-focused-tags ${toString (pow 2 (id - 1))}";
    "Super+Shift ${toString id}" =
      "set-view-tags ${toString (pow 2 (id - 1))}";
    "Super+Control ${toString id}" =
      "toggle-focused-tags ${toString (pow 2 (id - 1))}";
    "Super+Shift+Control ${toString id}" =
      "toggle-view-tags ${toString (pow 2 (id - 1))}";
  };

  generateAllTags' = id:
    if id == 9 then
      generateFocusTags 9
    else
      (generateFocusTags id) // (generateAllTags' (id + 1));
  generateAllTags = (generateAllTags' 1);
in {
  home.packages = [
    pkgs.bemenu
    pkgs.wbg
    pkgs.sandbar
  ];

  home.file = {
    ".config/bg.png".source = pkgs.fetchurl {
      url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/debian_grey_swirl.png";
      hash = "sha256-DdInw3f45OWaZSX0BaMN/JWilWYafYoNpMGeACyblBc=";
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.systemd}/bin/systemctl hybrid-sleep"; }
    ];
  };

  wayland.windowManager.river = {
    enable = true;
    package = (helpers.nixGLWrap pkgs.river);

    extraConfig = ''
      ${pkgs.wbg}/bin/wbg ~/.config/bg.png &
      ${pkgs.river}/bin/rivertile -view-padding 6 -outer-padding 6 &
      env LANG=C.UTF-8 ${pkgs.waybar}/bin/waybar
    '';

    # Converts the base init from river's repo.
    settings = {
      default-layout = "rivertile";

      map.normal = {
        "Super+Shift Return" = "spawn kitty";
        "Super Q" = "close";
        "Super+Shift E" = "exit";
        "Super J" = "focus-view next";
        "Super K" = "focus-view previous";
        "Super P" = "spawn bemenu-run";

        "Super Return" = "zoom";
        "Super F" = "toggle-fullscreen";

        "Super H" = "send-layout-cmd rivertile \"main-ratio -0.05\"";
        "Super L" = "send-layout-cmd rivertile \"main-ratio +0.05\"";

        "Super Space" = "toggle-float";

        "Super 0" = "set-focused-tags ${toString (pow 2 32)}";
        "Super+Shift 0" = "set-view-tags ${toString (pow 2 32)}";
      } // (generateAllTags);
    };
  };
}
