{ pkgs, config, ... }:

{
    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud30;
        hostName = "nextcloud.nas304.localdomain";
        config.adminpassFile = config.sops.secrets.nextcloud-adminpass.path;
        database.createLocally = true;
    };
}
