{lib, ...}:

{ config = {
  systemd.user.services.redshift = {...}: {
    options = {
      serviceConfig = lib.mkOption {
        apply = opts: opts // {
          ExecStart = builtins.replaceStrings [ "/bin/redshift" ] [ "/bin/redshift-gtk" ] opts.ExecStart;
        };
      };
    };
    config = {};
  };
};
}
