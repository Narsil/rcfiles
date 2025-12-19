{
  config,
  pkgs,
  lib,
  ...
}:

{
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
  # TODO: Set the GPG signing key for this machine
  # programs.git.signing.key = "0xYOUR_KEY_HERE";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
