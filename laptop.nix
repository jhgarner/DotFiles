{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "jackLaptop"; # Define your hostname.

  networking.interfaces.wlp7s0.useDHCP = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.libinput.clickMethod = "clickfinger";

  services.xserver.displayManager.setupCommands = ''
    xrdb -merge /home/jack/.Xresources
    xrandr --output eDP-1 --primary --mode 2560x1440
  '';

  services.xest.useIntel = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "19.09"; # Did you read the comment?
}
