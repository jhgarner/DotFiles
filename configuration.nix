{ config, pkgs, ... }:

{
  imports =
    [ 
      ./cachix.nix
      ./common.nix
      # ./hardware-desktop.nix
      ./hardware-laptop.nix
      # ./desktop.nix
      ./laptop.nix
    ];
}
