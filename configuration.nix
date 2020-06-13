# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.udev.packages = [ pkgs.android-udev-rules ];
  programs.adb.enable = true;

  networking.hostName = "jackLaptop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via NetworkManager

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.networkmanager.dhcp = "internal";
  networking.interfaces.wlp7s0.useDHCP = true;
  networking.dhcpcd.enable = false;
  hardware.opengl.driSupport32Bit = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget vim mkpasswd neovim kitty rofi dunst google-chrome nox git feh redshift zathura mpv netcat-gnu arandr fzf polybar nodejs-12_x python37 spotify riot-desktop discord steam pavucontrol gnome3.adwaita-icon-theme hicolor-icon-theme ripgrep texlive.combined.scheme-full wine-staging networkmanagerapplet firefox texlab zoom-us nix-index libnotify wmctrl xorg.xprop xorg.xwininfo atool zip unzip tmux qpdf wireshark libreoffice-fresh gnumake brightnessctl cntr emacs yabar xtitle inkscape direnv xlibs.xev cachix aspell godot aspellDicts.en vscode
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.libinput.clickMethod = "clickfinger";

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.setupCommands = ''
    xrdb -merge /home/jack/.Xresources
    xrandr --output eDP-1 --primary --mode 2560x1440
  '';
  services.xserver.desktopManager.gnome3.enable = true;
  # services.xserver.windowManager.i3.extraSessionCommands = "xrandr --output eDP-1 --primary --mode 2560x1440";
  services.xserver.windowManager.session = [{
    name  = "xest";
    start = ''
      ${pkgs.xorg.xrandr} --output eDP-1 --primary --mode 2560x1440
      /home/jack/.local/bin/neXtWM-exe 0 &
      waitPID=$!
    '';
  }];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.jack = {
    isNormalUser = true;
    home = "/home/jack";
    hashedPassword = "$6$0ezGsg1cC$KoCnA3QoxZ0UzF2gAOca3m9Ura8Gnb389RJg5XWcqTdMI3t6sJUJrlSPyUOwuh2v401L2a5Ot5Pv4OfgaHcGE1";
    extraGroups = [ "wheel" "networkmanager" "video" "adbusers"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # networking.firewall.enable = false;
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
  fonts.fontconfig.defaultFonts.monospace = ["Fira Code"];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

  services.blueman.enable = true;
  programs.nm-applet.enable = true;
  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  services.picom.enable = true;
  services.picom.backend = "glx";
  services.picom.fade = true;
  services.picom.inactiveOpacity = 0.95;
  services.picom.shadow = true;
  services.picom.vSync = true;
  services.picom.fadeDelta = 5;

  location.provider = "geoclue2";
  services.redshift.enable = true;

  programs.ssh.startAgent = true;

  services.teamviewer.enable = true;

  services.lorri.enable = true;

  services.xinetd.enable = true;
  services.xinetd.services = [
    { name = "svn"; unlisted = true; port = 80;
      server = "/usr/bin/env"; # not used if "redirect" is specified, but required by Nixos, *and* must be executable
      extraConfig = "redirect = localhost 3000";
    }
  ];

  programs.java.enable = true;
}

