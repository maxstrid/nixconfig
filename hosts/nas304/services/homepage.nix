{ pkgs, ... }:

{
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "nas304.localdomain";
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/apollo";
          memory = true;
        };
      }
    ];
    services = [
      {
        "Media" = [
          {
            "qBittorrent" = {
              description = "Torrent Service";
              href = "http://nas304.localdomain/qbittorrent";
            };
          }
          {
            "Jellyfin" = {
              description = "Media Streaming";
              href = "http://nas304.localdomain/jellyfin";
            };
          }
        ];
      }
    ];
  };
}
