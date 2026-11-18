{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.rift;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.rift = {
    enable = lib.mkEnableOption "Rift window manager";

    package = lib.mkPackageOption pkgs "rift-wm" { };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = ''
        Rift configuration written to ~/.config/rift/config.toml.
      '';
      example = {
        input = {
          keyboard = "default";
        };
      };
    };

    launchd = {
      enable = lib.mkEnableOption "the Rift launchd agent";

      keepAlive = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether launchd should restart Rift when it exits.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isDarwin;
        message = "programs.rift is only supported on macOS.";
      }
    ];

    home.packages = [ cfg.package ];

    xdg.configFile."rift/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "rift-config.toml" cfg.settings;
    };

    launchd.agents.rift = lib.mkIf cfg.launchd.enable {
      enable = true;

      config = {
        ProgramArguments = [ "${cfg.package}/bin/rift" ];
        RunAtLoad = true;
        KeepAlive = cfg.launchd.keepAlive;
        ProcessType = "Interactive";

        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/rift.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/rift-error.log";
      };
    };
  };
}
