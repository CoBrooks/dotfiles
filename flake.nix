{
  description = "NixOS Config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iosevka-custom = {
      url = "path:./fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { 
    nixpkgs, 
    nixos-hardware,
    home-manager, 
    flake-utils, 
    rust-overlay, 
    nixos-generators,
    iosevka-custom,
    ... 
  }@inputs:
    let
      # Bring some functions into scope (from builtins and other flakes)
      inherit (builtins) attrValues;
      inherit (flake-utils.lib) eachSystemMap defaultSystems;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      eachDefaultSystemMap = eachSystemMap defaultSystems;
      
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ 
          rust-overlay.overlays.default 
          iosevka-custom.overlay
        ];
        config.allowUnfree = true;
      };

      inherit (import ./themes { inherit pkgs; }) getTheme;
      theme = getTheme { name = "gruvbox-material-dark-medium"; };
    in rec {
      nixosConfigurations = {
        cbrooks-framework = nixosSystem {
          inherit system pkgs;

          modules = [
            ./devices/framework.nix
            ./modules/nixos
            { 
              environment.systemPackages = [ 
                # Add Rust to system
                (pkgs.rust-bin.stable.latest.default.override {
                  extensions = ["rust-src"];
                  targets = ["wasm32-unknown-unknown"];
                })
                pkgs.gcc
              ];
            }
          ];
          specialArgs = { inherit inputs; };
        };
        cbrooks-macbook = nixosSystem {
          inherit system pkgs;

          modules = [
            ./devices/macbook.nix
            ./modules/nixos
            { 
              environment.systemPackages = [ 
                # Add Rust to system
                pkgs.rust-bin.stable.latest.default 
                pkgs.gcc
              ];
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = {
        "cbrooks@cbrooks-framework" = homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home.username = "cbrooks";
              home.homeDirectory = "/home/cbrooks";

              home.stateVersion = "22.11";

              nixpkgs.config.allowUnfree = true;

              programs.home-manager.enable = true;
              systemd.user.startServices = "sd-switch";
            }
            ./modules/home-manager
          ];

          extraSpecialArgs = { inherit theme; };
        };
        "cbrooks@cbrooks-macbook" = homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home.username = "cbrooks";
              home.homeDirectory = "/home/cbrooks";

              home.stateVersion = "22.11";

              nixpkgs.config.allowUnfree = true;

              programs.home-manager.enable = true;
              systemd.user.startServices = "sd-switch";
            }
            ./modules/home-manager
          ];

          extraSpecialArgs = { inherit theme; };
        };
      };

      # Packages
      # Accessible via 'nix build'
      packages = eachDefaultSystemMap (system:
        # Propagate nixpkgs' packages, with our overlays applied
        import nixpkgs { inherit system; }
      );

      # Devshell for bootstrapping
      # Accessible via 'nix develop'
      devShells = eachDefaultSystemMap (system: {
        default = import ./shell.nix { pkgs = packages.${system}; };
      });

      iso = nixos-generators.nixosGenerate {
        inherit pkgs;
        format = "install-iso";
      };
    };
}
