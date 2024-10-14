{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nicolas";
  home.homeDirectory = "/Users/nicolas";

  imports = [ /Users/nicolas/src/rcfiles/common/home.nix ];
  programs.git.signing.key = "788A1EA699458B2F";

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
