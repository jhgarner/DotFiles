# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  environment.pathsToLink = ["/include" "/lib"];
  nixpkgs.overlays = [
    (self: super: {
      cascadia-code = pkgs.fetchzip {
        postFetch = ''
          mkdir -p $out/share/fonts/
          unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
          unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
        '';

        name = "cascadia-code-2102.25";

        url = "https://github.com/microsoft/cascadia-code/releases/download/v2102.25/CascadiaCode-2102.25.zip";

        sha256 = "14qhawcf1jmv68zdfbi2zfqdw4cf8fpk7plxzphmkqsp7hlw9pzx";
      };
    })
  ];
  services.udev.packages = [ pkgs.android-udev-rules ];
  programs.adb.enable = true;

  networking.networkmanager.enable = true; # Enables wireless support via NetworkManager

  hardware.graphics.enable32Bit = true;
  boot.loader.systemd-boot.memtest86.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # A whole bunch of programs to install
  nixpkgs.config.allowUnfree = true;

  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;



  environment.systemPackages = with pkgs;
  [
      # Desktop
      gnome-tweaks
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
      git
      git-secret
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
  services.xserver.desktopManager.gnome.enable = true;
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
    extraGroups = [ "testing" "wheel" "networkmanager" "video" "adbusers" "docker" "wireshark" "plugdev" "input" ]; # Enable ‘sudo’ for the user.
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

  programs.ssh.startAgent = true;

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
  networking.nat.externalInterface = "enp9s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51821;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp9s0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp9s0 -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/jack/wireguard-keys/private";

      peers = [
        # List of allowed peers.
        {
          # Phone
          # Public key of the peer (not a file path).
          publicKey = "m/BtoupKxcEYBj3v1GE6laLIOXObLslgZLsY/S1qyEk=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          # Phone
          # Public key of the peer (not a file path).
          publicKey = "/vilJboxgJEn04D5vKYL7Wd6F2Qi91etDUfxEGbFLzY=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';
  # systemd.tmpfiles.rules = [ "L+ /usr/ - - - - /run/current-system/sw/" ];
  services.flatpak.enable = true;
  # services.vscode-server.enable = true;
  services.acpid.enable = lib.mkForce false;
  services.sysprof.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jack";
  services.displayManager.preStart = "sleep 5";
  networking.hostName = "jackDesktop"; # Define your hostname.
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   gmp
  #   ncurses
  #   zlib
  #   zstd
  #   clang.cc.lib
  #   (runCommand "copied-gcc" {} ''
  #       mkdir -p $out/
  #       cd $out
  #       cp -r -L ${gcc.cc.out}/. ./
  #       chmod -R +w .
  #       cp -r -L ${gcc.cc.lib}/. ./
  #       chmod -R +w .
  #       cp -r -L ${libcxx.dev}/include/c++/v1/. ./include/c++
  #       chmod -R +w .
  #   '')
  #   clang.cc.out
  #   clang.libc
  #   # libcxx.out
  #   # libcxx.dev
  #   # clang.libcxx
  #   # stdenv.cc.cc
  #   curl
  #   openssl
  #   attr
  #   libssh
  #   bzip2
  #   libxml2
  #   acl
  #   libsodium
  #   util-linux
  #   xz
  #   systemd
  #   ncurses
  #   xorg.libxcb
  #   xorg.xcbutilwm
  # ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

