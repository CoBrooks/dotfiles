{ pkgs, config, ... }: 
{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
    ];
    config = {
      theme = "ansi";
    };
  };
}
