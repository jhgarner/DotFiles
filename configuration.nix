# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  environment.pathsToLink = ["/include" "/lib"];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # environment.ldso = "${pkgs.clang.libc_bin}/bin/ld.so";
  # environment.ldso32 = "${pkgs.clang.libc_bin}/bin/ld.so";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.graphics.enable32Bit = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs;
  [
      # Desktop
      # gnome-tweaks
      i3
      rofi
      dunst
      polybarFull
      networkmanagerapplet
      wl-clipboard
      lxappearance
      pinentry
      screenkey
      networkmanager_dmenu
      xclip
      podman-compose
      dmenu
      i3status
      barrier
      mako
      fuzzel
      swaylock
      waybar
      xwayland-satellite
      overskride
      nautilus
      # Gui
      kitty
      alacritty
      neovide
      firefox
      google-chrome
      feh
      mpv
      fzf
      spotify
      discord
      pavucontrol
      wine-staging
      wireshark
      libreoffice-fresh
      emacs
      inkscape
      gimp
      wesnoth
      mumble
      obs-studio
      kdePackages.kdenlive
      aseprite
      gparted
      vscode
      ldtk
      zathura
      # Terminal
      neovim
      vim
      wget
      mkpasswd
      starship
      bc
      git
      git-secret
      gh
      clang.bintools
      lazygit
      file
      just
      watchexec
      netcat-gnu
      ripgrep
      atool
      zip
      unzip
      tmux
      qpdf
      gnumake
      brightnessctl
      aspell
      aspellDicts.en
      p7zip
      htop
      bind
      ffmpeg
      iw
      gptfdisk
      pciutils
      patchelf
      bat
      fd
      wally-cli
      pandoc
      ## Xorg stuff
      wmctrl
      xorg.xprop
      xorg.xwininfo
      xtitle
      xorg.xev
      xdotool
      # Language
      deno
      nodejs
      python3
      rustup
      nil
      jq
      # Libs
      ncurses
      zlib
      gmp
      texlive.combined.scheme-full
      libnotify
      libsecret
      glibc.out
      glibc.dev
      libcxx.out
      (runCommand "copied-gcc-lib" {} ''
          mkdir -p $out/
          cd $out
          cp -r -L ${gcc.cc.out}/. ./
          chmod -R +w .
          rm -r ./bin/
          cp -r -L ${gcc.cc.lib}/. ./
          chmod -R +w .
          mkdir -p ./include/c++
          cp -r -L ${libcxx.dev}/include/c++/v1/. ./include/c++
          chmod -R +w .
      '')
      (runCommand "copied-clang" {} ''
          mkdir -p $out/
          cd $out
          cp -r -L ${clang.cc.dev}/* ./
          chmod -R +w .
          cp -r -L ${clang.cc.out}/* ./
          chmod -R +w .
          cp -r -L ${clang.cc.lib}/* ./
          chmod -R +w .
      '')
    ];

  programs.steam.enable = true;
  security.rtkit.enable = true;
  programs.dconf.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.gnupg.agent.enable = true;
  programs.direnv.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 1122 ];
  };

  # Disable the firewall altogether.
  networking.firewall.enable = false;


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  # services.xserver.xkbVariant = "3l";
  # services.xserver.windowManager.i3.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  # programs.gnome-terminal.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  programs.niri.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  # programs.hyprland.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.sddm.enable = true;

  # Fully embrace immutability
  users.mutableUsers = false;
  users.users.jack = {
    isNormalUser = true;
    home = "/home/jack";
    hashedPassword = "$6$0ezGsg1cC$KoCnA3QoxZ0UzF2gAOca3m9Ura8Gnb389RJg5XWcqTdMI3t6sJUJrlSPyUOwuh2v401L2a5Ot5Pv4OfgaHcGE1";
    group = "jack";
    extraGroups = [ "testing" "wheel" "networkmanager" "video" "adbusers" "docker" "wireshark" "plugdev" "input" "uinput" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  users.groups = { jack = { }; };

  services.xserver.desktopManager.wallpaper.mode = "scale";

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    dejavu_fonts
    unifont
    source-code-pro
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    font-awesome
    emacs-all-the-icons-fonts
    cascadia-code
  ];
  fonts.fontconfig.defaultFonts.monospace = [ "Cascadia Code" ];


  # A whole bunch of random stuff
  # services.blueman.enable = true;

  # programs.nm-applet.enable = true;

  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;

  location.provider = "manual";
  location.latitude = 50.0;
  location.longitude = -110.0;
  # services.redshift.enable = true;
  # services.redshift.executable = "/bin/redshift-gtk";

  # programs.ssh.startAgent = true;

  programs.java.enable = true;

  # services.directoryMover.enable = true;

  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;
  };

  hardware.keyboard.zsa.enable = true;

  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # programs.ssh.askPassword = lib.mkForce "/nix/store/723flhqgay8zb3widckwrwywicq2rnr0-seahorse-43.0/libexec/seahorse/ssh-askpass";
  programs.mosh.enable = true;

  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "wg0" ];
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';
  # systemd.tmpfiles.rules = [ "L+ /usr/ - - - - /run/current-system/sw/" ];
  services.flatpak.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    gmp
    ncurses
    zlib
    zstd
    clang.cc.lib
    (runCommand "copied-gcc" {} ''
        mkdir -p $out/
        cd $out
        cp -r -L ${gcc.cc.out}/. ./
        chmod -R +w .
        cp -r -L ${gcc.cc.lib}/. ./
        chmod -R +w .
        cp -r -L ${libcxx.dev}/include/c++/v1/. ./include/c++
        chmod -R +w .
    '')
    clang.cc.out
    clang.libc
    libcxx.out
    # libcxx.dev
    # clang.libcxx
    # stdenv.cc.cc
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd
    ncurses
    xorg.libxcb
    xorg.xcbutilwm
  ];

  # xremap
  
  systemd.user.services.xremap =
    let
      toggleWaybar = ["${pkgs.procps}/bin/pkill" "-SIGUSR1" "waybar"];
      config = {
        modmap = [
          {
            remap = {
              LeftMeta.press.launch = toggleWaybar;
              LeftMeta.release.launch = toggleWaybar;
            };
          }
        ];
        keymap = [];
      };
      start = "${pkgs.xremap}/bin/xremap ${(pkgs.formats.yaml {}).generate "xremapConfig.yml" config}";
    in {
      description = "xremap user service";
      path = [ pkgs.xremap ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = lib.mkMerge [
        {
          KeyringMode = "private";
          SystemCallArchitectures = [ "native" ];
          RestrictRealtime = true;
          ProtectSystem = true;
          SystemCallFilter = map (x: "~@${x}") [
            "clock"
            "debug"
            "module"
            "reboot"
            "swap"
            "cpu-emulation"
            "obsolete"
            # NOTE: These two make the spawned processes drop cores
            # "privileged"
            # "resources"
          ];
          LockPersonality = true;
          UMask = "077";
          RestrictAddressFamilies = "AF_UNIX";
          ExecStart = start;
        }
      ];
    };


}
