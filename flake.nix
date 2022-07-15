{
  description = "NixOS Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Utilities for building our flake
    flake-utils.url = "github:numtide/flake-utils";

    # Extra flakes for modules, packages, etc
    hardware.url = "github:nixos/nixos-hardware"; # Convenience modules for hardware-specific quirks
    # nur.url = "github:nix-community/NUR";              # User contributed pkgs and modules
    # nix-colors.url = "github:misterio77/nix-colors";   # Color schemes for usage with home-manager
    # impermanence.url = "github:riscadoa/impermanence"; # Utilities for opt-in persistance

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, home-manager, flake-utils, rust-overlay, ... }@inputs:
    let
      # Bring some functions into scope (from builtins and other flakes)
      inherit (builtins) attrValues;
      inherit (flake-utils.lib) eachSystemMap defaultSystems;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      eachDefaultSystemMap = eachSystemMap defaultSystems;
      
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ rust-overlay.overlays.default ];
      };

      themes = import ./themes { inherit pkgs; };
      inherit (themes) getTheme;
      theme = getTheme { name = "gruvbox-material-dark-medium"; };
    in
    rec {
      # TODO: If you want to use packages exported from other flakes, add their overlays here.
      # They will be added to your 'pkgs'
      overlays = {
        default = import ./overlay; # Our own overlay
        # nur = nur.overlay
      };

      # System configurations
      # Accessible via 'nixos-rebuild'
      nixosConfigurations = {
        cbrooks-laptop = nixosSystem {
          inherit system;

          modules = [
            # >> Main NixOS configuration file <<
            ./nixos/configuration.nix
            # Adds your custom NixOS modules
            ./modules/nixos
            # Adds overlays
            { 
              nixpkgs.overlays = attrValues overlays; 
              environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
            }
          ];
          # Make our inputs available to the config (for importing modules)
          specialArgs = { inherit inputs; };
        };
      };

      # Home configurations
      # Accessible via 'home-manager'
      homeConfigurations = {
        "cbrooks@cbrooks-laptop" = homeManagerConfiguration {
          modules = [
            {
              home.username = "cbrooks";
              home.homeDirectory = "/home/cbrooks";

              home.stateVersion = "22.11";
            }
            # >> Main home-manager configuration file <<
            ./home-manager/home.nix
            # Adds your custom home-manager modules
            ./modules/home-manager
            # Adds overlays
            { nixpkgs.overlays = attrValues overlays; }
          ];

          pkgs = import nixpkgs {
            inherit system;
          };

          # Make our inputs available to the config (for importing modules)
          extraSpecialArgs = { inherit theme; };
        };
      };

      # Packages
      # Accessible via 'nix build'
      packages = eachDefaultSystemMap (system:
        # Propagate nixpkgs' packages, with our overlays applied
        import nixpkgs { inherit system; overlays = attrValues overlays; }
      );

      # Devshell for bootstrapping
      # Accessible via 'nix develop'
      devShells = eachDefaultSystemMap (system: {
        default = import ./shell.nix { pkgs = packages.${system}; };
      });
    };
}
