# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];

  networking.hostName = "home"; # Define your hostname.
  home-manager.users.nicolas =
    { pkgs, ... }:
    {
      programs.git.signing.key = "E939E8CC91A1C674";
    };
  networking.networkmanager.wifi.powersave = false;

}
