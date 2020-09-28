{lib, ...}:

{ config = {
  services.picom.enable = true;
  services.picom.backend = "glx";
  services.picom.fade = true;
  services.picom.inactiveOpacity = 0.9;
  services.picom.shadow = true;
  services.picom.vSync = true;
  services.picom.fadeDelta = 5;
  services.picom.settings = {
    detect-rounded-corners = true;
    detect-client-opacity = true;
    use-damage = false;
    blur = {
      method = "dual_kawase";
      strength = 10;
    };
    blur-background-exclude = "name *= \"slop\"";
    opacity-rule = [
      "75:class_g = 'xest-exe'"
    ];
  };


  nixpkgs.overlays = [
    (self: super: {
      picom = super.picom.overrideAttrs (old: {
        src = self.fetchFromGitHub {
          owner  = "yshui";
          repo   = "picom";
          rev    = "699ff9bc82fc8034dd9d5a1ac0f8810bbd4b06da";
          sha256 = "1cklyg656gc1gs004qnhhc2lpwipx5frn20w65484l57smjyjdck";
          fetchSubmodules = true;
        };
      });
    })
  ];

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
