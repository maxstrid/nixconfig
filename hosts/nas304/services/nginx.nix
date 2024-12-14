{ inputs, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."nas304.localdomain" = {
      #enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8082/";
      };

      locations."/qbittorrent/" = {
        proxyPass = "http://127.0.0.1:8080/";
      };

      locations."/jellyfin/" = {
        proxyPass = "http://127.0.0.1:8096/";
      };
    };
  };

  # security.acme = {
  #  acceptTerms = true;
  #  defaults.email = "mxwhenderson@gmail.com";
  #};
}
