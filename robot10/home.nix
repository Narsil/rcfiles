{
  config,
  pkgs,
  lib,
  ...
}:

let
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyiCWmWyNsjmjAAJggJeP7qcHh+cbrCgoZKeb53+xmh nicolas@m3"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQjpXZ99ep8nSNjxZlE4TuPUM7y+1z41yP+jRMzWnaE nicolas@m4.home"
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
  programs.git.signing.key = "50B655D571C654B4";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
