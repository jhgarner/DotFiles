{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "jackLaptop"; # Define your hostname.


  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.libinput.clickMethod = "clickfinger";

  services.xserver.displayManager.setupCommands = ''
    xrdb -merge /home/jack/.Xresources
    xrandr --output eDP-1 --primary --mode 2560x1440
  '';
}
