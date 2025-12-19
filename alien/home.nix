{
  config,
  pkgs,
  lib,
  ...
}:

let
  authorizedKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCzEahavw0kLPVoNis9T49T823tZcsSPEGew3fQ3wqt0zUQTdIGoXx3Yug9SiZyJiz/khWHliJWqiTAdVukAzpn/wAKhj28ZKOlX/yfryvJrOudDDGNvfdJZuHuemumYmull2FI03h0ldQLh7ATM1t83PHAGwxQMPol7E8klGFyCquZi6Gr+xalu2bnruEjXHwv29seWjyGFBE4Xuaq9/JtqpwhBuIrOJgqxscGQtSZeP1CYKO8DoPUOt9/HbIdzIhXNiqJ+3IbGyl/rKis/NGlZxa96S1QQQNkfNSennYvRigjtul801RcpiBtBSPk7+mDsGB6tc41fduiPgGmd37cDJ8DRetB1SyAUJpM3Ax1mTj/Yt1q+TJsymcomKwcb6agXpAPc1C0bToYVjaHOyk7cswKBCAewk+h6vugs8tjj1krw87sZbw3jw/Wi9Qq0UGWUe/ZFHO9/6v30gcTnlxWpiFAuGXfXzcecQ/aX+jrYw2BmH4yBI/V+UlmqVFnT3h7uRRubG6c9Ol33rvs+NN6sAN2NsV3oiV6NpmZA4bqLvBR/X5chL/16otyGxQNQ34ZVrp/wrNHzQ8sf53jVIvOSKU8PPMx3g2cIW4Ot1cRpWmtHGsKVBYrHaMwH0E/CdjjYX32FlqqQRC7tPHBc58/iFqcCF8xXZI8CiKXCFHBQ== nicolas@laptop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQHhAEvMYH/uyvIXAyhFKOM7kxVV09Zs/HGT5BlRxBl nicolas@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDB4KKR9gvkOLb71pwt9c5DpT+ok8D1gQ725KX6AZLQf nicolas@home"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyiCWmWyNsjmjAAJggJeP7qcHh+cbrCgoZKeb53+xmh nicolas@m3"
  ];
in
{
  home.file.".ssh/authorized_keys".text = builtins.concatStringsSep "\n" authorizedKeys + "\n";

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nicolas";
  home.homeDirectory = "/home/nicolas";

  imports = [ ../common/home.nix ];
  programs.git.signing.key = "CE9B0CA1018C42EE";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
