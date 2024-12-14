{ pkgs, ... }:

{
  services.homepage-dashboard = {
    enable = true;
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
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
