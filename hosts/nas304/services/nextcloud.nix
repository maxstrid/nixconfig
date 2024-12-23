{ pkgs, config, ... }:

{
    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud28;
        hostName = "nas304.localdomain/nextcloud";
        config.adminpassFile = config.sops.secrets.nextcloud-adminpass.path;
    };
}
