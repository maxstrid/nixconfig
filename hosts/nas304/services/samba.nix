{pkgs, config, ...}:

{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      "workgroup" = "WORKGROUP";
      "server string" = "smbnix";
      "netbios name" = "smbnix";
      "security" = "user";
      "hosts allow" = "192.168.10. 127.0.0.1 localhost";
      "hosts deny" = "0.0.0.0/0";
      "guest account" = "nobody";
      "map to guest" = "bad user";
    };
    "test" = {
      "path" = "/vault/archive";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "testuser";
      "force group" = "testgroup";
    }
  }
}
