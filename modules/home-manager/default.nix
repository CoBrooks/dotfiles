# Add your home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).

{
  imports = [
    ./alacritty.nix
    ./bat.nix
    ./zsh.nix
    ./neovim/neovim.nix
    ./helix.nix
    ./i3status-rust.nix
    ./sway.nix
    ./git.nix
    ./wallpaper.nix
    ./direnv.nix
    ./firefox.nix
    ./dunst.nix
  ];
}
