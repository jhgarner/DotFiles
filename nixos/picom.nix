{lib, ...}:

{ config = {
    systemd.user.services.picom = {...}: {
      options = {
         serviceConfig = lib.mkOption {
           apply = opts: opts // {ExecStart = opts.ExecStart + " --experimental-backends";};
         };
      };
      config = {};
    };
  };
}
