{ config, pkgs, ... }:

{
    imports = [ ../common/home.nix ];
    programs.git.signing.key = "788A1EA699458B2F";
}
