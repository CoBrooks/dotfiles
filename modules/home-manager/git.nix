{ pkgs, config, ... }: 
{
  programs.git = {
    enable = true;
    userName = "CoBrooks";
    userEmail = "cole.brooks@colebrooks.com";
    ignores = [
      # Vim
      "*~"
      "*.swp"
      # NixOs
      "shell.nix"
      "flake.nix"
      "flake.lock"
      ".direnv/"
      ".envrc"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}
