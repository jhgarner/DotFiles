# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  nix-alien-pkgs = import
    (
      fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
    )
    { };
  vscode-patched = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
in
{
  imports =
    [
      # Include the results of the hardware scan.
      (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
      # ./picom.nix
      ./icomoon.nix
      # ./goneovim.nix
      # ./xest.nix
      # ./directoryMover.nix
      # ./deadd-notification-center.nix
    ];

  nix = {
    binaryCaches = [
      "https://cache.nixos.org"
    ];
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

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

  hardware.opengl.driSupport32Bit = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # A whole bunch of programs to install
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; with nix-alien-pkgs;
    [
      wget
      vim
      mkpasswd
      neovim
      kitty
      rofi
      dunst
      google-chrome
      nox
      git
      git-secret
      feh
      mpv
      netcat-gnu
      arandr
      fzf
      polybarFull
      nodejs
      python3
      spotify
      discord
      pavucontrol
      ripgrep
      texlive.combined.scheme-full
      wine-staging
      networkmanagerapplet
      firefox
      texlab
      zoom-us
      nix-index
      libnotify
      wmctrl
      xorg.xprop
      xorg.xwininfo
      atool
      zip
      unzip
      tmux
      qpdf
      wireshark
      libreoffice-fresh
      gnumake
      brightnessctl
      cntr
      emacs
      yabar
      xtitle
      inkscape
      direnv
      xorg.xev
      cachix
      aspell
      godot_4
      aspellDicts.en
      gimp
      wesnoth
      htop
      lxappearance
      breeze-gtk
      breeze-qt5
      mumble
      xdotool
      obs-studio
      screenkey
      p7zip
      desmume
      inotify-tools
      citra
      dolphinEmu
      mgba
      libsecret
      gptfdisk
      pinentry
      htop
      bind
      iw
      kdenlive
      ffmpeg
      maim
      neo-cowsay
      patchelf
      lynx
      nix-direnv
      pciutils
      starship
      nixpkgs-fmt
      aseprite
      write_stylus
      xournalpp
      glxinfo
      lutris
      vulkan-tools
      gparted
      rnix-lsp
      networkmanager_dmenu
      traceroute
      pamixer
      alsaUtils
      pulseaudio
      kmail
      android-studio
      bat
      fd
      wally-cli
      zathura
      nix-index-update
      xorg.xinit
      distrobox
      xclip
      podman-compose
      dmenu
      i3status
      vscode-patched
      ldtk
      clang
      lazygit
      bat
      file
      just
      watchexec
      rustup
      neovide
      pandoc
      zlib
      barrier
    ];

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
      }
    '';
  };
  programs.steam.enable = true;
  security.rtkit.enable = true;
  programs.dconf.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  programs.gnupg.agent.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 1122 ];
  };

  # Disable the firewall altogether.
  networking.firewall.enable = false;

  hardware.pulseaudio.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbVariant = "3l";
  # services.xserver.windowManager.i3.enable = true;

  # Add GDM and Gnome3 because I don't trust Xest...
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  # programs.gnome-terminal.enable = true;
  # services.xserver.displayManager.gdm.nvidiaWayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # I keep this around for easy testing
  services.xserver.windowManager.session = [{
    name = "xest";
    start = ''
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
    group = "jack";
    extraGroups = [ "testing" "wheel" "networkmanager" "video" "adbusers" "docker" "wireshark" "plugdev" "input" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  users.groups = { jack = { }; };


  services.xserver.desktopManager.wallpaper.mode = "scale";

  # Configuring fonts is easy!
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
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
    (nerdfonts.override { fonts = [ "CascadiaCode" "FiraCode" ]; })
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

  virtualisation.virtualbox.host.enable = true;
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;
  };

  users.extraGroups.vboxusers.members = [ "jack" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.digimend.enable = true;
  hardware.keyboard.zsa.enable = true;

  boot.supportedFilesystems = [ "ntfs" ];
  hardware.nvidia.modesetting.enable = true;

  # programs.ssh.askPassword = lib.mkForce "/nix/store/723flhqgay8zb3widckwrwywicq2rnr0-seahorse-43.0/libexec/seahorse/ssh-askpass";
  networking.interfaces.enp8s0.wakeOnLan.enable = true;
  programs.mosh.enable = true;

  networking.nat.enable = true;
  networking.nat.externalInterface = "enp8s0";
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
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
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
  hardware.nvidia.powerManagement.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';
  # systemd.tmpfiles.rules = [ "L+ /usr/ - - - - /run/current-system/sw/" ];
  services.flatpak.enable = true;
  # services.vscode-server.enable = true;
  services.acpid.enable = lib.mkForce false;
  services.sysprof.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "jack";
  services.xserver.displayManager.job.preStart = "sleep 5";
}

