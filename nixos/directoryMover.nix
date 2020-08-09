{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.directoryMover;
  dmPackage = pkgs.python37.pkgs.buildPythonPackage rec {
      pname = "directoryMover";
      version = "0.0.1";

      # src = pkgs.fetchFromGitLab {
      #   owner = "jhgarner";
      #   repo = "directoryMover";
      #   rev = "86fbbaa014baceb67c09226e5db6607e2376b869";
      #   sha256 = "0z4wdqflsj0c88s9jxn7f496pqjwd0r6vwkh5niq3d48jjkmlj11";
      # };
      src = /home/jack/code/python/directoryMover;

      doCheck = false;
      propagatedBuildInputs = with pkgs.python37Packages; [ requests ];
    };
in {
  options.services.directoryMover = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, directoryMover will automatically backup changes from
        watched repos.
      '';
    };

    interval = mkOption {
      type = types.str;
      default = "10m";
      example = "hourly";
      description = ''
        Update the locate database at this interval. Updates by
        default at 2:15 AM every day.

        The format is described in
        systemd.time(7).
      '';
    };
  };

  config = {
    systemd.user.services.directoryMover =
      { description = "Backup watched directories";
        path  = [ dmPackage pkgs.git ];
        script =
          ''
            ${dmPackage}/bin/mapProject.py
          '';
      };

    systemd.timers.directoryMover = mkIf cfg.enable
      { description = "Update timer for directoryMover";
        partOf      = [ "directoryMover.service" ];
        wantedBy    = [ "timers.target" ];
        timerConfig.OnCalendar = cfg.interval;
      };
  };
}
