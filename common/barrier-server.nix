{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.barrier-server;

  barrierConfig = ''
    section: screens
      ${concatStringsSep "\n      " cfg.screens}
    end
    section: links
      ${concatStringsSep "\n      " (mapAttrsToList (screen: links:
        "${screen}:\n        " + concatStringsSep "\n        " (mapAttrsToList (direction: target:
          "${direction} = ${target}"
        ) links)
      ) cfg.screenLinks)}
    end
    section: options
      screenSaverSync = ${if cfg.screenSaverSync then "true" else "false"}
      switchDelay = ${toString cfg.switchDelay}
    end
  '';

in {
  options.services.barrier-server = {
    enable = mkEnableOption "Barrier server daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.barrier;
      description = "The barrier package to use";
    };

    screens = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "server" "client1" "client2" ];
      description = "List of screen names in the barrier network";
    };

    screenLinks = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = {};
      example = {
        server = { right = "client1"; };
        client1 = { left = "server"; };
      };
      description = "Screen positioning (left/right/up/down connections between screens)";
    };

    serverName = mkOption {
      type = types.str;
      default = config.networking.hostName or "barrier-server";
      description = "Name of this server screen";
    };

    enableCrypto = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SSL encryption";
    };

    screenSaverSync = mkOption {
      type = types.bool;
      default = false;
      description = "Synchronize screen savers across screens";
    };

    switchDelay = mkOption {
      type = types.int;
      default = 0;
      description = "Delay in milliseconds before switching screens";
    };

    port = mkOption {
      type = types.port;
      default = 24800;
      description = "Port to listen on";
    };

    logFile = mkOption {
      type = types.str;
      default = "/tmp/barrier-server.log";
      description = "Path to log file";
    };

    errorLogFile = mkOption {
      type = types.str;
      default = "/tmp/barrier-server.err";
      description = "Path to error log file";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".config/barrier/barrier.conf".text = barrierConfig;

    # macOS: use launchd
    launchd.agents.barrier-server = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = [
          "${cfg.package}/bin/barriers"
          "-f"
          "--no-tray"
          "--debug"
          "INFO"
          "--name"
          cfg.serverName
        ] ++ optional cfg.enableCrypto "--enable-crypto"
          ++ [
          "--config"
          "${config.home.homeDirectory}/.config/barrier/barrier.conf"
          "--address"
          ":${toString cfg.port}"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = cfg.logFile;
        StandardErrorPath = cfg.errorLogFile;
      };
    };

    # Linux: use systemd
    systemd.user.services.barrier-server = mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "Barrier server daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = concatStringsSep " " ([
          "${cfg.package}/bin/barriers"
          "-f"
          "--no-tray"
          "--debug"
          "INFO"
          "--name"
          cfg.serverName
        ] ++ optional cfg.enableCrypto "--enable-crypto"
          ++ [
          "--config"
          "${config.home.homeDirectory}/.config/barrier/barrier.conf"
          "--address"
          ":${toString cfg.port}"
        ]);
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
