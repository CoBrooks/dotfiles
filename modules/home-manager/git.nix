{ pkgs, config, ... }: 
{
  programs.git = {
    enable = true;
    userName = "CoBrooks";
    userEmail = "cole.brooks@colebrooks.com";
    ignores = [ "*~" "*.swp" ];
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}
