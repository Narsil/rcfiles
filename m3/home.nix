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
  home.homeDirectory = "/Users/nicolas";
  home.activation = {
    trampolineApps =
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        toDir="$HOME/Applications/Home Manager Trampolines"
        fromDir="${apps}/Applications/"
        rm -rf "$toDir"
        mkdir "$toDir"
        (
          cd "$fromDir"
          for app in *.app; do
            /usr/bin/osacompile -o "$toDir/$app" -e 'do shell script "open '$fromDir/$app'"'
          done
        )
      '';
  };
  xdg.portal.enable = lib.mkForce false;

  imports = [ ../common/home.nix ];
  programs.git.signing.key = "E1375ACFE790604A";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
