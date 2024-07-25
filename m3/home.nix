{ config, pkgs, ... }:

{
  home.username = "nicolas";
  home.homeDirectory = "/Users/nicolas";
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [ ../common/home.nix ];
  programs.git.signing.key = "788A1EA699458B2F";
}
