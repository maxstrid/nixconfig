{ inputs, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."qbittorrent.nas304.localdomain" = {
      locations."/".proxyPass = "http://127.0.0.1:8080";
    };

    virtualHosts."jellyfin.nas304.localdomain" = {
      locations."/".proxyPass = "http://127.0.0.1:8096";
    };
  };

  # security.acme = {
  #  acceptTerms = true;
  #  defaults.email = "mxwhenderson@gmail.com";
  #};
}
