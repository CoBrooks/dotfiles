{ pkgs, config, ... }: 
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      theme = "clean";
    };
    shellAliases = {
      gl = "git log --pretty=format:'%C(3)%t: %C(2)%an%n %s%n' --graph --shortstat";
      tree = "tree --gitignore --dirsfirst";
    };
  };
}
