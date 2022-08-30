{ pkgs, config, theme, ... }: 
{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "alacritty";
      };
      font = {
        normal = {
          family = "Iosevka Custom";
        };
        size = 9.0;
      };
      window = {
        padding = {
          x = 2.0;
          y = 2.0;
        };
      };
      colors = theme;
    };
  };
}
