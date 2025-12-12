{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.input-leap-client;

in {
  options.services.input-leap-client = {
    enable = mkEnableOption "Input Leap client daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.input-leap;
      description = "The input-leap package to use";
    };

    server = mkOption {
      type = types.str;
      example = "192.168.1.100:24800";
      description = "Server address in format <host>[:<port>]. Port defaults to 24800";
    };

    name = mkOption {
      type = types.str;
      default = config.networking.hostName or "input-leap-client";
      description = "Screen name of this client";
    };

    enableCrypto = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SSL encryption";
    };

    enableDragDrop = mkOption {
      type = types.bool;
      default = false;
      description = "Enable file drag & drop";
    };

    logFile = mkOption {
      type = types.str;
      default = "/tmp/input-leap-client.log";
      description = "Path to log file";
    };

    errorLogFile = mkOption {
      type = types.str;
      default = "/tmp/input-leap-client.err";
      description = "Path to error log file";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # macOS: use launchd
    launchd.agents.input-leap-client = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = [
          "${cfg.package}/bin/input-leapc"
          "-f"
          "--no-tray"
          "--debug"
          "INFO"
          "--name"
          cfg.name
        ] ++ optional cfg.enableCrypto "--enable-crypto"
          ++ optional cfg.enableDragDrop "--enable-drag-drop"
          ++ [ cfg.server ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = cfg.logFile;
        StandardErrorPath = cfg.errorLogFile;
      };
    };

    # Linux: use systemd
    systemd.user.services.input-leap-client = mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "Input Leap client daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = concatStringsSep " " ([
          "${cfg.package}/bin/input-leapc"
          "-f"
          "--no-tray"
          "--debug"
          "INFO"
          "--name"
          cfg.name
        ] ++ optional cfg.enableCrypto "--enable-crypto"
          ++ optional cfg.enableDragDrop "--enable-drag-drop"
          ++ [ cfg.server ]);
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
