{ pkgs, config, ... }:

{
    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud30;
        hostName = "localhost";
        config.adminpassFile = config.sops.secrets.nextcloud-adminpass.path;
        database.createLocally = true;
    };
}
