{pkgs, ...}:

{ config = {
  systemd.user.services.picom.wantedBy = pkgs.lib.mkForce [];
  services.picom.enable = true;
  services.picom.backend = "glx";
  services.picom.fade = true;
  services.picom.inactiveOpacity = 0.9;
  services.picom.shadow = true;
  services.picom.vSync = true;
  services.picom.fadeDelta = 5;
  services.picom.experimentalBackends = true;
  services.picom.shadowExclude = [
    "name = 'cpt_frame_window'"
    "name = 'as_toolbar'"
    "name = 'zoom_linux_float_video_window'"
    "name = 'AnnoInputLinux'"
  ];
  services.picom.settings = {
    detect-rounded-corners = true;
    detect-client-opacity = true;
    use-damage = false;
    blur = {
      method = "dual_kawase";
      strength = 10;
    };
    blur-background-exclude = [
      "name *= 'slop'"
      "name = 'cpt_frame_window'"
      "name = 'as_toolbar'"
      "name = 'zoom_linux_float_video_window'"
      "name = 'AnnoInputLinux'"
    ];
    opacity-rule = [
      "50:class_g = 'xest-exe'"
    ];
  };


  nixpkgs.overlays = [
    (self: super: {
      picom = super.picom.overrideAttrs (old: {
        src = self.fetchFromGitHub {
          owner  = "yshui";
          repo   = "picom";
          rev    = "7ba87598c177092a775d5e8e4393cb68518edaac";
          sha256 = "0za3ywdn27dzp7140cpg1imbqpbflpzgarr76xaqmijz97rv1909";
          fetchSubmodules = true;
        };
      });
    })
  ];
};
}
