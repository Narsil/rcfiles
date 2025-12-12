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
          pathsToLink = [ "/Applications" ];
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

  imports = [
    ../common/home.nix
    ../common/barrier-server.nix
  ];
  programs.git.signing.key = "0x85E164F005821292";

  # Barrier server configuration
  services.barrier-server = {
    enable = true;
    serverName = "m3";
    screens = [ "m3:" "laptop:" ];
    screenLinks = {
      m3 = { right = "laptop"; };
      laptop = { left = "m3"; };
    };
    enableCrypto = true;
    screenSaverSync = false;
    switchDelay = 0;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
