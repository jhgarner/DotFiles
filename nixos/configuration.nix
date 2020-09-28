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
      ./redshift.nix
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
      discord = super.discord.overrideAttrs (old: rec {
        version = "0.0.12";
        src = self.fetchurl {
          url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
          sha256 = "0qrzvc8cp8azb1b2wb5i4jh9smjfw5rxiw08bfqm8p3v74ycvwk8";
        };
      });
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

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "bcachefs" "ext4" ];

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Define my hostname and networking
  networking.hostName = "jackDesktop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via NetworkManager

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
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
    [ wget vim mkpasswd neovim kitty rofi dunst google-chrome nox git feh zathura mpv netcat-gnu arandr fzf polybarFull nodejs-12_x python37 spotify element-desktop discord steam pavucontrol hicolor-icon-theme ripgrep texlive.combined.scheme-full wine-staging networkmanagerapplet firefox texlab zoom-us nix-index libnotify wmctrl xorg.xprop xorg.xwininfo atool zip unzip tmux qpdf wireshark libreoffice-fresh gnumake brightnessctl cntr emacs yabar xtitle inkscape direnv xlibs.xev cachix aspell godot aspellDicts.en vscode gimp wesnoth htop lxappearance breeze-gtk breeze-qt5 obs-studio screenkey xdotool kdenlive ffmpeg maim neo-cowsay gnupg p7zip mumble patchelf kdeApplications.kmag lynx
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

  # Add GDM and Gnome3 because I don't trust Xest...
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  # I keep this around for easy testing
  services.xserver.windowManager.session = [{
    name  = "xest";
    start = ''
      xrandr --output DP-0 --mode 1920x1080 -r 144
      /home/jack/.local/bin/xest-exe &> /home/jack/.xtest.txt &
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
  # services.redshift.package =
  #   let redshift-gtk = pkgs.redshift.overrideAttrs(old: {
  #     pname = "fake-redshift";
  #     preFixup = "
  #     mv $out/bin/redshift-gtk $out/bin/redshift
  #     ";
  #   });
  #   in redshift-gtk;

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

