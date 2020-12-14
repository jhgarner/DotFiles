{ config, pkgs, ... }:

{
  imports =
    [ 
      ./common.nix
      ./hardware-desktop.nix
      # ./hardware-laptop.nix
      ./desktop.nix
      # ./laptop.nix
    ];
}
