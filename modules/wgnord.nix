{ config, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /etc/wireguard 0700 root root -"
    "d /var/lib/wgnord 0755 root root -"
    "C /var/lib/wgnord/template.conf 0644 root root ${pkgs.wgnord}/share/wgnord/template.conf"
    "C /var/lib/wgnord/countries.txt 0644 root root ${pkgs.wgnord}/share/wgnord/countries.txt"
    "C /var/lib/wgnord/countries_iso31662.txt 0644 root root ${pkgs.wgnord}/share/wgnord/countries_iso31662.txt"
  ];
}


{
  security.sudo.enable = true;
  security.sudo.extraRules = [{
    users = [ "john" ];
    commands = [{
      command = "${pkgs.wireguard-tools}/bin/wg";  # allow wg without password
      options = [ "NOPASSWD" ];
    }];
  }];
}

