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
      #   rev = "c32811551ebcfe5d5a0c0e6eb56893285d94431b";
      #   sha256 = "0na5njgv115il8y4pf7xxpd4ldzqf656vv1bygj5aw5g3pd6ky75";
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
      default = "hourly";
      example = "hourly";
      description = ''
        Update the directory backup at this interval. Updates by
        default every hour.

        The format is described in
        systemd.time(7).
      '';
    };
  };

  config = {
    programs.zsh.promptInit = "[[ -e ~/directories/.lock ]] && cat ~/directories/.lock";
    systemd.user.services.directoryMover =
      { description = "Backup watched directories";
        path = [ dmPackage pkgs.git ];
        serviceConfig = {
          Type = "oneshot";
          RestartSec = 120;
          Restart = "on-failure";
        };
        script =
          ''
            ${dmPackage}/bin/mapProject.py
          '';
      };

    systemd.user.timers.directoryMover = mkIf cfg.enable
      { description = "Update timer for directoryMover";
        partOf      = [ "directoryMover.service" ];
        wantedBy    = [ "timers.target" ];
        timerConfig.OnCalendar = cfg.interval;
      };

    systemd.services.directoryMoverSleep =
      { description = "Backup watched directories when they sleep";
        path = [ dmPackage pkgs.git pkgs.python37 pkgs.su ];
        wantedBy    = [ "systemd-suspend.service" ];
        before    = [ "systemd-suspend.service" ];
        serviceConfig = {
          Type = "oneshot";
        };
        script =
          ''
            for dir in /home/*/
            do
              su -c "${dmPackage}/bin/mapProject.py $dir" $(basename $dir)
            done
          '';
      };
  };
}
