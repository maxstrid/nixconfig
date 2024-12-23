{ pkgs, config, ... }:

{
    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud30;
        hostName = "nas304.localdomain/nextcloud";
        config.adminpassFile = config.sops.secrets.nextcloud-adminpass.path;
    };
}
