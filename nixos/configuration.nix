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
      ./cachix.nix
      ./xest.nix
    ];

  nix = {
    binaryCaches = [
      "https://cache.nixos.org"
      "https://cache.dhall-lang.org"
      "https://dhall.cachix.org"
      "https://hydra.iohk.io"
    ];

    binaryCachePublicKeys = [
      "cache.dhall-lang.org:I9/H18WHd60olG5GsIjolp7CtepSgJmM2CsO813VTmM="
      "dhall.cachix.org-1:8laGciue2JBwD49ICFtg+cIF8ddDaW7OFBjDb/dHEAo="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  nixpkgs.overlays = [
    (self: super: {
      picom = super.picom.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner  = "tryone144";
          repo   = "picom";
          rev    = "9b4a6f062758f1f9a66d4e77d16c86c9aa259b42";
          sha256 = "0jf1lih85d07q1kw1v3sa4azjyf33b61kkxjakb2l6zi8fcxf4s9";
          fetchSubmodules = true;
        };
      });
      neovim = super.neovim-unwrapped.overrideAttrs (old: {
        version = "0.5.0";
        src = pkgs.fetchFromGitHub {
          owner = "neovim";
          repo = "neovim";
          rev = "c1d395a6d664933ec7a644362721db115efef664";
          sha256 = "0v7m82jr6b6pmn9n8rfq35jypm6m6vhbr6ln2arxlyv2xzlavffh";
        };
      });
    })
  ];


  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "bcachefs" "ext4" ];
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "jackDesktop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via NetworkManager
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;
  networking.networkmanager.dhcp = "internal";
  networking.dhcpcd.enable = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.opengl.driSupport32Bit = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs;
    [ wget vim mkpasswd neovim kitty rofi dunst google-chrome nox git feh redshift zathura mpv netcat-gnu arandr fzf polybarFull nodejs-12_x python37 spotify element-desktop discord steam pavucontrol hicolor-icon-theme ripgrep texlive.combined.scheme-full wine-staging networkmanagerapplet firefox texlab zoom-us nix-index libnotify wmctrl xorg.xprop xorg.xwininfo atool zip unzip tmux qpdf wireshark libreoffice-fresh gnumake brightnessctl cntr emacs yabar xtitle inkscape direnv xlibs.xev cachix aspell godot aspellDicts.en vscode gimp wesnoth htop lxappearance breeze-gtk breeze-qt5 obs-studio screenkey xdotool kdenlive ffmpeg maim neo-cowsay gnupg p7zip mumble patchelf
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "3l";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
services.xserver.windowManager.session = [{
    name  = "xest";
    start = ''
      xrandr --output DP-0 --mode 1920x1080 -r 144
      /home/jack/.local/bin/xest-exe &> /home/jack/.xtest.txt &
      waitPID=$!
    '';
  }];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  users.mutableUsers = false;
  users.users.jack = {
    isNormalUser = true;
    home = "/home/jack";
    hashedPassword = "$6$0ezGsg1cC$KoCnA3QoxZ0UzF2gAOca3m9Ura8Gnb389RJg5XWcqTdMI3t6sJUJrlSPyUOwuh2v401L2a5Ot5Pv4OfgaHcGE1";
    extraGroups = [ "wheel" "networkmanager" "video" "adbusers" "docker"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  services.xserver.desktopManager.wallpaper.mode = "scale";
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
  ];
  fonts.fontconfig.defaultFonts.monospace = ["Fira Code Nerd Font"];


  services.blueman.enable = true;
  programs.nm-applet.enable = true;
  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  services.picom.enable = true;
  services.picom.backend = "glx";
  services.picom.fade = true;
  services.picom.inactiveOpacity = 0.9;
  services.picom.shadow = true;
  services.picom.vSync = true;
  services.picom.fadeDelta = 5;
  services.picom.settings = {
    # glx-no-stencil = true;
    # glx-copy-from-front = false;
    # mark-wmwin-focused = true;
    # mark-ovredir-focused = true;
    detect-rounded-corners = true;
    detect-client-opacity = true;
    use-damage = false;
    # inactive-opacity-override = true;
    # xrendr-sync-fence = true;
    # force-win-blend = true;
    blur = {
      method = "dual_kawase";
      # size = 100;
      strength = 10;
    };
    blur-background-exclude = "name *= \"slop\"";
    # vsync = "opengl-swc";
  };

  # systemd.user.services.picom = {...}: {
  #   options = {
  #     ExecStart = pkgs.lib.mkOption {
  #       apply = {}; # opts: opts // { ExecStart = opts.ExecStart + " test"; };
  #     };
  #   };
  # };
    # pkgs.lib.mkIf systemd.user.services.picom.serviceConfig.ExecStart.picomExperimental {
    # picomExperimental = true;
    # systemd.user.services.picom.serviceConfig.ExecStart =  systemd.user.services.picom.serviceConfig.ExecStart + " test";
  # };

  location.provider = "geoclue2";
  services.redshift.enable = true;

  programs.ssh.startAgent = true;

  services.teamviewer.enable = true;

  services.lorri.enable = true;

  services.hardware.xow.enable = true;

  services.xinetd.enable = true;
  services.xinetd.services = [
    { name = "svn"; unlisted = true; port = 80;
      server = "/usr/bin/env"; # not used if "redirect" is specified, but required by Nixos, *and* must be executable
      extraConfig = "redirect = localhost 3000";
    }
  ];

  programs.java.enable = true;
  services.directoryMover.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

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

