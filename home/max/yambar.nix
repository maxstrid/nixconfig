{ pkgs, lib, ... }:

{
    home.packages = [
        pkgs.yambar
    ];

    home.file = {
        ".config/yambar/config.yml".source = (pkgs.formats.yaml {} ).generate "yambar-config" {
            bar = {
                height = 26;
                location = "top";
                background = "000000ff";
                right = {
                    clock.content = {
                        string = {
                            text = "{date}";
                            right-margin = 5;
                        };
                    };
                };
            };
        };
    };
}
