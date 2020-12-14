# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./picom.nix
      ./directoryMover.nix
      # ./xest.nix
      ./redshift.nix
      ./desktop.nix
      # ./laptop.nix
    ];

  nix = {
    binaryCaches = [
      "https://cache.nixos.org"
      "https://cache.dhall-lang.org"
      "https://dhall.cachix.org"
    ];

    binaryCachePublicKeys = [
      "cache.dhall-lang.org:I9/H18WHd60olG5GsIjolp7CtepSgJmM2CsO813VTmM="
      "dhall.cachix.org-1:8laGciue2JBwD49ICFtg+cIF8ddDaW7OFBjDb/dHEAo="
    ];
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs.overlays = [
    (self: super: {
      neovim = super.neovim-unwrapped.overrideAttrs (old: {
        version = "0.5.0";
        src = self.fetchFromGitHub {
          owner = "neovim";
          repo = "neovim";
          rev = "c1d395a6d664933ec7a644362721db115efef664";
          sha256 = "0v7m82jr6b6pmn9n8rfq35jypm6m6vhbr6ln2arxlyv2xzlavffh";
        };
      });
    })
  ];

  networking.networkmanager.enable = true;  # Enables wireless support via NetworkManager

  networking.useDHCP = false;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;
  networking.networkmanager.dhcp = "internal";
  networking.dhcpcd.enable = false;

  hardware.opengl.driSupport32Bit = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # A whole bunch of programs to install
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs;
    [ wget vim mkpasswd neovim kitty rofi dunst google-chrome nox git feh zathura mpv netcat-gnu arandr fzf polybarFull nodejs-12_x python37 spotify element-desktop discord steam pavucontrol hicolor-icon-theme ripgrep texlive.combined.scheme-full wine-staging networkmanagerapplet firefox texlab zoom-us nix-index libnotify wmctrl xorg.xprop xorg.xwininfo atool zip unzip tmux qpdf wireshark libreoffice-fresh gnumake brightnessctl cntr emacs yabar xtitle inkscape direnv xlibs.xev cachix aspell godot aspellDicts.en vscode gimp wesnoth htop lxappearance breeze-gtk breeze-qt5 obs-studio screenkey xdotool kdenlive ffmpeg maim neo-cowsay gnupg p7zip mumble patchelf kdeApplications.kmag lynx nix-direnv
    ];

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "3l";
  services.xserver.windowManager.i3.enable = true;

  # Add GDM and Gnome3 because I don't trust Xest...
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  # I keep this around for easy testing
  services.xserver.windowManager.session = [{
    name  = "xest";
    start = ''
      xrandr --output DP-0 --mode 1920x1080 -r 144
      /home/jack/.local/bin/xest-exe &
      waitPID=$!
    '';
  }];

  # Fully embrace immutability
  users.mutableUsers = false;
  users.users.jack = {
    isNormalUser = true;
    home = "/home/jack";
    hashedPassword = "$6$0ezGsg1cC$KoCnA3QoxZ0UzF2gAOca3m9Ura8Gnb389RJg5XWcqTdMI3t6sJUJrlSPyUOwuh2v401L2a5Ot5Pv4OfgaHcGE1";
    extraGroups = [ "wheel" "networkmanager" "video" "adbusers" "docker"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.adb.enable = true;

  services.xserver.desktopManager.wallpaper.mode = "scale";

  # Configuring fonts is easy!
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
    dejavu_fonts
    unifont
    source-code-pro
    nerdfonts
    font-awesome
    emacs-all-the-icons-fonts
    cascadia-code
  ];
  fonts.fontconfig.defaultFonts.monospace = ["Cascadia Code"];


  # A whole bunch of random stuff
  services.blueman.enable = true;

  programs.nm-applet.enable = true;

  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;

  location.provider = "geoclue2";
  services.redshift.enable = true;

  programs.ssh.startAgent = true;

  services.hardware.xow.enable = true;

  # services.xinetd.enable = true;
  # services.xinetd.services = [
  #   { name = "svn"; unlisted = true; port = 80;
  #     server = "/usr/bin/env"; # not used if "redirect" is specified, but required by Nixos, *and* must be executable
  #     extraConfig = "redirect = localhost 3000";
  #   }
  # ];

  programs.java.enable = true;

  services.directoryMover.enable = true;

  virtualisation.virtualbox.host.enable = true;

  users.extraGroups.vboxusers.members = [ "jack" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

