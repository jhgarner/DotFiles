{
  description = "My NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Or a specific NixOS channel
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Home Manager uses the same nixpkgs
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.jackDesktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix # Your main NixOS configuration file
        # home-manager.nixosModules.default
        # Add other modules here
      ];
      specialArgs = { inherit self nixpkgs home-manager inputs; }; # Pass flake inputs to modules
    };
  };
}
