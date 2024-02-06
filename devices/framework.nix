# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {

  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.framework

    # It's strongly recommended you take a look at
    # https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware.

    # Import your generated (nixos-generate-config) hardware configuration
    ../hardware/framework.nix

    # You can also split up your configuration and import pieces of it here.
  ];

  config = {
    # This will add your inputs as registries, making operations with them (such
    # as nix shell nixpkgs#name) consistent with your flake inputs.
    nix.registry = lib.mapAttrs' (n: v: lib.nameValuePair n { flake = v; }) inputs;

    # Will activate home-manager profiles for each user upon login
    # This is useful when using ephemeral installations
    environment.loginShellInit = ''
      [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
    '';

    nix = {
      # Make sure we have at least nix 2.4
      package = pkgs.nixFlakes;
      # Enable flakes and new 'nix' command
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
        experimental-features = nix-command flakes
      '';
      settings.auto-optimise-store = true;
    };

    networking.hostName = "cbrooks-framework";
    networking.wireless.iwd.enable = true;
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";

    time.timeZone = "US/Central";
    i18n.defaultLocale = "en_US.UTF-8";
    console.font = "Lat2-Terminus16";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    programs.sway.enable = true;
    programs.zsh.enable = true;

    virtualisation.docker.enable = true;
    virtualisation.docker.daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "2001:db8:1::/64";
      features = {
        buildkit = true;
      };
    };

    # sound.enable = true;
    # hardware.pulseaudio.enable = true;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.openssh ={
      enable = true;
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
      };
      openFirewall = true;
      ports = [ 22022 ];
    };

    xdg.portal.enable = true;
    xdg.portal.wlr.enable = true;

    users.users.cbrooks = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtkbDBxaQlTeTx5PATQ5Q/O2DsdXlvr4bqS3JFhN2ML cbrooks@DESKTOP-36KM1EJ"
      ];
    };

    environment.systemPackages = with pkgs; [
      vim 
      wget
      git
      neofetch
      tree
      wl-clipboard # Wayland copy-paste
      ripgrep
      bottom
      file
      man-pages
      man-pages-posix
    ];

    environment.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

    environment.pathsToLink = [ "/share/zsh" ];

    documentation = {
      enable = true;
      dev.enable = true;
      doc.enable = true;

      man.enable = true;
      man.generateCaches = true;
    };

    system.stateVersion = "22.11";
  };
}
